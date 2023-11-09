//
//  FetchView.swift
//  KeyList
//
//  Created by 鈴木健太 on 2020/03/01.
//  Copyright © 2020 鈴木健太. All rights reserved.
//

import SwiftUI

struct FetchView: View, ChangeProtocol {
    var dp: DeleteProtocol
    @ObservedObject var vm: ViewModel
    var id: Int
    
    @Environment(\.presentationMode) var presentation
    
    @State private var isShownCopyUserId = false
    @State private var isShownCopyPassword = false
    @State private var isShownDelete = false
    @State private var sightInfo: SightInfo = SightInfo(sightName: "error default", userId:"error default", password: "error default")
    
    @State private var board = UIPasteboard.general

    var body: some View {
        VStack {
            HStack {
                Text("サイト名　：").fontWeight(.bold).frame(width:120)
                
                Text(self.sightInfo.sightName).textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            }
            .frame(height: 90.0)
            HStack {
                Text("ユーザ名　：").frame(width:120)
                Text(self.sightInfo.userId).textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = self.sightInfo.userId
                    self.isShownCopyUserId = true
                }) {
                    Text("コピー")
                }
                .alert(isPresented: $isShownCopyUserId, content:{
                    Alert(title: Text("コピー"), message: Text("ユーザー名をコピーしました。"))
                })
            }
            .frame(height: 50.0)
            HStack {
                Text("パスワード：").frame(width:120)
                Text(self.sightInfo.password).textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
                Button(action: {
                    UIPasteboard.general.string = self.sightInfo.password
                    self.isShownCopyPassword = true
                }) {
                    Text("コピー")
                }
                .alert(isPresented: $isShownCopyPassword, content:{
                    Alert(title: Text("コピー"), message: Text("パスワードをコピーしました。"))
                })
            }
            .frame(height: 50.0)
            Spacer()
            NavigationLink(destination: ChangeView(delegate: self, sightInfo: self.sightInfo)) {
                Text("変更")
            }.frame(height: 50.0)
        }
        .navigationBarTitle("サイト情報", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.isShownDelete = true
        }) {
            Text("削除").foregroundColor(.red)
        })
            .actionSheet(isPresented: $isShownDelete, content: {
                ActionSheet(
                    title: Text("削除"),
                    message: Text("このサイト情報を削除します。\nよろしいですか？"),
                    buttons: [.destructive(Text("削除")){
                        self.presentation.wrappedValue.dismiss()
                        self.dp.deleteThisRecord(id: self.id)
                        },
                              .cancel(){}]
                )
                
            })
            .onAppear() {
                self.sightInfo.sightName = self.vm.info[self.id].sightName
                self.sightInfo.userId = self.vm.info[self.id].userId
                self.sightInfo.password = self.vm.info[self.id].password
                self.sightInfo.encryptedPassword = self.vm.info[self.id].encryptedPassword
                
        }
    }
    
    func changeThisRecord(sightInfo: SightInfo) {
        if (id >= 0) {
            self.vm.info[self.id] = sightInfo
            
            self.sightInfo.sightName = self.vm.info[self.id].sightName
            self.sightInfo.userId = self.vm.info[self.id].userId
            self.sightInfo.password = self.vm.info[self.id].password
            self.sightInfo.encryptedPassword = self.vm.info[self.id].encryptedPassword
        }
    }
}

protocol ChangeProtocol {
    func changeThisRecord(sightInfo: SightInfo)
}

struct FetchView_Previews: PreviewProvider {
    
    static var previews: some View {
        let dp: DeleteProtocol = ListView()
        let vm: ViewModel = ViewModel()
        return FetchView(dp: dp, vm: vm, id: 0)
    }
}
