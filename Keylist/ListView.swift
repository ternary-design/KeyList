//
//  ListView.swift
//  KeyList
//
//  Created by 鈴木健太 on 2020/03/01.
//  Copyright © 2020 鈴木健太. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {

    @Published var info : [SightInfo] = []
    
}

struct ListView: View, DeleteProtocol {
    
    @State private var showDetailView: Bool = false
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        VStack{
            ZStack(alignment:.bottom) {
                HStack{
                    VStack {
                        Text("Keylist")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Ver 1.0")
                            .font(.caption)
                        Text("Rev 1.0.0")
                            .font(.caption)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("©︎2021-2023")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .offset(x: 8, y: 0)
                            Image("TeRNARY DESIGN Small LOGO")
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("TeRNARY DESIGN (TM)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .offset(x: -8, y: 0)
                        }
                    }
                }
            }
            
            NavigationView {
                VStack {
                    
                    List {
                        ForEach(0..<vm.info.count, id: \.self) {i in
                            NavigationLink(destination: FetchView(dp: self, vm:self.vm, id:i)) {

                                Text("\(self.vm.info[i].sightName)")
                            }
                        }
                    }
                Spacer()
                }.navigationBarTitle("サイト一覧", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: InputView(delegate: self, vm: vm, id: -1)) {
                    Text("追加")
                })
            }
        }
        .padding(10.0)
    }
    
    func deleteThisRecord(id: Int) {
        if id >= 0 {
            self.vm.info.remove(at: id)
        }
    }
}

protocol DeleteProtocol {
    func deleteThisRecord(id: Int)
}

struct SightInfo: Identifiable {

    var id = UUID().uuidString
    var deleted: Bool = false
    var sightName: String
    var userId: String
    var password: String
    var encryptedPassword: String

    init(sightName: String, userId: String, password: String) {
        self.sightName = sightName
        self.userId = userId
        self.password = password
        self.encryptedPassword = ""
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        
        ListView()
        
    }
}

struct ListContainerController : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([controllers[0]], direction: .forward, animated: true)
    }
    
    var controllers: [UIViewController] = []
}
