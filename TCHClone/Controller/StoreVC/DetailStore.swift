//
//  DetailStore.swift
//  TCHClone
//
//  Created by Trần Huy on 9/14/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import GoogleMaps
class DetailStore: UIViewController {
    //MARK: -Properties
    let mainView: UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIColor.darkGray.image()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let mapView: GMSMapView = {
        let mv = GMSMapView()
        mv.isUserInteractionEnabled = false
        
        return mv
    }()
    let lblAddress: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    let seperator: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let btnDirection: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Chỉ đường đến đây", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = .white
        btn.setBackgroundColor(.orange, for: .selected)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(btnDirectionTapped), for: .touchUpInside)
        return btn
    }()
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .groupTableViewBackground
        return tv
    }()
    var dataStore: Store? {
        didSet {
            imageView.loadImage1(with: dataStore!.getImgUrl())
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: dataStore!.geometry!.location.latitude, longitude: dataStore!.geometry!.location.longtitude), zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.camera = camera
            let attributes = NSMutableAttributedString()
            attributes.addImageAttachment(image: #imageLiteral(resourceName: "resources_images_icons_ic_location"), font: UIFont.systemFont(ofSize: 16), textColor: .orange, size: CGSize(width: 25, height: 25))
            attributes.append(NSAttributedString(string: dataStore!.address!, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
            lblAddress.attributedText = attributes
//            initView()
        }
    }
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    //MARK: - Handler
    func initView() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = dataStore?.getShortAddress()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .done, target: self, action: #selector(backToPreviousVC))
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        mainView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        mainView.addSubview(imageView)
        imageView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: nil, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        imageView.heightAnchor.constraint(equalToConstant: UIDevice.setSize(iPhone: 200, iPad: 300)).isActive = true
        imageView.clipsToBounds = true
        mainView.addSubview(mapView)
        mapView.setAnchor(top: imageView.bottomAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: nil, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        mapView.heightAnchor.constraint(equalToConstant: UIDevice.setSize(iPhone: 125, iPad: 175)).isActive = true
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: (dataStore?.geometry?.location.latitude)!, longitude: (dataStore?.geometry?.location.longtitude)!))
        let markerIconView = UIImageView(image: #imageLiteral(resourceName: "resources_images_icons_ic_map_maker"))
        markerIconView.frame.size = CGSize(width: 30, height: 30)
        markerIconView.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            marker.iconView = markerIconView
            marker.map = self.mapView
        }
        mainView.addSubview(lblAddress)
        lblAddress.setAnchor(top: mapView.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: mapView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0)
        mainView.addSubview(seperator)
        seperator.setAnchor(top: lblAddress.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        mainView.addSubview(btnDirection)
        btnDirection.setAnchor(top: seperator.bottomAnchor, left: nil, bottom: nil, right: lblAddress.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 30)
        btnDirection.layer.cornerRadius = 15
        btnDirection.layer.borderColor = UIColor.orange.cgColor
        btnDirection.layer.borderWidth = 0.5
        
        mainView.addSubview(tableView)
        tableView.layoutIfNeeded()
        tableView.setAnchor(top: btnDirection.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 150)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 00, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellDetail")
        
        
        
        
        
    }
    
    //MARK: - Selector
    @objc func backToPreviousVC() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnDirectionTapped() {
        guard let lat = dataStore?.geometry?.location.latitude, let latDouble: Double = Double(lat) else { return }
        guard let long = dataStore?.geometry?.location.longtitude, let longDouble: Double = Double(long) else { return }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(Double(long))&directionsmode=driving") {
                print( url)
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
    
}

extension DetailStore: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chi tiết"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellDetail")
        cell.backgroundColor = .white
        cell.imageView?.frame.size = CGSize(width: 20, height: 20)
        
        if indexPath.row == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "resources_images_icons_ic_hour").withRenderingMode(.alwaysOriginal)
            cell.textLabel?.text = "Giờ mở cửa"
            cell.detailTextLabel?.text = "07:00 - 22:00"
            return cell
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "com_accountkit_get_call-1").withRenderingMode(.alwaysOriginal)
            cell.textLabel?.text = "Liên hệ"
            cell.detailTextLabel?.text = "02871087088"
            return cell
        }
    }
    }
    

