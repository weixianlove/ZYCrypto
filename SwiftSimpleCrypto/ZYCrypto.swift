//
//  ZYCypto.swift
//  ZYCrypto
//
//  Created by ZhaoYong on 2020/3/17.
//  Copyright © 2020 ZhaoYong. All rights reserved.
//

// 需要在OC桥接文件导入  #import <CommonCrypto/CommonHMAC.h>
// 加密工具

import Foundation

extension String {
    func hmac(by algorithm: Algorithm, key: [UInt8]) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: algorithm.digestLength())
        CCHmac(algorithm.algorithm(), key, key.count, self.bytes, self.bytes.count, &result)
        return result
    }
    
    func hash(by algorithm: Algorithm) -> String {
        return algorithm.hash(string: self)
    }
}


enum Algorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func algorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    func hash(string: String) -> String {
        var hash = [UInt8](repeating: 0, count: self.digestLength())
        switch self {
        case .MD5:
            CC_MD5(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA1:
            CC_SHA1(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA224:
            CC_SHA224(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA256:
            CC_SHA256(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA384:
            CC_SHA384(string.bytes, CC_LONG(string.bytes.count), &hash)
        case .SHA512:
            CC_SHA512(string.bytes, CC_LONG(string.bytes.count), &hash)
        }
        return hash.hexString
    }
}

extension Array where Element == UInt8 {
    var hexString: String {
        return self.reduce(""){$0 + String(format: "%02x", $1)}
    }
    
    var base64String: String {
        return self.data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
    }
    
    var data: Data {
        return Data(self)
    }
}

extension String {
    var bytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
