import Foundation

public class Configurer {

    private(set) public var envFile: EnvFile!
    private(set) public var selectedEnv: Environment!
    private(set) public var increment: Bool!
    private var plist: NSMutableDictionary!
    private var buildNumberManager: BuildNumberManager!

    //-------------------------------------------------------------------------------------------
    // MARK: Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    public init(envFile: EnvFile!, selectedEnv: Environment?, increment: Bool!) {
        self.envFile = envFile

        let fileManager = NSFileManager.defaultManager()
        let plistPath = fileManager.currentDirectoryPath + "/" + envFile.infoPlistRelativePath
        if (!fileManager.fileExistsAtPath(plistPath)) {
            NSException(name: NSInternalInconsistencyException, reason:
            "EnvFile specifies plist at path: " + plistPath + ", but this file does not exist.", userInfo: nil).raise()
        }

        self.plist = NSMutableDictionary(contentsOfFile: plistPath)!

        if (selectedEnv == nil) {
            if (plist.valueForKey("SelectedEnv") != nil) {
                let envName = plist.valueForKey("SelectedEnv") as! String!
                let env = envFile.environmentWithName(envName);
                if (env != nil) {
                    self.selectedEnv = env!
                } else {
                    NSException(name: NSInternalInconsistencyException, reason:
                    "Can't infer selected environment from Info.plist. Either it is not specified or does not match " +
                            "any enviroments in EnvFile.plist", userInfo: nil).raise()
                }
            } else {
                NSException(name: NSInternalInconsistencyException, reason:
                "Can't infer selected environment from Info.plist, because there is no value for key 'SelectedEnv", userInfo: nil).raise()
            }
        } else {
            self.selectedEnv = selectedEnv
        }

        self.increment = increment
        self.buildNumberManager = BuildNumberManager(startDate: envFile.createdDate, appName: envFile.projectName,
                envName: self.selectedEnv.name)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Public Methods
    //-------------------------------------------------------------------------------------------

    public func printInfo() {
        print("\nEnvironment:\t\(self.selectedEnv.name)")
        print("Build:\t\t\(self.buildNumberManager.currentBuildNumber())")
    }

    public func configure() {

        if (self.increment == true) {
            self.incrementBuildNumber();
        }

        self.configureForEnvironment()
        self.save()
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Private Methods
    //-------------------------------------------------------------------------------------------

    private func incrementBuildNumber() {
        buildNumberManager.incrementBuildNumber()
        self.plist["CFBundleVersion"] = buildNumberManager.currentBuildNumber()
    }

    private func configureForEnvironment() {
        for (key, values) in self.selectedEnv.configs {
            self.plist[key] = values
        }
        self.plist["SelectedEnv"] = selectedEnv.name
    }

    private func save() {
        self.plist.writeToFile(envFile.infoPlistRelativePath, atomically: true)
    }

}