//
//  CryptoManager.swift
//  iOS
//
//  Created by Kenta Suzuki on 2021/07/04.
//  Copyright © 2021 TeRNARY DESIGN™️. All rights reserved.
//

import Foundation
import CryptoKit

enum AppError: Error {
    case error
}

enum KeyType {
    case encryptionKey

     var name: String {
        switch self {
        case .encryptionKey:
            return "encryptionKey"
        }
    }
}

extension SymmetricKey {

    // Create symetricKey with base64Encoded string
    init?(base64EncodedString string: String) {
        guard let data = Data(base64Encoded: string) else {
            return nil
        }
        self.init(data: data)
    }

    // Create Base64String from symetricKey
    func serialize() -> String {
        return self.withUnsafeBytes { body in
            Data(body).base64EncodedString()
        }
    }
}

// Managing crypting by CryotKit
class CryptoManager {
    
    private let tag: String = KeyType.encryptionKey.name
    private var symmetricKey: SymmetricKey!
    private var data: AnyObject?

    static var instance: CryptoManager?

    // Fetch AES key from unvolatile memory
    private func getKey() {
        
        // Fetch status from unvolatile memory
        let dic: [String: Any] = [kSecClass as String: kSecClassKey,
                                  kSecAttrApplicationTag as String: tag,
                                  kSecAttrKeySizeInBits as String: 256,
                                  kSecReturnData as String: true]

        let matchingStatus = withUnsafeMutablePointer(to: &data){
            SecItemCopyMatching(dic as CFDictionary, UnsafeMutablePointer($0))
        }

        if  matchingStatus == errSecSuccess {
            Debug.log(message:"AES secret key, Successful acquisition")
        } else {
            Debug.log(message:"AES secret key,　Unsaved")
            
            // Store AES key to unvolatile memory
            symmetricKey = SymmetricKey(size: .bits256)
            let dic: [String: Any] = [kSecClass as String: kSecClassKey,
                                      kSecAttrApplicationTag as String: tag,
                                      kSecAttrKeySizeInBits as String: 256,
                                      kSecValueData as String: symmetricKey.serialize().data(using: .utf8)!]

            if SecItemCopyMatching(dic as CFDictionary, nil) == errSecItemNotFound {
                
                // Be sure status of store or renew
                if SecItemAdd(dic as CFDictionary, nil) == errSecSuccess {
                    Debug.log(message:"AES secret key,　Successful save")
                } else {
                    Debug.log(message:"AES secret key,　Save failure")
                }

            }
        }
    }
    
    // get singleton instance
    static public func getInstance()-> CryptoManager! {
        
        if (instance == nil) {
            instance = CryptoManager()
        }
        
        instance!.getKey()
        
        return instance
    }
    
    // encrypt
    func encrypt(decryptData: String) throws -> String {
        do {
            if data != nil {
                symmetricKey = SymmetricKey(base64EncodedString: String(data: data as! Data , encoding: .utf8)!)!
            }

            let sealedBox = try AES.GCM.seal(decryptData.data(using: .utf8)!, using: symmetricKey)
            guard let encryptedData = sealedBox.combined else {
                throw AppError.error
            }
            Debug.log(message:"Successful encryption")
            return encode(crypted: encryptedData)
        } catch _ {
            Debug.log(message:"Encryption failer")
            throw AppError.error
        }
    }
    
    // decrypt
    func decrypt(encryptedData: String) -> String {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: decode(cryptedStr: encryptedData))
            let dencryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
            
            Debug.log(message:"Decryption successful")
            return String.init( data: dencryptedData, encoding: .utf8)!
        } catch _ {
            Debug.log(message:"Decryption failer")
            return String()
        }
    }
    
    // delete AES key in key chain
    func delete() {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag
        ]

        let status = SecItemDelete(attributes as CFDictionary)
        if status == errSecSuccess {
            Debug.log(message:"Successfully removed from keychain.")
        } else {
            if let error: String = SecCopyErrorMessageString(status, nil) as String? {
                Debug.log(message:error)
            }
        }
    }
    
    private func encode(crypted:Data!) -> String! {
        return String(crypted.map { String(format: "%.2hhx/", $0) }.joined().dropLast())
    }

    private func decode(cryptedStr:String!) -> Data! {
        let parsedStr = cryptedStr.components(separatedBy: "/")

        Debug.log(title:"edit info", message: cryptedStr)

        var dataStr:[UInt8] = []

        for str in parsedStr {
            dataStr.append(UInt8(str, radix:16)!)
        }

        return Data(dataStr)
    }
}
