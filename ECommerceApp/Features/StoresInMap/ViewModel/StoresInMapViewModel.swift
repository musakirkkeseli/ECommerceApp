//
//  StoresInMapViewModel.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 12.11.2023.
//

import Foundation

struct UsersMapViewModel {
    var usersList : [UserModel]?
    var showLocation : Geolocation?
    var usersMapOutPut: UsersMapOutPut?
    
    mutating func setDelegate(output: UsersMapOutPut) -> Void {
        self.usersMapOutPut = output
        }
    
    func numberOfRowsInSection() -> Int {
        return self.usersList!.count
    }
    
    func productsAtIndexPath(_ index: Int) -> UserModel {
        let user = self.usersList![index]
        return user
    }
    
    
    mutating func changeLocation() {
        print("ViewModel güncelleme aşaması lat:\(showLocation?.lat ?? "viewmodel de") long:\(showLocation?.long ?? "viewmodel de")")
        let capturedLocation = self.showLocation
        usersMapOutPut?.changeLocation(showLocation: capturedLocation)
        }
}
