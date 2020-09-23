//
//  PopUpChooseNation.swift
//  TCHClone
//
//  Created by Trần Huy on 8/25/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class PopupChooseNation: UIView {
    
    //MARK: - Properties
    let lblDetail: UILabel = {
       let lbl = UILabel()
        lbl.text = "Chọn quốc gia"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    
    let btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.backgroundColor = btn.isSelected ? UIColor.orange : UIColor.white
        btn.selectedColor1 = UIColor.orange
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        btn.addTarget(self, action: #selector(btnCancelTapped), for: .touchUpInside)
        return btn
    }()
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.isScrollEnabled = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tv.backgroundColor = .white
        return tv
    }()
    let seperatorHeader: UIView = {
       let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }()
    let seperatorFooter: UIView = {
       let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }()
    var delegate: PopupViewChooseNationalDelegate?
    let listNational: [National] = National.allCases.map{National(rawValue: $0.rawValue)!}
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sizeToFit()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellPhoneCode")
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Handler
    func initView() {
        self.backgroundColor = .white
        addSubview(lblDetail)
        lblDetail.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        addSubview(seperatorHeader)
        seperatorHeader.setAnchor(top: lblDetail.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0.3)
        
        addSubview(tableView)
        tableView.layoutIfNeeded()
        tableView.invalidateIntrinsicContentSize()
        let tableHeight = tableView.contentSize.height
        tableView.setAnchor(top: seperatorHeader.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 3, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: self.frame.width, height: tableHeight)
        addSubview(seperatorFooter)
        seperatorFooter.setAnchor(top: tableView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.3)
        addSubview(btnCancel)
        btnCancel.setAnchor(top: seperatorFooter.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 10, paddingRight: 10)
    }
    
    //MARK: - Selecttor
    @objc func btnCancelTapped() {
        delegate?.handlerCancelBtnPopUpTapped()
    }
}

extension PopupChooseNation: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return National.allCases.count
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.handlerCancelBtnPopUpTapped()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPhoneCode", for: indexPath) as! UITableViewCell
        
        
        cell.textLabel?.text = listNational[indexPath.row].description
        cell.textLabel!.font = UIFont.systemFont(ofSize: 13)
        cell.imageView?.image = listNational[indexPath.row].image
        return cell
    }
    
    
}
