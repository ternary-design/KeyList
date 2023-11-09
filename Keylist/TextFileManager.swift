//
//  TextFileManager.swift
//  Keylist
//
//  Created by 鈴木健太 on 2021/07/11.
//  Copyright © 2021 TeRNARY DESIGN ™️. All rights reserved.
//

import Foundation

// Managing text file
class TextFileManager {
 
    static var instance: TextFileManager?
    private var textDbFileName = "DB.txt"

    private var dirUrl: URL?
    private var fileUrl: URL?
//    private var fileUrl: String

    init() {

        dirUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        dirUrl = dirUrl!.appendingPathComponent("com.TeRNARY-DESIGN.FileOperateSample")
        fileUrl = dirUrl!.appendingPathComponent(textDbFileName)

        if !createDirectory() {

            fatalError("フォルダを作成できません")
        }
        
        print(fileUrl!.path)
    }
    
    // get singleton instance
    static public func getInstance()-> TextFileManager! {

        if (instance == nil) {
            instance = TextFileManager()
        }

        return instance

    }
    
    func setDirUrl (at directoryURL: URL) {
        
        dirUrl = directoryURL
        fileUrl = dirUrl!.appendingPathComponent(textDbFileName)
    }

    func setFileName(name fileName: String) {

        textDbFileName = fileName
        fileUrl = dirUrl!.appendingPathComponent(textDbFileName)
    }

    func createDirectory() -> Bool {

        return createDirectory(at: dirUrl!)
    }

    func createDirectory(at directoryURL: URL) -> Bool {
        var ret = false
        
        do {
            try FileManager.default.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            ret = true
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret

    }

    func deleteDirectory() -> Bool {
        
        return deleteDirectory(at: dirUrl!)
    }

    func deleteDirectory(at directoryURL: URL) -> Bool {
        var ret = false
        
        do {
            try FileManager.default.removeItem (atPath: directoryURL.path)
            ret = true
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret

    }
    
    func fileExists() -> Bool {
        return fileExists(atPath: fileUrl!.path)
    }

    func fileExists(atPath filePath: URL) -> Bool {
        return FileManager.default.fileExists(atPath: filePath.path)
    }

    func fileExists(atPath filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }

    // Create file
    func createFile() -> Bool {
        return createFile(atPath: fileUrl!.path)
    }

    func createFile(atPath filePath: URL) -> Bool {
        return FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
    }

    func createFile(atPath filePath: String) -> Bool {
        return FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
    }
    
    func deleteFile() -> Bool {

        return deleteFile(atPath: fileUrl!)
    }
    
    func deleteFile(atPath filePath: URL) -> Bool {

        var ret = false
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
            ret = true
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret
    }

    func deleteFile(atPath filePath: String) -> Bool {
        
        var ret = false
        
        do {
            try FileManager.default.removeItem(atPath: filePath)
            ret = true
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret
    }

    
    // Write file
    public func write(data: String?) -> Bool {

        return write(atPath: fileUrl!, data: data)
    }
    
    public func write(atPath fileUrl: URL, data: String?) -> Bool {

        var ret = false

         do {
            try data?.write(to: fileUrl, atomically: true, encoding: .utf8)
            ret = true
         } catch {
             Debug.log(message:"File write error: \(error)")
         }

        return ret

    }
    
    // Read file
    public func read() -> String! {

        return read(atPath: fileUrl!)
    }
    
    public func read(atPath fileUrl: URL) -> String! {

        var fileContents: String! = ""
        
        do {
            fileContents = try String(contentsOf: fileUrl)
        } catch {
            Debug.log(message:"File read error: \(error)")
        }
                
        return fileContents
    }

}
