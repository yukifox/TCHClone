//
//  InforView.swift
//  TCHClone
//
//  Created by Trần Huy on 6/14/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
protocol InforViewDelegate {
    func btnComfirmOrder(with listDataChoose: [(labelCell: String, labelType: [String])], nameItem: String)
}
class InforView: UIView {
    
    //MARK: - Properties
    var item: ItemData? {
        didSet {
            guard let imageData = item?.imageData else { return }
            imageItem.image = UIImage(data: imageData)
            guard let itemName = item?.name else { return }
            let attributes = NSMutableAttributedString(string: itemName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            
            lblItemName.attributedText = attributes
            guard let priceSmall = item?.smallprice else { return }
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale.current
            let price = currencyFormatter.string(from: NSNumber(value: priceSmall))
            lblPrice.text = price
            refactorData()
        }
    }
    
    let imageItem: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let lblItemName: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        
        return lbl
    }()
    
    let lblPrice: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let btnLike: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
        return btn
    }()
    
    let lblSize: UILabel = {
       let lbl = UILabel()
        lbl.text = "Size"
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    
    let sizeView: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let radioView: RadioButtonView = {
       let rv = RadioButtonView()
        return rv
    }()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.isScrollEnabled = true
        tv.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tv.register(TitleHeaderItemView.self, forHeaderFooterViewReuseIdentifier: "HeaderInfoView")
        return tv
    }()
    let btnOrder: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundColor(.orange, for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnOrderTapped), for: .touchUpInside)
        return btn
    }()
    let btnAddQuantity: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "add").withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        btn.setBackgroundColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(btnAddQuantityTapped), for: .touchUpInside)
        return btn
    }()
    let btnSubQuantity: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "sub").withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        btn.setBackgroundColor(.red, for: .normal)
        btn.setBackgroundColor(.gray, for: .disabled)
        btn.addTarget(self, action: #selector(btnSubQuantityTapped), for: .touchUpInside)
        
        return btn
    }()
    let lblQuantity: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .black
        return lbl
    }()
    
    var isLiked: Bool? {
        didSet {
            let attributesBtnNotLike = NSMutableAttributedString(string: "♡", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.black.cgColor])
            attributesBtnNotLike.append(NSAttributedString(string: " Yêu thích", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black.cgColor]))
            let attributesBtnLiked = NSMutableAttributedString(string: "♥︎", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.orange.cgColor])
            attributesBtnLiked.append(NSAttributedString(string: " Yêu thích", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black.cgColor]))
            btnLike.setAttributedTitle(isLiked! ? attributesBtnLiked : attributesBtnNotLike, for: .normal)
        }
    }
    var dataOfItem: [String: Any] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var dataForDisplay: [(labelCell: String, labelType: [String])] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedIndex: IndexPath? {
        didSet {
            tableView.reloadData()
        }
    }
    var listChoose: [(labelCell: String, labelType: [String])] = [] {
        didSet {
            tableView.reloadData()
            updatePayment()
        }
    }
    var delegate: InforViewDelegate?

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        initView()
    }
    convenience init(frame: CGRect, item: ItemData) {
        self.init(frame: frame)
        self.item = item
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handler
    func initView(){
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        addSubview(imageItem)
        imageItem.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)

        addSubview(lblItemName)
        lblItemName.setAnchor(top: imageItem.topAnchor, left: imageItem.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 15)
        
        addSubview(lblPrice)
        lblPrice.setAnchor(top: lblItemName.bottomAnchor, left: lblItemName.leftAnchor, bottom: nil, right: lblItemName.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        addSubview(btnLike)
        btnLike.setAnchor(top: lblPrice.bottomAnchor, left: lblPrice.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, height: 25)
        isLiked = false
    
        //Table View
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate  = self
        tableView.layoutIfNeeded()
        
        
        
        tableView.setAnchor(top: btnLike.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: tableView.contentSize.height)
        let viewFootter: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 0)))
            
            return view
        }()
        let blankView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: 0.1)))
        blankView.backgroundColor = .clear
        tableView.sectionFooterHeight = 0
        tableView.tableFooterView = blankView
        tableView.tableHeaderView = blankView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 45
        addSubview(btnSubQuantity)
        btnSubQuantity.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        btnSubQuantity.layer.cornerRadius = 15
        btnSubQuantity.clipsToBounds = true
        addSubview(btnAddQuantity)
        addSubview(lblQuantity)
        lblQuantity.setAnchor(top: nil, left: btnSubQuantity.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        btnAddQuantity.setAnchor(top: nil, left: lblQuantity.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        btnAddQuantity.clipsToBounds = true
        btnAddQuantity.layer.cornerRadius = 15

        
        addSubview( btnOrder)
        btnOrder.setAnchor(top: tableView.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 120, height: 40)
        btnAddQuantity.centerYAnchor.constraint(equalTo: btnOrder.centerYAnchor).isActive = true
        btnSubQuantity.centerYAnchor.constraint(equalTo: btnOrder.centerYAnchor).isActive = true
        lblQuantity.centerYAnchor.constraint(equalTo: btnOrder.centerYAnchor).isActive = true

        btnOrder.layer.cornerRadius = 5
        
        
        
    }
    func refactorData() {
        var prices = [String: Int]()
        dataForDisplay.removeAll()
        prices[stringSizeItem.smallprice.rawValue] = item?.smallprice
        if let mediumPrice = item?.mediumprice {
            prices[stringSizeItem.mediumprice.rawValue] = mediumPrice
        }
        if let largPrice = item?.largeprice {
            prices[stringSizeItem.largeprice.rawValue] = largPrice
        }
        if prices.count > 1 {
            var temp = [String]()
            for label in stringSizeItem.allCases {
                if prices[label.rawValue] != nil {
                    temp.append(label.rawValue)
                }
            }
            dataForDisplay.append((labelCell: "size",labelType: temp))
        }
        dataOfItem[stringItemInCell.size.rawValue] = prices
        var topping: [String: Int] = [:]
        for index in 0...stringToppingItem.allCases.count - 1 {
            let label = stringToppingItem.allCases[index].rawValue
            if item?.value(forKey: label) != nil {
                topping[label] = item?.value(forKey: label) as! Int
            }
        }
        if topping.isEmpty == false {
            var temp = [String]()
            for label in stringToppingItem.allCases {
                if topping[label.rawValue] != nil {
                    temp.append(label.rawValue)
                }
            }
            dataOfItem[stringItemInCell.topping.rawValue] = topping
            dataForDisplay.append((labelCell: "topping", labelType: temp))
        }
        if item?.descriptionItem != nil {
            dataOfItem[stringItemInCell.descriptionItem.rawValue] = [stringItemInCell.descriptionItem.rawValue: item?.descriptionItem!]
            dataForDisplay.append((labelCell: stringItemInCell.descriptionItem.rawValue, labelType: [stringItemInCell.descriptionItem.rawValue]))
        }
        if dataForDisplay.count == 1 {
            listChoose.append((labelCell: "size",labelType: [stringSizeItem.smallprice.rawValue]))
        } else {
            listChoose.append((labelCell: "size",labelType: [dataForDisplay[0].labelType[0]]))
        }
        
        listChoose.append((labelCell: stringItemInCell.topping.rawValue, labelType: []))
        listChoose.append((labelCell: "id",labelType: [String(item!.id)]))
        listChoose.append((labelCell: "quantity", labelType: [String(1)]))
        
    }
    func updatePayment() {
        if listChoose.count < 4 {
            return
        }
        let prisize = item?.value(forKey: listChoose[0].labelType[0]) as! Int
        var priceTopping = 0
        for keyAccess in listChoose[1].labelType {
            priceTopping += (item?.value(forKey: keyAccess)!) as! Int
        }
        let quantity = Int(listChoose[3].labelType[0])
        if quantity! <= 1 {
            btnSubQuantity.isEnabled = false
        } else {
            btnSubQuantity.isEnabled = true
        }
        lblQuantity.text = String(quantity!)
        let subTotal = (prisize + priceTopping) * quantity!
        let textTotal = subTotal.toStringCurrency(currencyCode: "VND")
        btnOrder.setTitle(textTotal, for: .normal)
    }
    
    //MARK: - Selector
    
    @objc func btnLikeTapped() {
        isLiked = !isLiked!
    }
    @objc func btnAddQuantityTapped() {
        if var curQuantity = Int(listChoose[3].labelType[0]) {
            curQuantity += 1
            listChoose[3].labelType[0] = String(curQuantity)
        }
    }
    @objc func btnSubQuantityTapped() {
        if var curQuantity = Int(listChoose[3].labelType[0]) {
            curQuantity -= 1
            listChoose[3].labelType[0] = String(curQuantity)
        }
    }
    @objc func btnOrderTapped() {
        delegate?.btnComfirmOrder(with: listChoose, nameItem: (item?.name!)!)
    }
    
}

extension InforView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataForDisplay.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataForDisplay[section].labelType.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderInfoView") as! TitleHeaderItemView
        let labelAccess = dataForDisplay[section].labelCell
        header.lbl.text = stringItemInCell(rawValue: labelAccess)?.description
        
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellInfoView", for: indexPath) as! InforViewCell
        
        let cell = InforViewCell()
        let row = indexPath.row
        let section = indexPath.section
        
        
        cell.lblText.numberOfLines = 0
        
        let labelAccess = dataForDisplay[indexPath.section].labelType[indexPath.item]
    
        cell.lblText.font = UIFont.systemFont(ofSize: 15)
        
        
        //Size Cell
        if dataForDisplay[indexPath.section].labelCell == stringItemInCell.size.rawValue {
            
            cell.viewingMode = .radioButtonMode
            cell.lblText.text = stringSizeItem.init(rawValue: labelAccess)?.description
            let pricePlus = item?.value(forKey: labelAccess) as! Int - (item?.value(forKey: dataForDisplay[section].labelType[0]) as! Int )
            if pricePlus > 0 {
                var price = pricePlus.toStringCurrency(currencyCode: "VND")
                cell.lblPrice.text = "+ \(price!)"
            }
            if listChoose[indexPath.section].labelType[0] == dataForDisplay[indexPath.section].labelType[indexPath.row] {
                cell.lblText.font = UIFont.boldSystemFont(ofSize: 15)
                cell.imageButton.image = #imageLiteral(resourceName: "abc_btn_radio_to_on_mtrl_015-1").withTintColor(.orange, renderingMode: .alwaysOriginal)
            } else {
                
            }
            
        //Topping Cell
        } else if dataForDisplay[indexPath.section].labelCell == stringItemInCell.topping.rawValue{
            cell.viewingMode = .checkBoxMode
            cell.lblText.text = stringToppingItem.init(rawValue: labelAccess)?.description
            var priceItem = item?.value(forKey: labelAccess) as! Int
            let price = priceItem.toStringCurrency(currencyCode: "VND")
            
            cell.lblPrice.text = "+ \(price!)"
            
            if listChoose[indexPath.section].labelType.contains(labelAccess) {
                cell.lblText.font = UIFont.boldSystemFont(ofSize: 15)
                cell.imageButton.image = #imageLiteral(resourceName: "checkboxSelected").withTintColor(.orange, renderingMode: .alwaysOriginal)
            }
        } else {
            
        //Description Cell
            cell.viewingMode = .noneMode
            cell.lblText.text = item?.value(forKey: labelAccess) as! String
        }
        
        if (selectedIndex == indexPath) && (indexPath.section != dataForDisplay.count - 1) {
//            cell.lblText.font = UIFont.boldSystemFont(ofSize: 15)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let section = indexPath.section
        if dataForDisplay[section].labelCell == stringItemInCell.size.rawValue {
            listChoose[section].labelType[0] = dataForDisplay[section].labelType[row]
        } else if dataForDisplay[section].labelCell == stringItemInCell.topping.rawValue {
            var list = listChoose[section].labelType
            let label = dataForDisplay[section].labelType[row]
            if list.contains(label) {
                let indexOfItemForRemove = list.index(of: label)!
                listChoose[section].labelType.remove(at: indexOfItemForRemove)
            } else {
                listChoose[section].labelType.append(label)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let blankView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: 0.1)))
        blankView.backgroundColor = .clear
        return blankView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class TitleHeaderItemView: UITableViewHeaderFooterView {
    
    //MARK: - Properties
    let lbl: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .groupTableViewBackground
        addSubview(lbl)
        lbl.setAnchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



