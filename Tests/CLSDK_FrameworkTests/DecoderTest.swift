//
//  DecoderTest.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/23.
//

@testable import CLSDK_Framework
import Foundation

struct User: Decodable {
    // 如果 JSON 中没有 name，或者类型不对，自动变为 ""
    @SafeDecodable var name: String
    
    // 如果 JSON 中没有 age，自动变为 0
    @SafeDecodable var age: Int
    
    // 如果 JSON 中没有 scores，自动变为空数组 []
    @SafeDecodable var scores: [Int]
}


class DecoderTest {
    func test() {
        // 测试 JSON
        let json = """
        {
            "name": "Jack",
            "age": "错误的字符串",
            "scores": null
        }
        """.data(using: .utf8)!

        let user = try! JSONDecoder().decode(User.self, from: json)
        // "Jack"
        print(user.name)
        // 0 (因为类型不匹配，触发了默认值)
        print(user.age)
        // [] (因为 null，触发了默认值)
        print(user.scores)
    }
}
