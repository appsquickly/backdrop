#About

Backdrop is a utility for configuring an application's Info.plist file for separate environments. It can be used: 

* In dev environments for quickly switching between dev, staging, production environments. 
* On continuous integration build servers to automate deployment of pre-configured builds. 

#How Does it Work?

* We create an <a href="https://github.com/appsquickly/backdrop/blob/master/EnvFile.plist">`EnvFile.plist`</a> that declares the properties (icon file, TyphoonConfig, CFBundleID, etc) that will be different between each environment. 
* We use a cmd-line utility to apply those configurations. 

Optionally, the cmd-line utility can apply a build number - `CFBundleVersion` - in the format: `<week_number_since_project_start>.<day_in_week>.<build_number_for_day>`

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
#!/bin/sh


product_name='AmazingApp'
provisioning_profile='My Store Profile'

#Fail immediately if a task fails
set -e
set -o pipefail

echo "--- Backing up Info.plist ---"
cp "./$product_name/Supporting Files/Info.plist" "./$product_name/Supporting Files/Info.plist.bak"

echo "--- Building ---"

rm -fr ./$product_name.ipa
rm -fr ./$product_name.xcarchive/

./backdrop.swift --select production --newVersion

xcodebuild -workspace $product_name.xcworkspace/ -scheme $product_name -destination 'generic/platform=iOS' -archivePath "$product_name.xcarchive" archive | xcpretty
xcodebuild -exportArchive -exportFormat ipa -archivePath "$product_name.xcarchive"  -exportPath "$product_name.ipa" -exportProvisioningProfile "$provisioning_profile"
ipa info $product_name.ipa

echo "------ Built ------"
rm "./$product_name/Supporting Files/Info.plist"
mv "./$product_name/Supporting Files/Info.plist.bak" "./$product_name/Supporting Files/Info.plist"
./backdrop.swift
```


# Installing

Later we'll publish to Brew and MacPorts, but for now, <a href="https://github.com/appsquickly/backdrop/blob/master/backdrop.swift">this executable Swift script can be used</a>. 

# TODO

1. Make backdrop peform the build and upload to iTunes Connect, rather than use the bash script above. 
2. Remove the dependency on Shenzhen ipa distribute task. 
3. Add generation of debug symbols and tie in to our (or others?) crash reporters
