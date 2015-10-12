import Foundation

public class EnvFile {


    public var infoPlistRelativePath: String! {
        get {
            return storage["InfoPlist"] as! String!
        }
        set {
            storage["InfoPlist"] = newValue
        }
    }

    public var projectName: String! {
        get {
            return storage["ProjectName"] as! String!
        }
        set {
            storage["ProjectName"] = newValue
        }
    }

    public var createdDate: NSDate! {
        get {
            return storage["CreatedDate"] as! NSDate!
        }
        set {
            storage["CreatedDate"] = newValue
        }
    }

    private (set) public var envFilePath: String!
    private var storage: Dictionary<String, AnyObject>

    //-------------------------------------------------------------------------------------------
    // MARK: Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    public init(envFilePath: String!, infoPlistPath: String?, projectName: String?) {
        self.envFilePath = envFilePath
        self.storage = Dictionary()
        self.createdDate = CurrentDateatMidnightGMT()

        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(self.envFilePath)) {
            self.storage = NSDictionary(contentsOfFile: envFilePath) as! Dictionary<String, AnyObject>
        } else if (infoPlistPath != nil && projectName != nil) {
            self.infoPlistRelativePath = infoPlistPath!
            self.projectName = projectName!
        } else {
            NSException(name: NSInternalInconsistencyException, reason:
            "Can't create new EnvFile without specifying project name and Info.plist path", userInfo: nil).raise()
        }
    }

    public convenience init(envFilePath: String!) {
        self.init(envFilePath: envFilePath, infoPlistPath: nil, projectName: nil)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Public Methods
    //-------------------------------------------------------------------------------------------

    public func environmentWithName(name: String!) -> Environment? {
        for environment in self.environments() {
            if (environment.name == name) {
                return environment
            }
        }
        return nil;
    }

    public func environments() -> Array<Environment> {
        var environments = Array<Environment>()

        if (self.storage["environments"] != nil) {
            let plistEnvs = self.storage["environments"] as! Dictionary<String, AnyObject>
            for (key, values) in plistEnvs {
                let environment = Environment(name: key)
                environment.addAll(values as! Dictionary<String, AnyObject>)

                environments.append(environment)
            }
        }
        return environments
    }

    public func add(environment: Environment) {
        let configs = environment.configs as NSDictionary
        if (self.storage["environments"] == nil) {
            self.storage["environments"] = Dictionary<String, AnyObject>()
        }
        let environments = self.storage["environments"] as! NSDictionary
        environments.setValue(configs, forKey: environment.name)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Private Methods
    //-------------------------------------------------------------------------------------------

    private func save() {
        let dictionary = self.storage as NSDictionary
        dictionary.writeToFile(self.envFilePath, atomically: true)
    }
}
