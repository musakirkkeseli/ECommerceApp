//
//  ProductListViewController.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 9.11.2023.
//

import UIKit

class ProductListViewController: UIViewController {
    
    let tableView = UITableView()
    var products: [Product] = []
    var allCategories: [String] = []
    var selectedCategories = "Tümü"
    let selectedCategoryLabel: UILabel = {
            let label = UILabel()
        label.text = "Tümü"
            label.textAlignment = .center
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllProducts()
        navigationBarSetup()
    }
    
    func navigationBarSetup(){
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .blue
        navigationItem.rightBarButtonItem = filterButton
    }
    
    func setupUI(){
        view.addSubview(selectedCategoryLabel)
        view.addSubview(tableView)
                
        selectedCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
                
        let safeArea = view.safeAreaLayoutGuide
                
        NSLayoutConstraint.activate([
            selectedCategoryLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            selectedCategoryLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            selectedCategoryLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            selectedCategoryLabel.heightAnchor.constraint(equalToConstant: 25),
                    
            tableView.topAnchor.constraint(equalTo: selectedCategoryLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        tableView.frame       = view.bounds
        tableView.rowHeight   = 160
        tableView.delegate    = self
        tableView.dataSource  = self
        
        tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: ProductsTableViewCell.reuseID)
    }
    
    func fetchAllProducts() {
        ProductsService().fetchAllCategories() { (allCategories) in
            if var allCategories = allCategories {
                allCategories.insert("Tümü", at: 0)
                self.allCategories = allCategories
            }
        }
        ProductsService().fetchAllProducts() { (products) in
            if let products = products {
                self.products = products
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
                
            }
        }
    }
    
    func fetchCateoryProducts(){
            ProductsService().fetchCategoryProducts(categoryName: self.selectedCategories) { (products) in
                if let products = products {
                    self.products = products
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                    
                }
            }
        }
    
    @objc func filterButtonTapped() {
            // Display your filter selection view here
            let filterSelectionVC = FilterSelectionViewController(categories: allCategories)
            filterSelectionVC.delegate = self
            present(filterSelectionVC, animated: true, completion: nil)
        }

}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.reuseID, for: indexPath) as! ProductsTableViewCell
        let product = products[indexPath.row]
        cell.set(product: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let products    = products[indexPath.row]
        let destVC      = ProductDetailViewController(productDetailAppbarTitle: products.title ?? "", productDetailImageUrlString: products.image ?? "", productId: products.id ?? 0)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}

// MARK: - FilterSelectionDelegate
extension ProductListViewController: FilterSelectionDelegate {
    func didSelectCategory(_ category: String) {
        print("Selected category: \(category)")
        selectedCategoryLabel.text = category
        selectedCategories = category
        if category == "Tümü" {
            fetchAllProducts()
        }else{
            fetchCateoryProducts()
        }
    }
}
