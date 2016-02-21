# Gets Version from AsseblyInfo.cs updates nuspec's version

declare regex="AssemblyVersion\(\"([0-9]+.[0-9]+.[0-9]+.[0-9]+)\"\)"
declare file_content=$( cat $AssemblyFilePath)

if [[ " $file_content " =~ $regex ]] # please note the space before and after the file content
	then
		sed -i "s|\(<version>\)[^<>]*\(</version>\)|\1${BASH_REMATCH[1]}\2|g" $PackageName.nuspec
	else
		echo "Have not updated version of NuGet Package"
		exit 1
fi


nuget pack $PackageName.nuspec 
export ReleaseFile=$(ls $PackageName.*.nupkg)
echo "Deploying $ReleaseFile to private hosting server" 
nuget push $ReleaseFile -s $Private_Nuget_Url $Private_Nuget_API_Key

if [[ ${isPublic,,} == "true" ]]; then 
		echo "Deploying $ReleaseFile to public hosting server" 
		nuget push $ReleaseFile $Public_Nuget_API_KEY
fi 