//
//  Debug.swift
//  Keylist
//
//  Created by 鈴木健太 on 2022/08/20.
//  Copyright © 2022 鈴木健太. All rights reserved.
//

import Foundation

class Debug {

    public static func log(title: String, message: String) {
        
        print(title + ":" + message)
    }

    public static func log(message: String) {
        
        print(message)
    }
}
