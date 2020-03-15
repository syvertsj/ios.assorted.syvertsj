//
//  MiniXCTestTests.swift
//  MiniXCTestTests
//
//  Created by James on 3/15/20.
//  Copyright © 2020 James Syvertsen. All rights reserved.
//

import XCTest
@testable import MiniXCTest

class WordData {
    var emptyWordList = [String]()
    var populatedWordList = ["here", "there", "everywhere"]
}

class MiniXCTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // verify starting with empty word list object
    func testemptyWordListNotPopulated() {
        let wordData = WordData()
        XCTAssertEqual(wordData.emptyWordList.count, 0, "emptyWordList should start empty")
    }
    
    // verify starting with empty word list object
    func testPopulatedWordListtPopulated() {
        let wordData = WordData()
        XCTAssertEqual(wordData.populatedWordList.count, 3, "populatedWordList should be pre-populated")
    }
}
