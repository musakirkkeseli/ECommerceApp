//
//  StoresInMapViewController.swift
//  ECommerceApp
//
//  Created by Musa KIRKKESELİ on 9.11.2023.
//

import UIKit
import MapKit
import CoreLocation

protocol UsersMapOutPut {
    func changeLocation(showLocation: Geolocation?)
}

class StoresInMapViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    var userCollectionView: UICollectionView!
    var mapView = MKMapView()
    var locationManager =  CLLocationManager()
    private var viewModel = UsersMapViewModel()
    lazy var returnToUserLocationButton: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // Adjust size as needed
            button.backgroundColor = .black
            button.layer.cornerRadius = 8 // Adjust corner radius as needed

            let image = UIImage(systemName: "location")
            let imageView = UIImageView(image: image)
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20) // Adjust icon position and size

            button.addSubview(imageView)
            button.addTarget(self, action: #selector(returnToUserLocation), for: .touchUpInside)

            let barButtonItem = UIBarButtonItem(customView: button)
            return barButtonItem
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        mapViewProcess()
        locationManagerProcess()
        returnToUserLocationButtonProcess()
        userCollectionViewProcess()
        viewModel.setDelegate(output: self)
        fetchUsers()
    }
    
    func mapViewProcess(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        // Add mapView to the view and set constraints
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
    
    func locationManagerProcess(){
        // Location operations
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func returnToUserLocationButtonProcess(){
        navigationItem.rightBarButtonItem = returnToUserLocationButton
    }
    
    func userCollectionViewProcess(){
        
        // Configure UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        layout.collectionView?.backgroundColor = .red
        
        // Add userCollectionView to the view and set constraints
        userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        userCollectionView.translatesAutoresizingMaskIntoConstraints = false
        userCollectionView.layer.borderColor = UIColor.red.cgColor
        userCollectionView.layer.borderWidth = 1.0
        view.addSubview(userCollectionView)
        NSLayoutConstraint.activate([
            userCollectionView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            userCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.register(StoresCollectionViewCell.self, forCellWithReuseIdentifier: StoresCollectionViewCell.reuseID)
    }
    
    func fetchUsers() {
        UsersMapService().fetchUsers() { (usersList) in
            if let usersList = usersList {
                self.viewModel.usersList = usersList
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
                
            }
        }
    }
    
    @objc func returnToUserLocation() {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager")
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = location
        mapView.addAnnotation(pin)
        
        let _geolocation : Geolocation = Geolocation(lat: String(format: "%f", locations[0].coordinate.latitude), long: String(format: "%f", locations[0].coordinate.longitude))
        self.viewModel.showLocation = _geolocation
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.usersList == nil ? 0:  self.viewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: StoresCollectionViewCell.reuseID, for: indexPath) as? StoresCollectionViewCell else {
            fatalError("Unable to dequeue StoresCollectionViewCell")
        }
        let user = self.viewModel.productsAtIndexPath(indexPath.row)
        cell.userName.text = "\((user.name?.firstname ?? "").uppercased()) \((user.name?.lastname ?? "").uppercased())"
        cell.userCityName.text = "City: \(user.address?.city ?? "")"
        cell.userMail.text = "Mail: \(user.email ?? "")"
        cell.userPhone.text = "Phone: \(user.phone ?? "")"
        cell.userTapLocation = user.address?.geolocation
        cell.usersViewModel = self.viewModel
        return cell
    }

}

extension StoresInMapViewController : UsersMapOutPut {
    func changeLocation (showLocation: Geolocation?) {
        DispatchQueue.main.async {
            [self] in
            print("Harita güncelleme aşama 2 lat:\(showLocation!.lat ?? "lat boş") long:\(showLocation!.long ?? "long boş")")
            let lat : Double = atof(showLocation!.lat)
            let long : Double = atof(showLocation!.long)
            let location = CLLocationCoordinate2D(latitude: lat , longitude: long)
            let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
}
