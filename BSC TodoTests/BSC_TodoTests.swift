//
//  BSC_TodoTests.swift
//  BSC TodoTests
//
//  Created by Lukas Sedlak on 19/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import XCTest
@testable import BSC_Todo

class BSC_TodoTests: XCTestCase {
    var sut: URLSession!
    var dataProvider: BSCDataProvider!
    
    override func setUp() {
        sut = URLSession(configuration: .default)
        dataProvider = BSCDataProvider()
    }

    override func tearDown() {
        sut = nil
        dataProvider = nil
        super.tearDown()
    }

    func testValidCallToBSC_API_GetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://private-anon-fdbc83bba6-note10.apiary-mock.com/notes")
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testGetAllNotesApiCall () {
        // given
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?
        var responseNotes: [Note]?
        
        // when
        dataProvider.allNotes(completion: { notes, error in
            responseNotes = notes
            responseError = error
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseNotes)
        XCTAssertEqual(responseNotes?.count, 2)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
