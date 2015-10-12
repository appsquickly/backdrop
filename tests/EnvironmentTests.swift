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

import Cocoa
import XCTest

class EnvironmentTests: XCTestCase {

    func test_allows_initializations_with_name() {
        let env = Environment(name: "Production")
        XCTAssertEqual(env.name, "Production")
    }

    func test_allows_adding_config() {
        let env = Environment(name: "Staging")

        let config: Dictionary<String, AnyObject> = [
                "TyphoonConfigFilename" : "Config_staging.json",
                "CFBundleIconFiles" : ["icons_staging_58.png", "icons_staging_80.png"]
        ]
        env.addAll(config)
        XCTAssertTrue(env.configs.count == 2)
    }

}
