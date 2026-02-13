//
//  CLSDK_FrameworkTests.swift
//  CLSDK_FrameworkTests
//
//  Created by corpsele_n on 2026/2/2.
//

import Testing
import XCTest
@testable import CLSDK_Framework

struct CLSDK_FrameworkTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        testSM4RoundTrip()
    }

    func testSM4RoundTrip() {
        let sm4 = Sm4Impl()
        _ = sm4.setKey(key: "this is the key", iv: "this is the iv", hex: false)
        let msg = "国密SM4对称加密算法"
        let c = sm4.encrypt(text: msg)
        print("-=-=-=-=-= c = \(c)")
        XCTAssertEqual(c, "09908004c24cece806ee6dc2d6a3d154907048fb96d0201a8c47f4f1e03995bc")
        let p = sm4.decrypt(text: c)
        print("-=-=-=-=-= p = \(p)")
        print("-=-=-=-=-= msg = \(msg)")
        XCTAssertEqual(p, msg)
    }
}
