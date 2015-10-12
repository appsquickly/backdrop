#About

Backdrop is a utility for configuring an application's Info.plist file for separate environments. It can be used: 

* In dev environments for quickly switching between dev, staging, production environments. 
* On continuous integration build servers to automate deployment of pre-configured builds. 

#How Does it Work?

* We create an <a href="https://github.com/appsquickly/backdrop/blob/master/EnvFile.plist">`EnvFile.plist`</a> that declares the properties (icon file, TyphoonConfig, CFBundleID, etc) that will be different between each environment. 
* We use a cmd-line utility to apply those configurations. 

Optionally, the cmd-line utility can apply a build number in the format: `<week_number_since_project_start>.<day_in_week>.<build_number_for_day>`

# Running

Apply the config named 'staging' in the `EnvFile.plist`, and generate a new version number. 

```bash
backdrop.swift --select staging --newVersion
```

# Using in CI Environments

Here's how we do it: 

* Set up a branch for each environment in git, and set up a Jenkins job to monitor for pushes to those branches. 
* Exececute the follow script to build and upload to iTunes Connect

(the script below uses <a href="https://github.com/nomad/shenzhen">Shenzhen</a> to upload the build)

```bash
#Fail immediately if a task fails
set -e
set -o pipefail

echo "--- Backing up Info.plist ---"
cp "./AppName/Supporting Files/Info.plist" "./AppName/Supporting Files/Info.plist.bak"

rm -fr ./AppName_staging.ipa
rm -fr ./AppName.xcarchive/

./backdrop.swift --select staging --newVersion

xcodebuild -workspace AppName.xcworkspace/ -scheme AppScheme -destination 'generic/platform=iOS' -archivePath 'AppName.xcarchive' archive 
xcodebuild -exportArchive -exportFormat ipa -archivePath "AppName.xcarchive"  -exportPath "AppName_staging.ipa" -exportProvisioningProfile "Profile"
ipa info AppName_staging.ipa

echo "------ Built ------"
rm "./AppName/Supporting Files/Info.plist"
mv "./AppName/Supporting Files/Info.plist.bak" "./Yello/Supporting Files/Info.plist"

ipa distribute:itunesconnect -a somebody@somewhere.com -p password -i 1031066688 --upload --verbose ./AppName_staging.ipa 
```


# Installing

Later we'll publish to Brew and MacPorts, but for now, <a href="https://github.com/appsquickly/backdrop/blob/master/backdrop.swift">this executable Swift script can be used</a>. 

# TODO

1. Make the script peform the build and upload to iTunes Connect, rather than use the bash script above. 
2. Remove the dependency on Shenzhen ipa distribute task. 
3. Add generation of debug symbols and tie in to our (or others?) crash reporters
