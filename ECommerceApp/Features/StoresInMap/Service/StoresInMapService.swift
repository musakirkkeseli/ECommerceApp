//
//  StoresInMapService.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 12.11.2023.
//

import Foundation
import Alamofire

enum UsersMapServiceEndPoint: String {
    case BASE_URL = "https://fakestoreapi.com/"
    case PATH = "users"
    
    static func characterPath()-> String {
        return "\(BASE_URL.rawValue)\(PATH.rawValue)"
    }
}

protocol IUsersMapService{
    func fetchUsers(response: @escaping ([UserModel]?)->Void)
}

struct UsersMapService: IUsersMapService {
    func fetchUsers(response: @escaping ([UserModel]?) -> Void) {

        AF.request(UsersMapServiceEndPoint.characterPath()).responseDecodable(of: [UserModel].self) { (model) in
         
            guard let data = model.value else {
                response(nil)
                return
            }
//            print(data)
            response(data)
        }
    }

}
