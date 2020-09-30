//
//  CheckMyCart.swift
//  TCHClone
//
//  Created by Trần Huy on 9/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class CheckMyCart: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    //MARK: - Properties
    let mainView = UIScrollView()
    let bottomView = UIView()
    let btnOrder: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundColor(.orange, for: .normal)
        btn.setBackgroundColor(.black, for: .highlighted)
        btn.setTitle("Đặt hàng", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    let lblTotalPayment: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    let lblTotalPaymentBtn: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    let imgImagePayment = UIImageView()
    let lblMethodPayment: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .gray
        return lbl
    }()
    let btnCoupon: CustomButtonImageVertical = {
        let btn = CustomButtonImageVertical(type: .system)
        btn.setImage(#imageLiteral(resourceName: "resources_images_icons_coupon").withTintColor(.orange, renderingMode: .alwaysOriginal), for: .normal)
        btn.setTitle("Mã giảm giá", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    let tableView = UITableView()
    var user: User? {
        didSet {
            
        }
    }
    var listItem: [ItemData]?
    var myListOrder: [[(labelCell: String, labelType: [String])]] = [] {
        didSet {
//            self.tableView.reloadData()
            self.caculatorTotalMoney()
        }
    }
    var listTotalMoney: [Int] = []
    var totalMoney: Int = 0 {
        didSet {
            lblTotalPayment.text = totalMoney.toStringCurrency(currencyCode: "VND")
            lblTotalPaymentBtn.text = totalMoney.toStringCurrency(currencyCode: "VND")
        }
    }
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configTableView()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Handler
    func configNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "moca_rs_cross-1"), style: .plain, target: self, action: #selector(handlerClose))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Giỏ hàng của bạn"
        tabBarController?.tabBar.isHidden = true
    }
    func initView() {
        
    }
    func configTableView() {
        view.addSubview(mainView)
        view.backgroundColor = .groupTableViewBackground
        view.addSubview(bottomView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        bottomView.backgroundColor = .white
        bottomView.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeBottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 140)
        let topLine = UIView()
        bottomView.addSubview(topLine)
        topLine.setAnchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: nil, right: bottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 0.3)
        topLine.backgroundColor = .gray
        let seperator = UIView()
        seperator.backgroundColor = .gray
        bottomView.addSubview(seperator)
        
        mainView.backgroundColor = .groupTableViewBackground
        mainView.setAnchor(top: view.safeTopAnchor, left: view.leftAnchor, bottom: bottomView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        //TableView
        mainView.addSubview(tableView)
        tableView.isScrollEnabled = true
        tableView.setAnchor(top: mainView.contentLayoutGuide.topAnchor, left: mainView.frameLayoutGuide.leftAnchor, bottom: mainView.frameLayoutGuide.bottomAnchor, right: mainView.frameLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.backgroundColor = .groupTableViewBackground
        tableView.estimatedSectionHeaderHeight = 30
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "CellInfoPayment", bundle: nil), forCellReuseIdentifier: "InfoPaymentCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellSchedule")
        tableView.register(UINib(nibName: "DetailOrderCell", bundle: nil), forCellReuseIdentifier: "DetailOrder")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.layoutIfNeeded()
        mainView.contentSize = CGSize(width: view.frame.width, height: tableView.contentSize.height + 50)
        
        bottomView.addSubview(btnOrder)
        btnOrder.setAnchor(top: nil, left: bottomView.leftAnchor, bottom: bottomView.bottomAnchor, right: bottomView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 50)
        seperator.setAnchor(top: bottomView.topAnchor, left: nil, bottom: btnOrder.topAnchor, right: nil, paddingTop: 5, paddingLeft: 9, paddingBottom: 5, paddingRight: 9, width: 0.5)
        seperator.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        btnOrder.addSubview(lblTotalPaymentBtn)
        lblTotalPaymentBtn.setAnchor(top: nil, left: nil, bottom: nil, right: btnOrder.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10)
        lblTotalPaymentBtn.centerYAnchor.constraint(equalTo: btnOrder.centerYAnchor).isActive = true
        let lblPayment1 = lblTotalPayment
        lblPayment1.textColor = .black
        let stackViewPayment = UIStackView(arrangedSubviews: [imgImagePayment,lblMethodPayment, lblPayment1])
        stackViewPayment.axis = .vertical
        imgImagePayment.image = #imageLiteral(resourceName: "resources_images_icons_ic_cash-1")
        lblMethodPayment.text = "Tiền mặt"
        stackViewPayment.distribution = .equalCentering
        stackViewPayment.alignment = .center
        stackViewPayment.spacing = 5
        bottomView.addSubview(stackViewPayment)
        stackViewPayment.setAnchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: btnOrder.topAnchor, right: seperator.leftAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 2)
        let stackViewCoupon = UIStackView(arrangedSubviews: [])
        bottomView.addSubview(btnCoupon)
        btnCoupon.setAnchor(top: nil, left: seperator.rightAnchor, bottom: nil, right: bottomView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        btnCoupon.centerYAnchor.constraint(equalTo: stackViewPayment.centerYAnchor).isActive = true

        
        
        
    }
    
    func caculatorTotalMoney() {
        listTotalMoney.removeAll()
        var totalItem = 0
        totalMoney = 0
        for element in myListOrder {
            let quantity = Int(element[3].labelType[0])
            let size = Int(element[0].labelType[0])
            let id = Int(element[2].labelType[0])
            for item in listItem! {
                if id! == item.id {
                let pricesize = item.value(forKey: element[0].labelType[0]) as! Int
                var priceTopping = 0
                for keyAccess in element[1].labelType {
                    priceTopping += (item.value(forKey: keyAccess)!) as! Int
                }
                let quantity = Int(element[3].labelType[0])
                let subTotal = (pricesize + priceTopping) * quantity!
                    listTotalMoney.append(subTotal)
                totalMoney += subTotal
                }
            }
        }
    }
    //MARK: - Selector
    @objc func handlerClose() {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    @objc func keyBoardWillShow(notification: Notification) {
        guard let keyboardInfor = notification.userInfo else {return}
        if let keyboardSize = (keyboardInfor[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let keyBoardHeight = keyboardSize.height + 10
            let contenInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardHeight, right: 0)
            self.mainView.contentInset = contenInset
            var viewRect = self.view.frame
            viewRect.size.height -= keyBoardHeight
            

        }
    }
    @objc func keyBoardWillHide(notification: Notification) {
        let contenInset = UIEdgeInsets.zero
        self.mainView.contentInset = contenInset
    }
    //MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1: return 1
        case 2: return myListOrder.count + 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoPaymentCell", for: indexPath) as! CellInfoPayment
            cell.tfName.text = user?.name ?? ""
            cell.tfName.text = user?.phone ?? ""
            cell.selectionStyle = .none
    
            return cell
        case 1:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellSchedule")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.text = "Hẹn giờ"
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.detailTextLabel?.text = "Trong thời gian 15 - 30 phút"
            cell.imageView?.image = #imageLiteral(resourceName: "resources_images_icons_ic_hour_countdown")
            cell.selectionStyle = .none
            return cell
        case 2:
            if indexPath.row == myListOrder.count {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "DefaultCell")
                cell.textLabel?.text = "Tạm tính \nPhí giao hàng"
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "\(totalMoney.toStringCurrency(currencyCode: "VND")!)\n Miễn phí"
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.textColor = .black
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
                cell.selectionStyle = .none
                return cell
            }
            if indexPath.row > myListOrder.count {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "DefaultCell")
                cell.textLabel?.text = "Tổng tiền"
                cell.detailTextLabel?.text = totalMoney.toStringCurrency(currencyCode: "VND")!
                cell.detailTextLabel?.textColor = .black
                cell.selectionStyle = .none
                return cell
            }
            var cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrder", for: indexPath) as! DetailOrderCell
            cell.cellDelegate = self
            cell.lblNumber.text = String(myListOrder[indexPath.row][3].labelType[0])
            let id = Int(myListOrder[indexPath.row][2].labelType[0])
            listItem?.forEach({(item) in
                if id == item.value(forKey: "id") as! Int {
                    cell.lblName.text = item.name!
                }
            })
            
            cell.lblPriceTotal.text = listTotalMoney[indexPath.row].toStringCurrency(currencyCode: "VND")
            cell.lblPriceTotalSmall.text = listTotalMoney[indexPath.row].toStringCurrency(currencyCode: "VND")
            cell.lblSize.text = stringSizeItem(rawValue: myListOrder[indexPath.row][0].labelType[0])?.description
            let lisTopping = myListOrder[indexPath.row][1].labelType
            for (index, toppingName) in lisTopping.enumerated() {
                cell.lblSize.text?.append(", \(stringToppingItem(rawValue: toppingName)!.description)")
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Thông tin đơn hàng"
        case 1:
            return "Thời gian nhận hàng"
        case 2:
            return "Chi tiết đơn hàng"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
extension CheckMyCart: DetailOrderCellProtocol {
    func updateheightOfTextView(_ cell: DetailOrderCell, textView: UITextView) {
        let size = textView.bounds.size
//        let newSizee = tableView.cellForRow(at: <#T##IndexPath#>)
        let newSize = tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            mainView.contentSize.height = tableView.contentSize.height + 50
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: true)
            }
        }
    }
}
extension CheckMyCart: UITextViewDelegate {
    
}

