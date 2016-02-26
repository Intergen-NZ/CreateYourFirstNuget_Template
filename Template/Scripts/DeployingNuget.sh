# Gets Version from AsseblyInfo.cs updates nuspec's version

declare regex="AssemblyVersion\(\"([0-9]+.[0-9]+.[0-9]+.[0-9]+)\"\)"
declare file_content=$( cat $AssemblyFilePath)

if [[ " $file_content " =~ $regex ]] # please note the space before and after the file content
	then
		sed -i "s|\(<version>\)[^<>]*\(</version>\)|\1${BASH_REMATCH[1]}\2|g" $ProjectName.nuspec
	else
		echo "Have not updated version of NuGet Package"
		exit 1
fi

nuget pack $ProjectName.nuspec
export ReleaseFile=$(ls $ProjectName.*.nupkg)

if [[ ${Is_Uploading_Nuget_To_Private_Server,,} == "true" ]]; then 
		echo "Deploying $ReleaseFile to private hosting server" 
		nuget push $ReleaseFile -s $Private_Nuget_Server_URL $Private_Nuget_API_Key
fi

if [[ ${Is_Uploading_Nuget_To_Public_Serever,,} == "true" ]]; then 
		echo "Deploying $ReleaseFile to public hosting server" 
		nuget push $ReleaseFile $Public_Nuget_API_Key
fi