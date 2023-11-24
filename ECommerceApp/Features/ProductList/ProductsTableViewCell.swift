//
//  ProductsTableViewCell.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 9.11.2023.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    
    static let reuseID  = "ProductsCell"
    let avatarImageView = UIImageView(frame: .zero)
    let usernameLabel   = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(product: Product) {
        let imageUrlString: String = product.image ?? ""
        avatarImageView.imageFromServerURL(urlString:  imageUrlString, PlaceHolderImage: UIImage.init(named: "kiyafet.jpeg")!)
        usernameLabel.text = product.title
    }
    
    private func configure() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(avatarImageView)
        
        let padding: CGFloat  = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

}

extension UIImageView{
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

           if self.image == nil{
                 self.image = PlaceHolderImage
           }

           URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   self.image = image
               })

           }).resume()
       }
}
