import Foundation

public func CurrentDateatMidnightGMT() -> NSDate! {
    let calendar = NSCalendar.currentCalendar()
    calendar.timeZone = NSTimeZone(name: "GMT")!
    let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
    let midnight = calendar.dateFromComponents(components)
    return midnight!
}


