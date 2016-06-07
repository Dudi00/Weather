//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Błażej Wdowikowski on 05/06/2016.
//  Copyright © 2016 blazej. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAPIForecast(){
        let expectation = self.expectationWithDescription("apitest")
        WeatherAPI.apiKey = "ad4e521f54b155390c178acc59582f10"
        WeatherAPI.sharedClient.sevenDayForecastForPoznan(){ response in
            guard response.statusType != .ServerError else {
                XCTAssert(response.statusType != .ServerError, ";( server error")
                return
            }
            XCTAssert(response.forecasts?.count > 0, ":D yep we have some forecast")
            
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
