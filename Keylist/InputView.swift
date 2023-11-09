//
//  InputView.swift
//  KeyList
//
//  Created by 鈴木健太 on 2020/03/01.
//  Copyright © 2020 鈴木健太. All rights reserved.
//

import SwiftUI
import CryptoKit

struct InputView: View {
    var delegate: DeleteProtocol
    @ObservedObject var vm: ViewModel
    var id: Int

    @Environment(\.presentationMode) var presentation
    
    @State private var sightInfoInit: SightInfo = SightInfo(sightName: "入力してください。", userId:"入力してください。",password:"入力してください。")
    @State private var sightInfo: SightInfo = SightInfo(sightName: "", userId:"", password:"")
    @State private var isShownUnregistable = false
    @State private var isDecided = false
    
    var body: some View {

        VStack() {
            HStack {
                Text("サイト名　：").fontWeight(.bold).frame(width:120)
                
                TextField(sightInfoInit.sightName, text: self.$sightInfo.sightName).textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .lineLimit(1)
            }
            .frame(height: 90.0)
            HStack {
                Text("ユーザ名　：").frame(width:120)
                TextField(sightInfoInit.userId, text: self.$sightInfo.userId).textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .lineLimit(1)
                
            }
            HStack {
                Text("パスワード：").frame(width:120)
                TextField(sightInfoInit.password, text: self.$sightInfo.password).textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: {

                do {
                    if (self.sightInfo.sightName != "" && self.sightInfo.userId != "" && self.sightInfo.password != "") {

                        // ペーストボードを空にする
//                        UIPasteboard.general.string = ""
                        
                        Debug.log(message:"password:" + self.sightInfo.password)
                        // パスワードを暗号化
                        self.sightInfo.encryptedPassword = try CryptoManager.getInstance().encrypt(decryptData: self.sightInfo.password)
                        
                        self.vm.info.append(self.sightInfo)

                        self.presentation.wrappedValue.dismiss()

                        Debug.log(message:"decrypted:"+CryptoManager.getInstance().decrypt(encryptedData: self.sightInfo.encryptedPassword))

                        var record:String! = self.sightInfo.sightName
                        record.append(contentsOf: ",")
                        record.append(contentsOf: self.sightInfo.userId)
                        record.append(contentsOf: ",")
                        record.append(contentsOf: self.sightInfo.encryptedPassword)
                        record.append(contentsOf: "\n")
                        
                        TextDBManager.getDbInstance().insert(record: record)
                        
                        Debug.log(message: "Record data:"+TextDBManager.getDbInstance().getData()!)
                    } else {
                        self.isShownUnregistable = true
                    }
                } catch {
                
                }
            }) {
                Text("決定")
            }
            .alert(isPresented: $isShownUnregistable, content:{
                Alert(title: Text("登録できません。"), message: Text("一つ以上の空欄があります。"))

            })
            .frame(height: 50.0)
        }.onAppear() {
            if (self.id < 0) {
                self.sightInfoInit = SightInfo(sightName: "入力してください。", userId:"入力してください。",password:"入力してください。")
            } else {
                self.sightInfo = self.vm.info[self.id]
            }
            
            TextDBManager.getDbInstance().load()

        }.onDisappear(){
            
            self.delegate.deleteThisRecord(id: self.id)
        }
        .navigationBarTitle("情報入力", displayMode: .inline)
    }
    
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let dp: DeleteProtocol = ListView()
        let vm = ViewModel()
        return InputView(delegate: dp, vm: vm, id: -1)
    }
}
