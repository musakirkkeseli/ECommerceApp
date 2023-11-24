//
//  ProductDetailService.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 10.11.2023.
//

import Foundation
import Alamofire

enum ProductDetailServiceEndPoint: String {
    case BASE_URL = "https://fakestoreapi.com/"
    case PATH = "products"
    
    static func characterPath(productId:Int)-> String {
        return "\(BASE_URL.rawValue)\(PATH.rawValue)/\(productId)"
    }
}

protocol IProductDetailService{
    func fetchProduct(productId:Int, response: @escaping (Product?)->Void)
}

struct ProductDetailService: IProductDetailService {
    
    func fetchProduct( productId:Int, response: @escaping (Product?) -> Void) {

        AF.request(ProductDetailServiceEndPoint.characterPath(productId: productId)).responseDecodable(of: Product.self) { (model) in
         
            guard let data = model.value else {
                response(nil)
                return
            }
            print(data)
            response(data)
        }
    }

}
