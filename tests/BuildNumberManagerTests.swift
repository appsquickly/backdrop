////////////////////////////////////////////////////////////////////////////////
//
//  APPSQUICKLY
//  Copyright 2015 AppsQuickly Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of AppsQuickly. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////


import Foundation
import XCTest

class BuildNumberManagerTests: XCTestCase {

    var manager : BuildNumberManager!

    override func setUp() {
        let twelveDaysAgo = NSCalendar.currentCalendar().dateByAddingUnit(
        .Day,
                value: -12,
                toDate: NSDate(),
                options: NSCalendarOptions(rawValue: 0))

        self.manager = BuildNumberManager(startDate: twelveDaysAgo, appName: "Greene", envName: "Staging")
    }

    func test_reads_current_build_number() {

        let buildNumber = manager.currentBuildNumber()
        print("The build number is: \(buildNumber)")
        XCTAssertNotNil(buildNumber)
    }

    func test_increments_build_number() {
        manager.incrementBuildNumber()
        let buildNumber = manager.currentBuildNumber()
        print("The build number is: \(buildNumber)")
        XCTAssertTrue(buildNumber.hasPrefix("1.4"))
    }

}