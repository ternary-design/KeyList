//
//  ChangeView.swift
//  KeyList
//
//  Created by 鈴木健太 on 2020/03/03.
//  Copyright © 2020 鈴木健太. All rights reserved.
//

import SwiftUI

struct ChangeView: View {
    var delegate: ChangeProtocol
    @State var sightInfo: SightInfo
    @State private var isShownUnregistable = false
    
    @Environment(\.presentationMode) var presentation
        
    var body: some View {
        VStack {
            HStack {
                Text("サイト名　：").fontWeight(.bold).frame(width:120)
                TextField("", text: $sightInfo.sightName).textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.default)
                    .lineLimit(1)
            }
            .frame(height: 90.0)
            HStack {
                Text("ユーザ名　：").frame(width:120)
                TextField("", text: $sightInfo.userId).textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .lineLimit(1)
            }
            HStack {
                Text("パスワード：").frame(width:120)
                TextField("", text: $sightInfo.password).textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: {
                
                do {
                    if (self.sightInfo.sightName != "" && self.sightInfo.userId != "" && self.sightInfo.password != "") {

                        print(self.sightInfo.password)
                        
                        // パスワードを暗号化
                        self.sightInfo.encryptedPassword = try CryptoManager.getInstance().encrypt(decryptData: self.sightInfo.password)
//                        self.sightInfo.encryptedPassword = TextDBManager.getInstance().encode(crypted: encrypted)

                        self.delegate.changeThisRecord(sightInfo: self.sightInfo)
                        self.presentation.wrappedValue.dismiss()

                    } else {
                        self.isShownUnregistable = true
                    }
                } catch {
                
                }
                
            }) {
                Text("決定")
            }.alert(isPresented: $isShownUnregistable, content:{
                Alert(title: Text("登録できません。"), message: Text("一つ以上の空欄があります。"))

            }).frame(height: 50.0)
        }
        .navigationBarTitle("情報入力", displayMode: .inline)
    }
}

struct ChangeView_Previews: PreviewProvider {
    static var previews: some View {
        let dp: DeleteProtocol = ListView()
        let vm = ViewModel()
        let cp: ChangeProtocol = FetchView(dp: dp, vm:vm, id:-1)
        return ChangeView(delegate: cp, sightInfo: SightInfo(sightName: "入力してください。", userId:"入力してください。",password:"入力してください・。"))
    }
}
