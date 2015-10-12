import Foundation

let cli = CommandLine()

let filePath = StringOption(shortFlag: "e", longFlag: "envFile", required: false,
        helpMessage: "Custom EnvFile to use.")
let newVersion = BoolOption(shortFlag: "n", longFlag: "newVersion",
        helpMessage: "Increments the build number.")
let select = StringOption(shortFlag: "s", longFlag: "select",
        helpMessage: "Name of config specified in EnvFile to use.")
let help = BoolOption(shortFlag: "h", longFlag: "help",
        helpMessage: "Prints this message.")

cli.addOptions(filePath, newVersion, select, help)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

let manager = NSFileManager.defaultManager()
let defaultPath = manager.currentDirectoryPath.stringByAppendingString("/EnvFile.plist")
print(defaultPath)
let resolvedPath = filePath.value != nil ? filePath.value! : defaultPath


if (help.value == true || manager.fileExistsAtPath(resolvedPath) == false) {
    cli.printUsage();
}
else {
    let envFile = EnvFile(envFilePath: resolvedPath)
    var env : Environment? = nil
    if (select.value != nil) {
        env = envFile.environmentWithName(select.value!)
        if (env == nil) {
            NSException(name: NSInternalInconsistencyException, reason:
            "EnvFile does not contain an environment named: " + select.value!, userInfo: nil).raise()
        }
    }
    let configurer = Configurer(envFile: envFile, selectedEnv: env,increment: newVersion.value)
    configurer.configure()
    configurer.printInfo()
}
