//
//  StoreVC.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class StoreVC: UIViewController {
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var mapView = GMSMapView()
    let btnMyLoaction: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .black
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(#imageLiteral(resourceName: "resources_images_icons_ic_navigate_location").withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnMyLoactionTapped), for: .touchUpInside)
        return btn
    }()
    let iconGPS: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location-pin").withTintColor(.orange, renderingMode: .alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    
    lazy var btnChooseCity: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(btnChooseCityTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()
    let lblChooseCity: UILabel = {
        let lbl = UILabel()
        lbl.text = "Chọn khu vực"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .black
        return lbl
    }()
    let imgDropDown: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "com_accountkit_spinner_triangle").withTintColor(.black, renderingMode: .alwaysOriginal)
        iv.tintColor = .black
        return iv
    }()
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        return tv
    }()
    fileprivate let collectionViewStore: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 15)
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var placesClient: GMSPlacesClient!
    lazy var widthCollectionCell = UIDevice.setSize(iPhone: view.frame.width / 2.5, iPad: view.frame.width / 4.5)

    var stores = [Store]() {
        didSet {
            self.initMarkerInMapView()
        }
    }
    var nearbyStore = [Store]()
    var response: GooglePlacesRespone?
    var isDropDownShow: Bool = false {
        didSet {
            showTableViewConstraint.isActive = isDropDownShow
            if UIDevice.current.userInterfaceIdiom == .phone {
                showCollectionViewConstraint.isActive = !isDropDownShow && isAllowLocation
                showBtnMyLocal.isActive = !isDropDownShow
            }
        }
    }
    
    private lazy var hideTableViewConstraint: NSLayoutConstraint = {
        let constraint = self.tableView.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = .defaultLow
        return constraint
    }()
    private lazy var showBtnMyLocal: NSLayoutConstraint = {
        let constraint = self.btnMyLoaction.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        constraint.priority = .defaultHigh
        return constraint
    }()
    private lazy var showCollectionViewConstraint: NSLayoutConstraint = {
        let constraint = self.collectionViewStore.heightAnchor.constraint(equalToConstant: UIDevice.setSize(iPhone: view.frame.width / 2.5, iPad: view.frame.width / 4.5) * 1.3)
        constraint.priority = .defaultHigh
        return constraint
    }()
    private lazy var showTableViewConstraint: NSLayoutConstraint = {
        self.tableView.layoutIfNeeded()
        let heightTableConstraint = self.tableView.contentSize.height
        let constraint = self.tableView.heightAnchor.constraint(equalToConstant: min(400, heightTableConstraint))
        return constraint
    }()
    private var isLoading = false
    private var inforWindow = CustomInforMarkerView()
    private var isAllowLocation = false {
        didSet {
            if isAllowLocation {
                initNearbyStore()
            }
        }
    }
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configNavigationView()
        configMapView()
        loadPlaceFromGoogle()
        configTableView()
    }
    
    
    //MARK: - Handler
    func initView() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        view.addSubview(iconGPS)
        iconGPS.translatesAutoresizingMaskIntoConstraints = false
        iconGPS.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconGPS.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconGPS.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconGPS.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(btnChooseCity)
        btnChooseCity.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 50)
        btnChooseCity.addSubview(lblChooseCity)
        lblChooseCity.setAnchor(top: nil, left: btnChooseCity.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
        lblChooseCity.centerYAnchor.constraint(equalTo: btnChooseCity.centerYAnchor).isActive = true
        
        
        btnChooseCity.addSubview(imgDropDown)
        imgDropDown.setAnchor(top: nil, left: nil, bottom: nil, right: btnChooseCity.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 20)
        imgDropDown.centerYAnchor.constraint(equalTo: btnChooseCity.centerYAnchor).isActive = true
        
        
        view.addSubview(tableView)
        tableView.setAnchor(top: btnChooseCity.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        hideTableViewConstraint.isActive = true
        
        view.addSubview(collectionViewStore)
        collectionViewStore.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0)
        collectionViewStore.delegate = self
        collectionViewStore.dataSource = self
        collectionViewStore.backgroundColor = .clear
        let hideCollectionView: NSLayoutConstraint = {
            let constranit = self.collectionViewStore.heightAnchor.constraint(equalToConstant: 0)
            constranit.priority = .defaultLow
            return constranit
        }()
        hideCollectionView.isActive = true
        collectionViewStore.register(CustomCollectionViewStoreCell.self, forCellWithReuseIdentifier: "CellStoreCollection")
        
        view.addSubview(btnMyLoaction)
        btnMyLoaction.setAnchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: widthCollectionCell * 1.4, paddingRight: 0, width: 40, height: 40)
        btnMyLoaction.layer.cornerRadius = 20
        
        let hideBtnMyLocal: NSLayoutConstraint = {
            let constranit = self.btnMyLoaction.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 60)
            constranit.priority = .defaultLow
            return constranit
        }()
        showBtnMyLocal.isActive = true
        hideBtnMyLocal.isActive = true
    }
    
    func configNavigationView() {
        navigationItem.title = "Store"
        
    }
    
    func configTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellChooseLocal")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 5
    }
    
    func configMapView() {
        
        mapView.settings.compassButton = false
        mapView.isMultipleTouchEnabled = true
        mapView.delegate = self
        placesClient = GMSPlacesClient.shared()
        //Check Loaction Services
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted, .notDetermined:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            isAllowLocation = true
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
        }
        
        //Ask for Authorisation from the user
        self.locationManager.requestAlwaysAuthorization()
        
        //For user in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //Set default location
        let defaultLocal = CLLocationCoordinate2D(latitude: 10.792253, longitude: 106.693370)
        
        let camera = GMSCameraPosition.camera(withTarget: defaultLocal, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.camera = camera
        
        //
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        

        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
    }
    
        
    //Load place Store fromm google
    func canLoadMore() -> Bool {
        if let response = self.response {
            if (!response.canLoadMore()) {
                return false
            }
        }
        return true
    }
    func loadPlaceFromGoogle() {
        
        StoreController.getAllStore(token: self.response?.nextPageToken ,completion: {(dataResponse) in
            self.didReceiResponse(response: dataResponse)
        })

    }
    func didReceiResponse(response: GooglePlacesRespone?) {
        self.response = response
        DispatchQueue.main.async {
            if response?.status == "OK" {
                if let p = response?.results {
                    self.stores.append(contentsOf: p)
                    self.tableView.reloadData()
                    self.collectionViewStore.reloadData()
                }
            }
        }
        if canLoadMore() {
            self.loadPlaceFromGoogle()
        }
    }
    
    //Add Marker to map
    func initMarkerInMapView() {
        guard let listStore: [Store] = stores else { return }
        listStore.forEach({
            let positionStore = CLLocationCoordinate2D(latitude: $0.geometry!.location.latitude, longitude: $0.geometry!.location.longtitude)
            let marker = GMSMarker(position: positionStore)
            let markerIconView = UIImageView(image: #imageLiteral(resourceName: "resources_images_icons_ic_map_maker"))
            marker.snippet = $0.address
            markerIconView.frame.size = CGSize(width: 30, height: 30)
            markerIconView.contentMode = .scaleAspectFit
            DispatchQueue.main.async {
                marker.iconView = markerIconView
                marker.map = self.mapView
            }
            marker.userData = $0
        })
    }
    
    //NearbyStore
    func initNearbyStore() {
        showCollectionViewConstraint.isActive = true
    }
    
    //MARK: - Selector
    @objc func btnMyLoactionTapped() {
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
              let lng = self.mapView.myLocation?.coordinate.longitude else { return }

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: camera)
    }
    @objc func btnChooseCityTapped() {
        if isDropDownShow {
            UIView.animate(withDuration: 0.3, animations: {
                self.imgDropDown.transform = CGAffineTransform.identity
                
            })
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.imgDropDown.transform = CGAffineTransform(rotationAngle: .pi)
            })
        }
        self.isDropDownShow = !self.isDropDownShow

    }
    
    
}
extension StoreVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellChooseLocal")
        cell.textLabel?.text = stores[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = stores[indexPath.row]
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: (data.geometry?.location.latitude)!, longitude: (data.geometry?.location.longtitude)!), zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
        lblChooseCity.text = data.getTown()
        tableView.deselectRow(at: indexPath, animated: true)
        btnChooseCityTapped()
    }
}
extension StoreVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let location = locations.first else { return }
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
        locationManager.stopUpdatingLocation()
        
    }
    
    //Update position when accept privacy location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways
        {
            isAllowLocation = true
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
        }
        
    }
    
    
    
    
}
extension StoreVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let data = marker.userData as! Store
        let infoWindow = CustomInforMarkerView(frame: CGRect(x: 0, y: 0, width: 300, height: 55))
        infoWindow.storeData = data
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 8
        infoWindow.layer.borderWidth = 0.2
        infoWindow.layer.borderColor = UIColor(named: "19E698")?.cgColor
        return infoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let data = marker.userData as! Store
        let detailStore = DetailStore()
        detailStore.dataStore = data
        self.navigationController?.pushViewController(detailStore, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        nearbyStore = stores
        let nowPosition = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        nearbyStore.sort(by: {(store1, store2) in
            let distance1 = nowPosition.distance(from: CLLocation(latitude: (store1.geometry?.location.latitude)!, longitude: (store1.geometry?.location.longtitude)!))
            let distance2 = nowPosition.distance(from: CLLocation(latitude: (store2.geometry?.location.latitude)!, longitude: (store2.geometry?.location.longtitude)!))

            return distance1 < distance2
        })
        self.collectionViewStore.reloadData()
        
        
    }
    
    
}

extension StoreVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewStore.dequeueReusableCell(withReuseIdentifier: "CellStoreCollection", for: indexPath) as! CustomCollectionViewStoreCell
        cell.dataStore = nearbyStore[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionCell, height: widthCollectionCell * 1.2)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(nearbyStore.count, 6)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionViewStore.cellForItem(at: indexPath) as! CustomCollectionViewStoreCell
        let data = cell.dataStore
        let detailStore = DetailStore()
        detailStore.dataStore = data
        self.navigationController?.pushViewController(detailStore, animated: true)
    }

}


