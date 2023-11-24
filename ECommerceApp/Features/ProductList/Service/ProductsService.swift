//
//  ProductsService.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 9.11.2023.
//

import Foundation
import Alamofire

enum ProductsServiceEndPoint: String {
    case BASE_URL = "https://fakestoreapi.com/"
    case PRODUCT_PATH = "products"
    case CATEGORIES_PATH = "products/categories"
    case CATEGORY_PRODUCT_PATH = "products/category/"
    
    static func productPath()-> String {
        return "\(BASE_URL.rawValue)\(PRODUCT_PATH.rawValue)"
    }
    
    static func categoriesPath()-> String {
        return "\(BASE_URL.rawValue)\(CATEGORIES_PATH.rawValue)"
    }
    
    static func categoryProductPath(categoryName: String)-> String {
        return "\(BASE_URL.rawValue)\(CATEGORY_PRODUCT_PATH.rawValue)\(categoryName)"
    }
}

protocol IProductsService{
    func fetchAllProducts(response: @escaping ([Product]?)->Void)
}

struct ProductsService: IProductsService {

    func fetchAllProducts(response: @escaping ([Product]?) -> Void) {
        AF.request(ProductsServiceEndPoint.productPath()).responseDecodable(of: [Product].self) { (model) in
         
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data)
        }
    }
    
    func fetchCategoryProducts(categoryName: String, response: @escaping ([Product]?) -> Void) {
        AF.request(ProductsServiceEndPoint.categoryProductPath(categoryName: categoryName)).responseDecodable(of: [Product].self) { (model) in
         
            guard let data = model.value else {
                response(nil)
                return
            }
            response(data)
        }
    }
    
    func fetchAllCategories(response: @escaping ([String]?) -> Void) {
        AF.request(ProductsServiceEndPoint.categoriesPath()).responseDecodable(of: [String].self) { (model) in
         
            guard let data = model.value else {
                response(nil)
                return
            }
            print(data)
            response(data)
        }
    }

}
