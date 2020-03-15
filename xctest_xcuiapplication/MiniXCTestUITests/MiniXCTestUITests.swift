//
//  MiniXCTestUITests.swift
//  MiniXCTestUITests
//
//  Created by James on 3/15/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import XCTest

class MiniXCTestUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

        ///
        /// test1: enter text in text field, tap button, confirm label text is same as text
        ///
        func testOne() {
            // UI tests must launch the application that they test.
            let app = XCUIApplication()
            app.launch()

            // Use recording to get started writing UI tests.
            // Use XCTAssert and related functions to verify your tests produce the correct results.
            
            // enter text in text field
            app.textFields.element.tap()
            
            // individual keys with taps:
            //app.keys["o"].tap()
            //app.keys["k"].tap()
            app.textFields.element.typeText("hello")
            
            // tap button
            app.buttons["Button"].tap()
            
            // verify label has changed to entered text
    //        app.staticTexts.containing(NSPredicate(format: "Label"))
            // No way of accessing label element cleanly. It is necessary to iterate through the labels and find a string match
            XCTAssertEqual(app.staticTexts.element.label, "Labelhello")
        }

    ///
    /// test2: clear text in text field, tap button confirm label text is restored to original "Label"
    ///
    func testTwo() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // enter text in text field
        app.textFields.element.tap()
        
        // individual keys with taps:
        app.textFields.element.typeText("")
        
        // tap button
        app.buttons["Button"].tap()
        
        // verify label has changed to original text
        XCTAssertEqual(app.staticTexts.element.label, "Label")
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
