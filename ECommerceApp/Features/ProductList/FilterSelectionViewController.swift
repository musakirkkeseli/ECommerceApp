//
//  FilterSelectionViewController.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 17.11.2023.
//

import UIKit

protocol FilterSelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String)
}

class FilterSelectionViewController: UIViewController {

    weak var delegate: FilterSelectionDelegate?
    private let pickerView = UIPickerView()
    private var categories : [String] = []
    
    init(categories:[String]) {
        super.init(nibName: nil, bundle: nil)
        self.categories = categories
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()

        // Do any additional setup after loading the view.
    }
    
    private func setupPickerView() {
            pickerView.delegate = self
            pickerView.dataSource = self
            view.addSubview(pickerView)

            // Add constraints or frame setup for the pickerView based on your design
            // For example:
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                pickerView.widthAnchor.constraint(equalToConstant: 200),
                pickerView.heightAnchor.constraint(equalToConstant: 150)
            ])
        }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension FilterSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        delegate?.didSelectCategory(selectedCategory)
        dismiss(animated: true, completion: nil)
    }
}
