//
//  AES_Algorithm.swift
//  linphone
//
//  Created by Suhail on 16/11/20.
//

import Foundation
import CommonCrypto


@objc class AESAlgorithm : NSObject {
    
    @objc(encryptvalue:withKey:andiv:)
    func encrypt(value: String, key:String, iv:String) -> String? {
        let options = kCCOptionPKCS7Padding
        if let keyData = key.data(using: String.Encoding.utf8),
           let data = value.data(using: String.Encoding.utf8),
           let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      (data as NSData).bytes, data.count,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if cryptStatus == kCCSuccess {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                return base64cryptString
            }
            else {
                return nil
            }
        }
        return nil
    }
}
