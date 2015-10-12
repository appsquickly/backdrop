import Foundation

public class Environment {

    private(set) public var name: String!
    private(set) public var configs: Dictionary<String, AnyObject>!

    public init(name: String!) {
        self.name = name;
        self.configs = Dictionary()
    }

    public func setConfig(config: AnyObject!, forKey: String!) {
        self.configs[forKey] = config
    }

    public func addAll(properties: Dictionary<String, AnyObject>!) {
        for (key, value) in properties {
            self.setConfig(value, forKey: key)
        }
    }




}
