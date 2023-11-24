//
//  ECTabBarController.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 9.11.2023.
//

import UIKit

class ECTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .quaternarySystemFill
        viewControllers          = [createProductListNC(), createStoresInMapNC()]
    }
    
    // MARK: - ProductList Navigation Controller 🚀
    func createProductListNC() -> UINavigationController {
        let productListVC        = ProductListViewController()
        productListVC.title      = "Products"
        productListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        return UINavigationController(rootViewController: productListVC)
    }
    
    // MARK: - Favorites Navigation Controller 🌟
    func createStoresInMapNC() -> UINavigationController {
        let storesInMapVC        = StoresInMapViewController()
        storesInMapVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        
        return UINavigationController(rootViewController: storesInMapVC)
    }
}
