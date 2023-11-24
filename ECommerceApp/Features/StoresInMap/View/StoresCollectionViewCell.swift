//
//  StoresInMapCollectionViewCell.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 12.11.2023.
//

import UIKit
import MapKit
import CoreLocation

class StoresCollectionViewCell: UICollectionViewCell {
    
    static let reuseID  = "StoresCollectionViewCell"
    var userName = UILabel()
    var userCityName = UILabel()
    var userMail = UILabel()
    var userPhone = UILabel()
    var usersViewModel : UsersMapViewModel!
    var userTapLocation : Geolocation!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
        let cellGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToLocation))
        self.addGestureRecognizer(cellGestureRecognizer)
        
        // Customize the appearance of the cell
             layer.cornerRadius = 10
             layer.borderWidth = 1.0
             layer.borderColor = UIColor.lightGray.cgColor
             backgroundColor = .white

             // Add UI elements to the contentView
        userName.translatesAutoresizingMaskIntoConstraints = false
        userCityName.translatesAutoresizingMaskIntoConstraints = false
        userMail.translatesAutoresizingMaskIntoConstraints = false
        userPhone.translatesAutoresizingMaskIntoConstraints = false

             contentView.addSubview(userName)
             contentView.addSubview(userCityName)
             contentView.addSubview(userMail)
             contentView.addSubview(userPhone)

             // Configure constraints
             NSLayoutConstraint.activate([
                userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                userName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                userCityName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
                userCityName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                userCityName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                userMail.topAnchor.constraint(equalTo: userCityName.bottomAnchor, constant: 5),
                userMail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                userMail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                userPhone.topAnchor.constraint(equalTo: userMail.bottomAnchor, constant: 5),
                userPhone.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                userPhone.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                userPhone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
             ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.width = ceil(size.width)
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    @objc func goToLocation(){
        print("Kullanıcı etkileşimi gerçekleşti lat:\(userTapLocation.lat ?? "lat boş") long:\(userTapLocation.long ?? "long boş")")
        self.usersViewModel.showLocation = userTapLocation
        self.usersViewModel.changeLocation()
    }
}
