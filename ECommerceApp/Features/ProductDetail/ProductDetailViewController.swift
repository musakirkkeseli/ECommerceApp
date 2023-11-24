//
//  ProductDetailViewController.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 10.11.2023.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var productDetailImageUrlString : String = ""
    var productDetailAppbarTitle : String = ""
    var productId=0
    var product: Product = Product(id: 0, title: "", price: 0.0, description: "", category: Category(rawValue: "electronics"), image: "", rating: Rating(rate: 0.0, count: 0))
    
    let productDetailImage = UIImageView()
    var desc = UITextView()
    var productDetailAppbar = UINavigationItem()
    var categoryName = UILabel()
    var productPrice = UILabel()
    
    init(productDetailAppbarTitle: String, productDetailImageUrlString: String, productId: Int){
        super.init(nibName: nil, bundle: nil)
        self.productId = productId
        navigationItem.title = productDetailAppbarTitle
        self.productDetailImageUrlString = productDetailImageUrlString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = .systemBackground
        
        productDetailImage.imageFromServerURL(urlString:  productDetailImageUrlString, PlaceHolderImage: UIImage.init(named: "kiyafet.jpeg")!)
        productDetailAppbar.title = productDetailAppbarTitle
        // Do any additional setup after loading the view.
        view.addSubview(productDetailImage)
        view.addSubview(desc)
        view.addSubview(categoryName)
        view.addSubview(productPrice)
        fetchProduct()
        
        productDetailImage.translatesAutoresizingMaskIntoConstraints = false;
        desc.translatesAutoresizingMaskIntoConstraints = false;
        categoryName.translatesAutoresizingMaskIntoConstraints = false;
        productPrice.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint.activate([
            // Product Detail Image
            productDetailImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            productDetailImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productDetailImage.heightAnchor.constraint(equalToConstant: 90),
            productDetailImage.widthAnchor.constraint(equalToConstant: 90),

            // Category Name
            categoryName.topAnchor.constraint(equalTo: productDetailImage.bottomAnchor, constant: 20),
            categoryName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryName.heightAnchor.constraint(equalToConstant: 40),

            // Description
            desc.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 20),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            desc.heightAnchor.constraint(equalToConstant: 90),

            // Product Price
            productPrice.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 20),
            productPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productPrice.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func fetchProduct() {
        
        ProductDetailService().fetchProduct(productId:productId) { (product) in
            if let product = product {
                self.product = product
                DispatchQueue.main.async {
                    let vMProduct : Product = self.product
                    self.desc.text = "Açıklama: \(vMProduct.description ?? "")"
                    self.categoryName.text = "Kategori: \(vMProduct.category?.rawValue.description ?? "")"
                    let price : String = String(format: "%f", product.price!)
                    self.productPrice.text = "Fiyat: \(price)"
                }
            }
        }
    }

}
