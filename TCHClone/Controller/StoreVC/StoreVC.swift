//
//  StoreVC.swift
//  TCHClone
//
//  Created by Trần Huy on 9/11/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
class StoreVC1: UIViewController {
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    let mapView = GMSMapView()
    let iconGPS: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location-pin").withTintColor(.orange, renderingMode: .alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getcurLocation()
        configMapView()
        
    }
    
    //MARK: - Handler
    func initView() {
        navigationItem.title = "Store"
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        //Config MapView
    
    }
    
    func configMapView() {
        mapView.settings.compassButton = true
        mapView.isMultipleTouchEnabled = true
//        placesClient = GMSPlacesClient.shared()
    }
    
    func getcurLocation() {
        //Ask for authorisation from user
        self.locationManager.requestAlwaysAuthorization()
        
        //For user in foreGround
        self.locationManager.requestWhenInUseAuthorization()
        
        //Set default location
        let defaultLocal = CLLocationCoordinate2D(latitude: 10.792253, longitude: 106.693370)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
}

extension StoreVC1: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print(location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
}
