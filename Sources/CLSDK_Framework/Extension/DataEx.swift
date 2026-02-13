//
//  DataEx.swift
//  CLSDK_Framework
//
//  Created by corpsele_n on 2026/2/13.
//

import Foundation
import CommonCrypto

/// SM4 加密解密类，支持 ECB、CBC、CFB、OFB 工作模式
public class SM4Cryptor {
    
    // MARK: - 错误定义
    enum SM4Error: Error {
        case invalidKeyLength
        case invalidIVLength
        case invalidInput
        case encryptionFailed
        case decryptionFailed
        case invalidHexString
        case invalidBase64String
    }
    
    // MARK: - 工作模式
    enum Mode {
        case ECB
        case CBC
        case CFB
        case OFB
        
        var ivRequired: Bool {
            switch self {
            case .ECB:
                return false
            case .CBC, .CFB, .OFB:
                return true
            }
        }
    }
    
    // MARK: - 加密填充方式
    enum Padding {
        case pkcs7
        case zero
        
        func toCCPadding() -> CCOptions {
            switch self {
            case .pkcs7:
                return CCOptions(kCCOptionPKCS7Padding)
            case .zero:
                return 0
            }
        }
    }
    
    public init() {}
    
    // MARK: - 加密/解密方法
    
    /// 加密数据
    /// - Parameters:
    ///   - data: 原始数据
    ///   - key: 密钥字符串
    ///   - iv: 初始化向量字符串（CBC/CFB/OFB 模式需要）
    ///   - mode: 工作模式
    ///   - padding: 填充方式
    /// - Returns: 加密后的数据
    static func encrypt(data: Data,
                       key: String,
                       iv: String? = nil,
                       mode: Mode = .CBC,
                       padding: Padding = .pkcs7) throws -> Data {
        
        // 验证密钥长度
        guard let keyData = key.data(using: .utf8) else {
            throw SM4Error.invalidKeyLength
        }
        
        if keyData.count != 16 {
            throw SM4Error.invalidKeyLength
        }
        
        // 验证 IV（如果需要）
        var ivData: Data?
        if mode.ivRequired {
            guard let ivStr = iv, let data = ivStr.data(using: .utf8) else {
                throw SM4Error.invalidIVLength
            }
            if data.count != 16 {
                throw SM4Error.invalidIVLength
            }
            ivData = data
        }
        
        // 准备加密参数
        let keyBytes = [UInt8](keyData)
        let ivBytes = ivData != nil ? [UInt8](ivData!) : nil
        let dataBytes = [UInt8](data)
        
        // 执行加密
        var encryptedBytes = [UInt8](repeating: 0, count: dataBytes.count + 16) // 预留填充空间
        var encryptedLength = 0
        
        // 这里需要实现具体的 SM4 算法
        // 注意：由于 Swift 标准库不包含 SM4，你需要集成第三方库或自己实现
        // 以下为伪代码结构
        
        // TODO: 实现 SM4 加密算法
        // encryptedBytes = SM4_Encrypt(dataBytes, keyBytes, ivBytes, mode, padding)
        // encryptedLength = 加密后数据的实际长度
        
        // 临时返回示例数据
        encryptedBytes = dataBytes // 这只是一个占位符，需要替换为真正的 SM4 实现
        encryptedLength = dataBytes.count
        
        return Data(encryptedBytes[0..<encryptedLength])
    }
    
    /// 解密数据
    static func decrypt(data: Data,
                       key: String,
                       iv: String? = nil,
                       mode: Mode = .CBC,
                       padding: Padding = .pkcs7) throws -> Data {
        
        // 参数验证与 encrypt 类似
        // TODO: 实现 SM4 解密算法
        return data // 占位符
    }
    
    // MARK: - 字符串加密/解密
    
    /// 加密字符串，返回 Hex 格式
    static func encryptToHex(plainText: String,
                           key: String,
                           iv: String? = nil,
                           mode: Mode = .CBC,
                           padding: Padding = .pkcs7) throws -> String {
        guard let data = plainText.data(using: .utf8) else {
            throw SM4Error.invalidInput
        }
        
        let encryptedData = try encrypt(data: data, key: key, iv: iv, mode: mode, padding: padding)
        return dataToHex(encryptedData)
    }
    
    /// 解密 Hex 格式的加密字符串
    static func decryptFromHex(hexString: String,
                             key: String,
                             iv: String? = nil,
                             mode: Mode = .CBC,
                             padding: Padding = .pkcs7) throws -> String {
        guard let encryptedData = hexToData(hexString) else {
            throw SM4Error.invalidHexString
        }
        
        let decryptedData = try decrypt(data: encryptedData, key: key, iv: iv, mode: mode, padding: padding)
        guard let result = String(data: decryptedData, encoding: .utf8) else {
            throw SM4Error.decryptionFailed
        }
        return result
    }
    
    /// 加密字符串，返回 Base64 格式
    static func encryptToBase64(plainText: String,
                              key: String,
                              iv: String? = nil,
                              mode: Mode = .CBC,
                              padding: Padding = .pkcs7) throws -> String {
        guard let data = plainText.data(using: .utf8) else {
            throw SM4Error.invalidInput
        }
        
        let encryptedData = try encrypt(data: data, key: key, iv: iv, mode: mode, padding: padding)
        return encryptedData.base64EncodedString()
    }
    
    /// 解密 Base64 格式的加密字符串
    static func decryptFromBase64(base64String: String,
                                key: String,
                                iv: String? = nil,
                                mode: Mode = .CBC,
                                padding: Padding = .pkcs7) throws -> String {
        guard let encryptedData = Data(base64Encoded: base64String) else {
            throw SM4Error.invalidBase64String
        }
        
        let decryptedData = try decrypt(data: encryptedData, key: key, iv: iv, mode: mode, padding: padding)
        guard let result = String(data: decryptedData, encoding: .utf8) else {
            throw SM4Error.decryptionFailed
        }
        return result
    }
    
    // MARK: - 工具方法
    
    /// Data 转 Hex 字符串
    static func dataToHex(_ data: Data) -> String {
        return data.map { String(format: "%02x", $0) }.joined()
    }
    
    /// Hex 字符串转 Data
    static func hexToData(_ hexString: String) -> Data? {
        let hexString = hexString.lowercased()
        guard hexString.count % 2 == 0 else { return nil }
        
        var data = Data(capacity: hexString.count / 2)
        
        var index = hexString.startIndex
        while index < hexString.endIndex {
            let nextIndex = hexString.index(index, offsetBy: 2)
            let byteString = hexString[index..<nextIndex]
            
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            
            data.append(byte)
            index = nextIndex
        }
        
        return data
    }
    
    /// 生成随机的 IV（16字节）
    static func generateRandomIV() -> String {
        var bytes = [UInt8](repeating: 0, count: 16)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return String(bytes: bytes, encoding: .utf8) ?? ""
    }
    
    /// 检查密钥长度是否有效（16字节 = 32个Hex字符 = 24个Base64字符）
    static func isValidKey(_ key: String) -> Bool {
        guard let data = key.data(using: .utf8) else { return false }
        return data.count == 16
    }
    
    /// 检查 IV 长度是否有效
    static func isValidIV(_ iv: String) -> Bool {
        guard let data = iv.data(using: .utf8) else { return false }
        return data.count == 16
    }
}

// MARK: - 扩展：支持不同密钥格式
extension SM4Cryptor {
    
    /// 使用 Hex 格式的密钥进行加密
    static func encryptWithHexKey(plainText: String,
                                 hexKey: String,
                                 hexIV: String? = nil,
                                 mode: Mode = .CBC) throws -> String {
        guard let keyData = hexToData(hexKey) else {
            throw SM4Error.invalidHexString
        }
        
        guard let keyString = String(data: keyData, encoding: .utf8),
              keyData.count == 16 else {
            throw SM4Error.invalidKeyLength
        }
        
        var ivString: String?
        if let hexIV = hexIV {
            guard let ivData = hexToData(hexIV) else {
                throw SM4Error.invalidHexString
            }
            ivString = String(data: ivData, encoding: .utf8)
        }
        
        return try encryptToHex(plainText: plainText,
                              key: keyString,
                              iv: ivString,
                              mode: mode)
    }
    
    /// 使用 Base64 格式的密钥进行加密
    static func encryptWithBase64Key(plainText: String,
                                    base64Key: String,
                                    base64IV: String? = nil,
                                    mode: Mode = .CBC) throws -> String {
        guard let keyData = Data(base64Encoded: base64Key) else {
            throw SM4Error.invalidBase64String
        }
        
        guard let keyString = String(data: keyData, encoding: .utf8),
              keyData.count == 16 else {
            throw SM4Error.invalidKeyLength
        }
        
        var ivString: String?
        if let base64IV = base64IV {
            guard let ivData = Data(base64Encoded: base64IV) else {
                throw SM4Error.invalidBase64String
            }
            ivString = String(data: ivData, encoding: .utf8)
        }
        
        return try encryptToHex(plainText: plainText,
                              key: keyString,
                              iv: ivString,
                              mode: mode)
    }
}

// 使用示例
// SM4UsageExample.demonstrate()

/// 内存安全扩展：安全擦除敏感数据
extension Array where Element == UInt8 {
    mutating func secureErase() {
        for i in 0..<self.count {
            self[i] = 0
        }
    }
}




// MARK: - 1. Data 扩展
extension Data {
    /// 十六进制字符串转 Data
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let start = hexString.index(hexString.startIndex, offsetBy: i*2)
            let end = hexString.index(start, offsetBy: 2)
            let byteStr = String(hexString[start..<end])
            if let byte = UInt8(byteStr, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
        }
        self = data
    }

    /// Data 转十六进制字符串 (小写)
    func toHexString() -> String {
        return map { String(format: "%02x", $0) }.joined()
    }

    /// Data 转 Base64 字符串
    func toBase64String() -> String {
        return self.base64EncodedString()
    }
}

// MARK: - 2. SM4 核心算法引擎
/// 负责密钥扩展和单块数据的加密解密
private final class SM4Engine {
    
    // SM4 S盒
    private static let sBox: [UInt8] = [
        0xD6, 0x90, 0xE9, 0xFE, 0xCC, 0xE1, 0x3D, 0xB7, 0x16, 0xB6, 0x14, 0xC2, 0x28, 0xFB, 0x2C, 0x05,
        0x2B, 0x67, 0x9A, 0x76, 0x2A, 0xBE, 0x04, 0xC3, 0xAA, 0x44, 0x13, 0x26, 0x49, 0x86, 0x06, 0x99,
        0x9C, 0x42, 0x50, 0xF4, 0x91, 0xEF, 0x98, 0x7A, 0x33, 0x54, 0x0B, 0x43, 0xED, 0xCF, 0xAC, 0x62,
        0xE4, 0xB3, 0x1C, 0xA9, 0xC9, 0x08, 0xE8, 0x95, 0x80, 0xDF, 0x94, 0xFA, 0x75, 0x8F, 0x3F, 0xA6,
        0x47, 0x07, 0xA7, 0xFC, 0xF3, 0x73, 0x17, 0xBA, 0x83, 0x59, 0x3C, 0x19, 0xE6, 0x85, 0x4F, 0xA8,
        0x68, 0x6B, 0x81, 0xB2, 0x71, 0x64, 0xDA, 0x8B, 0xF8, 0xEB, 0x0F, 0x4B, 0x70, 0x56, 0x9D, 0x35,
        0x1E, 0x24, 0x0E, 0x5E, 0x63, 0x58, 0xD1, 0xA2, 0x25, 0x22, 0x7C, 0x3B, 0x01, 0x21, 0x78, 0x87,
        0xD4, 0x00, 0x46, 0x57, 0x9F, 0xD3, 0x27, 0x52, 0x4C, 0x36, 0x02, 0xE7, 0xA0, 0xC4, 0xC8, 0x9E,
        0xEA, 0xBF, 0x8A, 0xD2, 0x40, 0xC7, 0x38, 0xB5, 0xA3, 0xF7, 0xF2, 0xCE, 0xF9, 0x61, 0x15, 0xA1,
        0xE0, 0xAE, 0x5D, 0xA4, 0x9B, 0x34, 0x1A, 0x55, 0xAD, 0x93, 0x32, 0x30, 0xF5, 0x8C, 0xB1, 0xE3,
        0x1D, 0xF6, 0xE2, 0x2E, 0x82, 0x66, 0xCA, 0x60, 0xC0, 0x29, 0x23, 0xAB, 0x0D, 0x53, 0x4E, 0x6F,
        0xD5, 0xDB, 0x37, 0x45, 0xDE, 0xFD, 0x8E, 0x2F, 0x03, 0xFF, 0x6A, 0x72, 0x6D, 0x6C, 0x5B, 0x51,
        0x8D, 0x1B, 0xAF, 0x92, 0xBB, 0xDD, 0xBC, 0x7F, 0x11, 0xD9, 0x5C, 0x41, 0x1F, 0x10, 0x5A, 0xD8,
        0x0A, 0xC1, 0x31, 0x88, 0xA5, 0xCD, 0x7B, 0xBD, 0x2D, 0x74, 0xD0, 0x12, 0xB8, 0xE5, 0xB4, 0xB0,
        0x89, 0x69, 0x97, 0x4A, 0x0C, 0x96, 0x77, 0x7E, 0x65, 0xB9, 0xF1, 0x09, 0xC5, 0x6E, 0xC6, 0x84,
        0x18, 0xF0, 0x7D, 0xEC, 0x3A, 0xDC, 0x4D, 0x20, 0x79, 0xEE, 0x5F, 0x3E, 0xD7, 0xCB, 0x39, 0x48
    ]

    // 系统参数 FK
    private static let fk: [UInt32] = [0xA3B1BAC6, 0x56AA3350, 0x677D9197, 0xB27022DC]
    
    // 固定参数 CK
    private static let ck: [UInt32] = [
        0x00070E15, 0x1C232A31, 0x383F464D, 0x545B6269, 0x70777E85, 0x8C939AA1, 0xA8AFB6BD, 0xC4CBD2D9,
        0xE0E7EEF5, 0xFC030A11, 0x181F262D, 0x343B4249, 0x50575E65, 0x6C737A81, 0x888F969D, 0xA4ABB2B9,
        0xC0C7CED5, 0xDCE3EAF1, 0xF8FF060D, 0x141B2229, 0x30373E45, 0x4C535A61, 0x686F767D, 0x848B9299,
        0xA0A7AEB5, 0xBCC3CAD1, 0xD8DFE6ED, 0xF4FB0209, 0x10171E25, 0x2C333A41, 0x484F565D, 0x646B7279
    ]

    private var roundKeys: [UInt32] = Array(repeating: 0, count: 32)

    init(key: Data) {
        generateRoundKeys(key: key)
    }

    // MARK: - 密钥扩展
    private func generateRoundKeys(key: Data) {
        // 将 16 字节 Key 转为 4 个 UInt32 (大端序)
        let mk = key.chunked(into: 4).map { bytes -> UInt32 in
            return bytes.withUnsafeBytes { $0.load(as: UInt32.self) }.bigEndian
        }
        
        var K: [UInt32] = [
            mk[0] ^ SM4Engine.fk[0],
            mk[1] ^ SM4Engine.fk[1],
            mk[2] ^ SM4Engine.fk[2],
            mk[3] ^ SM4Engine.fk[3]
        ]
        
        for i in 0..<32 {
            let tmp = K[1] ^ K[2] ^ K[3] ^ SM4Engine.ck[i]
            let lPrime = SM4Engine.lPrimeTransform(val: SM4Engine.tauTransform(val: tmp))
            let newK = K[0] ^ lPrime
            
            roundKeys[i] = newK
            
            // 滑动窗口更新
            K.removeFirst()
            K.append(newK)
        }
    }

    // MARK: - 分组加解密
    /// 加密或解密一个 16 字节的分组
    func cryptBlock(block: Data, isEncrypt: Bool) -> Data {
        // 转为 4 个 UInt32 (大端序)
        let words = block.chunked(into: 4).map { bytes -> UInt32 in
            return bytes.withUnsafeBytes { $0.load(as: UInt32.self) }.bigEndian
        }
        
        var X = words
        
        // 加密顺序：0..31，解密顺序：31..0
        let range = isEncrypt ? AnySequence(0..<32) : AnySequence(stride(from: 31, through: 0, by: -1))
        
        for i in range {
            let tmp = X[1] ^ X[2] ^ X[3] ^ roundKeys[i]
            let l = SM4Engine.lTransform(val: SM4Engine.tauTransform(val: tmp))
            let newX = X[0] ^ l
            
            // 滑动窗口更新
            X.removeFirst()
            X.append(newX)
        }
        
        // 反序输出
        let resultWords = [X[3], X[2], X[1], X[0]]
        var resultData = Data()
        for w in resultWords {
            var bigEndian = w.bigEndian
            resultData.append(contentsOf: withUnsafeBytes(of: &bigEndian) { Array($0) })
        }
        return resultData
    }

    // MARK: - 变换函数
    private static func tauTransform(val: UInt32) -> UInt32 {
        var output: UInt32 = 0
        for i in 0..<4 {
            let shift = UInt32(24 - i * 8)
            let byte = UInt8((val >> shift) & 0xFF)
            let sByte = sBox[Int(byte)]
            output |= UInt32(sByte) << shift
        }
        return output
    }

    private static func lTransform(val: UInt32) -> UInt32 {
        return val ^ rotl(val, 2) ^ rotl(val, 10) ^ rotl(val, 18) ^ rotl(val, 24)
    }
    
    private static func lPrimeTransform(val: UInt32) -> UInt32 {
        return val ^ rotl(val, 13) ^ rotl(val, 23)
    }

    private static func rotl(_ val: UInt32, _ n: UInt32) -> UInt32 {
        return (val << n) | (val >> (32 - n))
    }
}

// MARK: - 3. SM4 工具类封装
public class SM4Utils {
    
    /// 工作模式枚举
    public enum Mode {
        case ECB  // 电子密码本模式
        case CBC  // 密码分组链接模式
    }
    
    /// 编码格式枚举
    public enum EncodingType {
        case hex
        case base64
    }
    
    public init() {}
    
    // MARK: - 填充处理
    /// PKCS#7 填充
    private static func padding(data: Data) -> Data {
        var padData = data
        let count = data.count
        let padByte = 16 - (count % 16)
        let padding = Data(repeating: UInt8(padByte), count: padByte)
        padData.append(padding)
        return padData
    }
    
    /// 移除 PKCS#7 填充
    private static func unpadding(data: Data) -> Data {
        guard let lastByte = data.last else { return data }
        let padCount = Int(lastByte)
        if padCount > 16 || padCount > data.count { return data }
        return data.dropLast(padCount)
    }
    
    /// 异或操作
    private static func xor(_ a: Data, _ b: Data) -> Data {
        var result = Data(count: a.count)
        for i in 0..<a.count {
            result[i] = a[i] ^ b[i]
        }
        return result
    }
    
    // MARK: - 公开接口
    
    /// SM4 加密
    /// - Parameters:
    ///   - plainText: 明文字符串
    ///   - keyHex: 16字节密钥 (Hex字符串，32字符)
    ///   - ivHex: 16字节IV (Hex字符串，CBC模式必填，ECB模式忽略)
    ///   - mode: 工作模式
    ///   - outputType: 输出编码
    /// - Returns: 密文字符串
    public static func encrypt(plainText: String, keyHex: String, ivHex: String? = nil, mode: Mode, outputType: EncodingType = .base64) -> String? {
        guard let keyData = Data(hexString: keyHex), keyData.count == 16 else {
            print("SM4 Error: Key must be 16 bytes (32 hex characters).")
            return nil
        }
        guard let plainData = plainText.data(using: .utf8) else { return nil }
        
        return encrypt(data: plainData, keyData: keyData, ivHex: ivHex, mode: mode, outputType: outputType)
    }
    
    /// SM4 解密
    /// - Parameters:
    ///   - cipherText: 密文字符串
    ///   - keyHex: 16字节密钥 (Hex字符串)
    ///   - ivHex: 16字节IV (Hex字符串，CBC模式必填)
    ///   - mode: 工作模式
    ///   - inputType: 输入编码
    /// - Returns: 明文字符串
    public static func decrypt(cipherText: String, keyHex: String, ivHex: String? = nil, mode: Mode, inputType: EncodingType = .base64) -> String? {
        guard let keyData = Data(hexString: keyHex), keyData.count == 16 else {
            print("SM4 Error: Key must be 16 bytes (32 hex characters).")
            return nil
        }
        
        var cipherData: Data?
        switch inputType {
        case .base64:
            cipherData = Data(base64Encoded: cipherText)
        case .hex:
            cipherData = Data(hexString: cipherText)
        }
        
        guard let data = cipherData else {
            print("SM4 Error: Invalid cipher text format.")
            return nil
        }
        
        guard let decryptedData = decrypt(data: data, keyData: keyData, ivHex: ivHex, mode: mode) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
    
    // MARK: - 核心逻辑
    
    private static func encrypt(data: Data, keyData: Data, ivHex: String?, mode: Mode, outputType: EncodingType) -> String? {
        let engine = SM4Engine(key: keyData)
        let paddedData = padding(data: data)
        var cipherData = Data()
        
        // CBC 模式需要 IV
        var iv = (ivHex != nil) ? Data(hexString: ivHex!) : Data(repeating: 0, count: 16)
        if mode == .CBC && ivHex == nil {
            print("SM4 Warning: CBC mode requires IV, using default null IV.")
        }
        
        let blocks = paddedData.chunked(into: 16)
        
        for block in blocks {
            var processBlock = block
            
            if mode == .CBC {
                // CBC: 明文先与 IV 异或
                if let iv = iv {
                    processBlock = xor(block, iv)
                }
                
            }
            
            let encryptedBlock = engine.cryptBlock(block: processBlock, isEncrypt: true)
            cipherData.append(encryptedBlock)
            
            if mode == .CBC {
                // 更新 IV 为当前密文块
                iv = encryptedBlock
            }
        }
        
        switch outputType {
        case .base64: return cipherData.toBase64String()
        case .hex: return cipherData.toHexString()
        }
    }
    
    private static func decrypt(data: Data, keyData: Data, ivHex: String?, mode: Mode) -> Data? {
        guard data.count % 16 == 0 else {
            print("SM4 Error: Cipher data length must be a multiple of 16 bytes.")
            return nil
        }
        
        let engine = SM4Engine(key: keyData)
        var plainData = Data()
        var iv = (ivHex != nil) ? Data(hexString: ivHex!) : Data(repeating: 0, count: 16)
        
        let blocks = data.chunked(into: 16)
        
        for block in blocks {
            let decryptedBlock = engine.cryptBlock(block: block, isEncrypt: false)
            var plainBlock = decryptedBlock
            
            if mode == .CBC {
                if let iv = iv {
                    // CBC: 解密后与 IV 异或
                    plainBlock = xor(decryptedBlock, iv)
                }
                // 更新 IV 为当前密文块
                iv = block
            }
            
            plainData.append(plainBlock)
        }
        
        return unpadding(data: plainData)
    }
}

// MARK: - 辅助扩展
private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Data {
    /// 将 Data 按指定字节大小分块
    /// - Parameter size: 每个分块的字节数
    /// - Returns: 分块后的 [Data] 数组
    func chunked(into size: Int) -> [Data] {
        // 如果 size <= 0，直接返回整个 Data 作为一块（避免崩溃）
        guard size > 0 else { return [self] }

        var chunks: [Data] = []
        var offset = 0

        // 从 0 开始，每次步进 size 个字节
        while offset < count {
            // 计算当前块的结束位置
            let end = Swift.min(offset + size, count)
            // 取子 data
            let chunk = subdata(in: offset ..< end)
            chunks.append(chunk)
            offset = end
        }

        return chunks
    }
}
