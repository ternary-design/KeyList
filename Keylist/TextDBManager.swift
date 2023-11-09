//
//  TextDBManager.swift
//  Keylist
//
//  Created by 鈴木健太 on 2021/07/11.
//  Copyright © 2021 TeRNARY DESIGN™️. All rights reserved.
//

import Foundation

// Managing data base by text
class TextDBManager: TextFileManager {

    static var dbInstance: TextDBManager?
    
    private var data: String?
    
    override init() {
    }
    
    // get singleton instance
    static public func getDbInstance()-> TextDBManager! {

        if (dbInstance == nil) {
            dbInstance = TextDBManager()
        }

        return dbInstance

    }
    
    public func getData() -> String? {
        return data
    }
        
    public func insert(record: String!) {

        data!.append(record)

    }
    
    public func save() {
    
        if !write(data: data) {
            Debug.log(message:"書き込みエラー")
        }
    }
    
    public func load() {
        data = read()
        
    }
    
}
