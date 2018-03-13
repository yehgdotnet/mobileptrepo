//
//  keychainTests.swift
//  keychainEditrUI
//
//  Created by Nitin Jami on 2/17/16.
//  Copyright © 2016 Ghutle. All rights reserved.
//

import XCTest
import Security
import keychainEditrUI

class keychainTests: XCTestCase {
    
    var keychainObj: Keychain!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        keychainObj = Keychain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddItem() {
        
        // given
        let retVal = keychainObj.addItem()
        
        //when
        let checkVal: OSStatus! = errSecSuccess
        
        XCTAssertEqual(retVal.status, checkVal)
        
    }

}
