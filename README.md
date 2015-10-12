#About

Backdrop is a utility for configuring an application's Info.plist file for separate environments. It can be used: 

* In dev environments for quickly switching between dev, staging, production environments. 
* On continuous integration build servers to automate deployment of pre-configured builds. 

#How Does it Work?

* We create an `EnvFile.plist` that declares the properties (icon file, TyphoonConfig, CFBundleID, etc) that will be different between each environment. 
* We use a cmd-line utility to apply those configurations. 

Optionally, the cmd-line utility can apply a build number in the format: `<week_number_since_project_start>.<day_in_week>.<build_number_for_day>`


