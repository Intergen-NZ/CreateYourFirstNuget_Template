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

if [[ ${IsUploadingNugetToPrivateServer,,} == "true" ]]; then 
		echo "Deploying to private hosting server" 
		nuget push ./*.nupkg -s $PrivateNugetServerURL $PrivateNugetAPIKey
fi

if [[ ${IsUploadingNugetToPublicServer,,} == "true" ]]; then 
		echo "Deploying to public hosting server" 
		nuget push ./*.nupkg $PublicNugetAPIKey
fi