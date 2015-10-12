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

class EnvFileTests: XCTestCase {

    func test_throws_exception_instantiated_with_new_envFilePath_and_empty_plistFilePath() {
        _ = EnvFile(envFilePath: "EnvFile.plist", infoPlistPath: nil, projectName: nil)
    }

    func test_loads_env_from_disk() {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        _ = EnvFile(envFilePath: envFilePath)
    }

    func test_allows_adding_an_env() {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        let envFile = EnvFile(envFilePath: envFilePath)

        let newEnvironment = Environment(name: "Hacking")
        newEnvironment.setConfig("Foo", forKey: "Bar")

        envFile.add(newEnvironment)

        XCTAssertEqual(envFile.environments().count, 4)
    }

    func test_lists_environments() {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        let envFile = EnvFile(envFilePath: envFilePath)
        _ = envFile.environments()


        XCTAssert(envFile.environments().count == 3)
    }

    func test_returns_environment_by_name() {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        let envFile = EnvFile(envFilePath: envFilePath)

        XCTAssertNotNil(envFile.environmentWithName("staging"))
        XCTAssertNil(envFile.environmentWithName("foobar"))
    }



}
