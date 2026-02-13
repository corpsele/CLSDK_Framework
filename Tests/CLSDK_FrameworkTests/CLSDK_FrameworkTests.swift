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
        
        SM4UsageExample.demonstrate()
        
        var key = "0123456789abcdeffedcba9876543210" // 32个Hex字符 = 16字节
        var plainText = "Hello SM4 Swift!"

        // 加密 -> 输出 Base64
        if let cipher = SM4Utils.encrypt(plainText: plainText, keyHex: key, mode: .ECB, outputType: .base64) {
            print("ECB Base64 密文: \(cipher)")
            
            // 解密
            if let decrypted = SM4Utils.decrypt(cipherText: cipher, keyHex: key, mode: .ECB, inputType: .base64) {
                print("ECB 解密结果: \(decrypted)")
            }
        }
        
        key = "0123456789abcdeffedcba9876543210"
        let iv  = "00000000000000000000000000000000" // 16字节 IV
        plainText = "这是一段使用 CBC 模式加密的测试文本。"

        // 加密 -> 输出 Hex
        if let cipherHex = SM4Utils.encrypt(plainText: plainText, keyHex: key, ivHex: iv, mode: .CBC, outputType: .hex) {
            print("CBC Hex 密文: \(cipherHex)")
            
            // 解密
            if let decrypted = SM4Utils.decrypt(cipherText: cipherHex, keyHex: key, ivHex: iv, mode: .CBC, inputType: .hex) {
                print("CBC 解密结果: \(decrypted)")
            }
        }


    }
}


// MARK: - 使用示例
class SM4UsageExample {
    
    static func demonstrate() {
        let plainText = "Hello, SM4加密测试! 2024"
        let key = "0123456789abcdef"  // 16字节的UTF-8字符串
        let iv = "fedcba9876543210"   // 16字节的UTF-8字符串
        
        do {
            print("=== SM4 加密示例 ===")
            
            // 1. 加密为 Hex 格式
            let hexResult = try SM4Cryptor.encryptToHex(plainText: plainText, key: key, iv: iv, mode: .CBC)
            print("Hex 加密结果: \(hexResult)")
            
            // 2. 解密 Hex 格式
            let decryptedFromHex = try SM4Cryptor.decryptFromHex(hexString: hexResult, key: key, iv: iv, mode: .CBC)
            print("Hex 解密结果: \(decryptedFromHex)")
            
            // 3. 加密为 Base64 格式
            let base64Result = try SM4Cryptor.encryptToBase64(plainText: plainText, key: key, iv: iv, mode: .CBC)
            print("Base64 加密结果: \(base64Result)")
            
            // 4. 解密 Base64 格式
            let decryptedFromBase64 = try SM4Cryptor.decryptFromBase64(base64String: base64Result, key: key, iv: iv, mode: .CBC)
            print("Base64 解密结果: \(decryptedFromBase64)")
            
            print("\n=== 不同模式示例 ===")
            
            // 5. ECB 模式（不需要 IV）
            let ecbResult = try SM4Cryptor.encryptToHex(plainText: plainText, key: key, mode: .ECB)
            print("ECB 模式加密: \(ecbResult)")
            
            // 6. 生成随机 IV
            let randomIV = SM4Cryptor.generateRandomIV()
            print("随机生成的 IV: \(SM4Cryptor.dataToHex(Data(randomIV.utf8)))")
            
        } catch {
            print("发生错误: \(error)")
        }
    }
}
