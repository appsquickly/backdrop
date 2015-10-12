import Foundation

public class BuildNumberManager {

    private(set) public var startDate: NSDate!
    private(set) public var appName: String!
    private(set) public var envName: String!

    //-------------------------------------------------------------------------------------------
    // MARK: Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    public init(startDate: NSDate!, appName: String!, envName: String!) {
        self.startDate = startDate
        self.appName = appName
        self.envName = envName
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Public Methods
    //-------------------------------------------------------------------------------------------

    public func currentBuildNumber() -> String! {
        if (NSFileManager.defaultManager().fileExistsAtPath(self.buildFilePath()) == false) {
            self.writeBuildNumber("0.0.0")
        }
        let currentBuild: NSString = try! NSString(contentsOfFile: self.buildFilePath(),
                encoding: NSUTF8StringEncoding)
        return currentBuild as String
    }

    public func incrementBuildNumber() {

        let components: NSArray = self.currentBuildNumber().componentsSeparatedByString(".")
        let daysElapsed = self.daysElapsed()

        let week: Int! = daysElapsed / 7
        let day: Int! = (daysElapsed % 7)

//        println("Days elapsed: \(daysElapsed), Week: \(week), day: \(day)")

        let buildDay: Int = (components[1] as! NSString).integerValue
        var count: Int = (components[2] as! NSString).integerValue

        if (buildDay != day) {
            count = 0
        } else {
            count++
        }

        var version = String(week)
        version += "."
        version += String(day)
        version += "."
        version += String(count)

        self.writeBuildNumber(version)
    }

    //-------------------------------------------------------------------------------------------
    // MARK: Private Methods
    //-------------------------------------------------------------------------------------------

    private func daysElapsed() -> Int! {

        let endDate = CurrentDateatMidnightGMT()

        let cal = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = .Day

        let components = cal.components(unit, fromDate: self.startDate, toDate: endDate, options: [])
        let days = components.day
        return days
    }

    private func buildFilePath() -> String! {
        let fileName = "\(self.appName)_\(self.envName).build"
        return ".buildNumbers/\(fileName)"
    }

    private func writeBuildNumber(number: String) {
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(".buildNumbers",
                    withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        do {
            try number.writeToFile(self.buildFilePath(), atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }

}
