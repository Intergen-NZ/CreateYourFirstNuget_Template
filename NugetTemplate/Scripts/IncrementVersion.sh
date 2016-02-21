#Updates AssemblyInfo.cs version.
#Major and Minor have to be updated manually.

echo "Adjusting AssemblyVersion from:"
tail -2 $TRAVIS_BUILD_DIR/$AssemblyFilePath  | head -1 

# Updates AssemblyVersion for Nuget creation.
sed -ri "s/AssemblyVersion\(\"([0-9]+.[0-9]+.)[0-9]+.[0-9]+\"\)/AssemblyVersion(\"\1${TRAVIS_BUILD_NUMBER}.0\")/g" $AssemblyFilePath

echo "Adjusted AssemblyVersion to:"
tail -2 $TRAVIS_BUILD_DIR/$AssemblyFilePath  | head -1 