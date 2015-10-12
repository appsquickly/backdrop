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

class ConfigurerTests: XCTestCase {

    func test_configures_environment() {

        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        let envFile = EnvFile(envFilePath: envFilePath)
        let selectedEnv = envFile.environmentWithName("staging")

        let configurer = Configurer(envFile: envFile, selectedEnv: selectedEnv, increment: true)

        configurer.configure()
    }

    func test_prints_info() {
        let currentPath = NSFileManager.defaultManager().currentDirectoryPath;
        let envFilePath = currentPath + "/tests.xctest/Contents/Resources/EnvFile.plist"

        let envFile = EnvFile(envFilePath: envFilePath)
        let selectedEnv = envFile.environmentWithName("staging")

        let configurer = Configurer(envFile: envFile, selectedEnv: selectedEnv, increment: true)
        configurer.printInfo()
    }
}
