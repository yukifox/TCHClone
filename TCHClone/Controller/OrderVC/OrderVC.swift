//
//  OrderVC.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkeletonView


private let reuseIdentifier = "Cell"
private let reusableViewIdentifier = "Header"

class OrderVC: UIViewController {
    //MARK: - Properties
    let `default` = UserDefaults.standard
    let dataStore = DataStore.shared
//    var items = [[ItemData]]()
    var listItem = [ItemData]() {
        didSet {
            groupedData()
        }
    }
    private let foodPage = CommonItemPage(collectionViewLayout: UICollectionViewLayout())
    private let drinkPage = CommonItemPage(collectionViewLayout: UICollectionViewLayout())
    private let commonPage = CommonItemPage(collectionViewLayout: UICollectionViewLayout())
    private var pageController: UIPageViewController!
    private var arrVC: [UIViewController] = []
    private var curPage: Int!
    
    
    var commonItem: [String: [ItemData]] = [:] {
        didSet {
            reloadData()
        }
    }

    var drinkItems: [String: [ItemData]] = [:] {
        didSet {
            reloadData()
        }
    }
    var foodItems: [String: [ItemData]] = [:] {
        didSet {
            reloadData()
        }
    }
    
    let transparentBackground: UIView = {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    lazy var segmentControll: CustomSegmentViewControll = {
        let sm = CustomSegmentViewControll(frame: CGRect(x: 0, y: 0, width: view.frame.width / 4 * 3, height: 50))
        sm.buttonTitles = ["Phổ biến","Thức uống","Đồ ăn"]
        sm.textColor = .black
        sm.backgroundColor = .white
        sm.selectorTextColor = UIColor.black
        sm.selectorColor = .white
        sm.selectorBottomColor = .orange
        sm.addTarget(self, action: #selector(selectedValueChanged(sender:)), for: .valueChanged)
        return sm
    }()
    var inforView: InforView = {
       let ifView = InforView()
        ifView.translatesAutoresizingMaskIntoConstraints = false
        ifView.layer.cornerRadius = 4
        return ifView
    }()
    let cartView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.isUserInteractionEnabled = true
        
        let lbl = UILabel()
        lbl.text = "Xem giỏ hàng"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .white
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    let cardNoti: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    let lblNotiAddSuccess: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    let btnIndex: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "noun_Setting button_2265583").withTintColor(.orange, renderingMode: .alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnshowIndexTapped), for: .touchUpInside)
        return btn
    }()
    lazy var hideCartView: NSLayoutConstraint = {
        let constraint = cartView.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = .defaultLow
        return constraint
    }()
    lazy var showCartView: NSLayoutConstraint = {
        let constraint = cartView.heightAnchor.constraint(equalToConstant: 50)
        constraint.priority = .defaultHigh
        return constraint
    }()
    
    let lblQuantity: UILabel = {
       let lbl = UILabel()
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.backgroundColor = .clear
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    let lblTotalPayment: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.backgroundColor = .clear
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.backgroundColor = .groupTableViewBackground
        
        return tv
    }()
    var listChoose: [[(labelCell: String, labelType: [String])]] = [] {
        didSet {
            
        }
    }
    var totalItem = 0 {
        didSet {
            updateCardView()
        }
    }
    var totalMoney = 0 {
        didSet {
            updateCardView()
        }
    }
    var isShowIndexWindow = false {
        didSet {
            if isShowIndexWindow {
                btnIndex.setImage(#imageLiteral(resourceName: "moca_rs_cross-1").withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                btnIndex.setBackgroundColor(.orange, for: .normal)
            } else {
                btnIndex.setImage(#imageLiteral(resourceName: "noun_Setting button_2265583").withTintColor(.orange, renderingMode: .alwaysOriginal), for: .normal)
                btnIndex.setBackgroundColor(.white, for: .normal)
            }
        }
    }
    var indexItem: [(textLabel: String, index: Int)] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configHeaderView()
        initView()
        fetchData()
//        fetchItemData()
        
    }
    
    
    //MARK: - Selector
    @objc func handlerDismissInforView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transparentBackground.alpha = 0
            self.inforView.alpha = 0
            self.inforView.transform = .identity
        }, completion: {(_ ) in
            self.transparentBackground.removeFromSuperview()
            self.inforView.removeFromSuperview()
            self.inforView.removeAllConstraints()
            self.inforView = InforView()
            if self.isShowIndexWindow {
                self.btnshowIndexTapped()
            }
        })
        
    }
    
    @objc func btnshowIndexTapped() {
        if !isShowIndexWindow {
            UIApplication.shared.keyWindow!.addSubview(transparentBackground)
            transparentBackground.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                UIApplication.shared.keyWindow!.addSubview(self.tableView)
                self.transparentBackground.alpha = 1
                let height = min(300, self.tableView.contentSize.height)
                self.tableView.setAnchor(top: nil, left: self.view.leftAnchor, bottom: self.btnIndex.topAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, width: 250, height: height)
                
                self.transparentBackground.bringSubviewToFront(self.btnIndex)
                self.tableView.layer.cornerRadius = 10
                self.tableView.clipsToBounds = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.removeFromSuperview()
                self.tableView.removeAllConstraints()
                self.pageController.view.bringSubviewToFront(self.btnIndex)
                self.pageController.view.bringSubviewToFront(self.cardNoti)
            })
        }
        isShowIndexWindow = !isShowIndexWindow
    }
    
    @objc func selectedValueChanged(sender: CustomSegmentViewControll)  {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.pageController.setViewControllers([self.arrVC[0]], direction: .reverse, animated: true, completion: nil)
            curPage = 0
        case 1:
            if curPage > 1 {
                self.pageController.setViewControllers([self.arrVC[1]], direction: .reverse, animated: true, completion: nil)
                curPage = 1
            } else {
                self.pageController.setViewControllers([arrVC[1]], direction: .forward, animated: true, completion: nil)
                curPage = 1
            }
        case 2:
            if curPage < 2 {
                self.pageController.setViewControllers([arrVC[2]], direction: .forward, animated: true, completion: nil)
                curPage = 2
            }
        default:
            break
        }
    }
    
    //MARK: - Handler
    func initView() {
        
        //Config NavigationBar
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .groupTableViewBackground
        
        //Config CartView
        view.addSubview(cartView)
        cartView.setAnchor(top: nil, left: view.leftAnchor, bottom: view.safeBottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        hideCartView.isActive = true
        cartView.addSubview(lblQuantity)
        lblQuantity.setAnchor(top: nil, left: cartView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        lblQuantity.centerYAnchor.constraint(equalTo: cartView.centerYAnchor).isActive = true
        view.addSubview(lblTotalPayment)
        lblTotalPayment.setAnchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15)
        lblTotalPayment.centerYAnchor.constraint(equalTo: cartView.centerYAnchor).isActive = true
        
        
        
        //Config PageView
        commonPage.viewingMode = CommonItemPage.ViewingMode(index: 0)
        commonPage.delegate = self
        arrVC.append(commonPage)
        drinkPage.viewingMode = CommonItemPage.ViewingMode(index: 1)
        drinkPage.delegate = self
        arrVC.append(drinkPage)
        foodPage.viewingMode = CommonItemPage.ViewingMode(index: 2)
        arrVC.append(foodPage)
        curPage = 1
        pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = .clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScrool in pageController.view.subviews as! [UIScrollView] {
            svScrool.delegate = self
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
            self.pageController.topLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.segmentControll.bottomAnchor, multiplier: 0).isActive = true
        })
        
        pageController.setViewControllers([commonPage], direction: .forward, animated: false, completion: nil)
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.view.setAnchor(top: segmentControll.bottomAnchor, left: view.leftAnchor, bottom: cartView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        pageController.didMove(toParent: self)
        
        pageController.view.addSubview(btnIndex)
        btnIndex.setAnchor(top: nil, left: view.leftAnchor, bottom: cartView.topAnchor, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 20, paddingRight: 0, width: 40, height: 40)
        btnIndex.layer.cornerRadius = 20
        btnIndex.clipsToBounds = true
        
        
        pageController.view.addSubview(cardNoti)
        cardNoti.setAnchor(top: nil, left: view.leftAnchor, bottom: pageController.view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 50)
        cardNoti.alpha = 0
        
        cardNoti.addSubview(lblNotiAddSuccess)
        lblNotiAddSuccess.numberOfLines = 0
        lblNotiAddSuccess.setAnchor(top: nil, left: cardNoti.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        lblNotiAddSuccess.centerYAnchor.constraint(equalTo: cardNoti.centerYAnchor).isActive = true
        
        
        
    }
    func fetchData() {
        let listDataItem = dataStore.fetchItemFromData()
        if listDataItem.count > 0 {
            self.listItem = listDataItem
        }
        if let curItemDataLocalVersion = UserDefaults.standard.object(forKey: "dataItemVersion") as? Float {
            if let curDataVersion = UserDefaults.standard.object(forKey: "versionData") as? [String: Float] {
                let curItemDataVersion = curDataVersion["itemDataVersion"]
                if curItemDataVersion! <= curItemDataLocalVersion {
                    return
                }
            }
        }
        DispatchQueue.main.async {
            self.dataStore.deleteAllItemData()
            self.dataStore.requestItemAndSaveData(completion: {(listitemdata) in
                self.listItem = listitemdata
            })
        }
        
    }
    func reloadData() {
        commonPage.listItem = commonItem
        drinkPage.listItem = drinkItems
        foodPage.listItem = foodItems
    }
    func updateCardView() {
        if self.totalItem <= 0 && self.totalMoney <= 0 {
            DispatchQueue.main.async { [self] in
                hideCartView.isActive = true
            }
        } else {
            DispatchQueue.main.async {
                self.showCartView.isActive = true
                self.lblQuantity.text = String(self.totalItem)
                self.lblTotalPayment.text = self.totalMoney.toStringCurrency(currencyCode: "VND")
            }
        }
    }
    func showNotiView(with name: String) {
        lblNotiAddSuccess.text = "\(name) đã được thêm vào giỏ!"
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.cardNoti.alpha = 1
        }, completion: {( _) -> Void in

        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: {
            UIView.animate(withDuration: 0.5, animations: {
                self.cardNoti.alpha = 0
            })
        })
//        UIView.animate(withDuration: 0.5, animations: {
//            self.cardNoti.alpha = 1
//        })
        
    }
    
    private func groupedData() {
        var tempData = [ItemData]()
        var dictCommon = [String: [ItemData]]()
        self.listItem.forEach({(item) in
            if item.populated {
                let key = stringTypeCommon.commonItems.rawValue
                if case nil = dictCommon[key]?.append(item) {
                    dictCommon[key] = [item]
                }
            }
        })
        if dictCommon[stringTypeCommon.commonItems.rawValue] != nil {
            self.commonItem = dictCommon
        }

        
        var dic : [String: [ItemData]] = [:]
        for element in listItem {
            let key = String(element.type!)
            if case nil = dic[key]?.append(element) {
                dic[key] = [element]
            }
        }
        self.drinkItems = dic
        self.foodItems[stringTypeFoods.fastfood.rawValue] = dic[stringTypeFoods.fastfood.rawValue]
        
        indexItem = []
        if commonItem.count > 0 {
            indexItem.append((textLabel: stringTypeCommon.commonItems.description, index: 0))
        }
        for labelItemType in stringDrinkItem.allCases {
            if drinkItems[labelItemType.rawValue] != nil {
                indexItem.append((textLabel: labelItemType.description, index: 1))
            }
        }
        for labelItemType in stringTypeFoods.allCases {
            if drinkItems[labelItemType.rawValue] != nil {
                indexItem.append((textLabel: labelItemType.description, index: 2))
            }
        }

    }
    
    private func indexofviewController(viewController: UIViewController) -> Int {
        if(arrVC .contains(viewController)) {
            return arrVC.index(of: viewController)!
        }
        
        return -1
    }
    func configHeaderView() {
        let viewHeader: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            v.backgroundColor = .white
            return v
        }()
        view.addSubview(viewHeader)
        viewHeader.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 50)
        viewHeader.addSubview(segmentControll)
        segmentControll.setAnchor(top: viewHeader.topAnchor, left: viewHeader.leftAnchor, bottom: viewHeader.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: viewHeader.frame.width / 4 * 3, height: 0)
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerDismissInforView))
        transparentBackground.addGestureRecognizer(gesture)
    }
}
extension OrderVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewController: viewController)
        if (index != -1 ) {
            index = index - 1
        }
        
        if (index < 0 ) {
            return nil
        } else {
            return arrVC[index]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewController: viewController)
        if index != -1 {
            index = index + 1
        }
        if(index >= arrVC.count ) {
            return nil
        } else {
            return arrVC[index]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            curPage = arrVC.index(of: (pageViewController.viewControllers?.last)!)
            self.segmentControll.updateSegmentedControlSegs(index: curPage)
        }
    }
    
}
  

extension OrderVC: CommonItemPageDelegate {
    func handlerCellOrderTapped(with itemData: ItemData) {
        UIApplication.shared.keyWindow!.addSubview(transparentBackground)
        transparentBackground.alpha = 0
        
        UIApplication.shared.keyWindow!.addSubview(inforView)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.inforView)
//        self.view.bringSubviewToFront(transparentBackground)
        inforView.item = itemData
        inforView.delegate = self
        inforView.initView()
        inforView.layoutSubviews()
        
        inforView.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: UIDevice.setSize(iPhone: self.view.frame.width * 0.8, iPad: self.view.frame.width * 0.5), height: inforView.frame.height)
        
        inforView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inforView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inforView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        inforView.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self!.transparentBackground.alpha = 1
            self!.inforView.alpha = 1
            
            self!.inforView.transform = .identity
        })
    }
}
extension OrderVC: InforViewDelegate {
    func btnComfirmOrder(with listDataChoose: [(labelCell: String, labelType: [String])], nameItem: String) {
        let dataChoose = listDataChoose
        if listChoose.count == 0 {
            listChoose.append(dataChoose)
        } else {
            var isAppendNewElement = true
            for (index, curChoosed) in listChoose.enumerated() {
                let id = dataChoose[2].labelType[0]
                let toppings = dataChoose[1].labelType
                let quantity = Int(dataChoose[3].labelType[0])
                let size = dataChoose[0].labelType[0]
                if curChoosed[2].labelType[0] == id {
                    if curChoosed[1].labelType == toppings && curChoosed[0].labelType[0] == size {
                        let curQuantity = Int(curChoosed[3].labelType[0])
                        listChoose[index][3].labelType[0] = String(curQuantity! + quantity!)
                        isAppendNewElement = false
                    } else {
                        
                    }
                } else {
                    
                }
            }
            if isAppendNewElement {
                listChoose.append(dataChoose)
            }
        }
        totalMoney = 0
        totalItem = 0
        for element in listChoose {
            let quantityTotal = Int(element[3].labelType[0])
            totalItem += quantityTotal!
            let size = Int(element[0].labelType[0])
            let id = Int(element[2].labelType[0])
            for item in listItem {
                if id! == item.id {
                let prisize = item.value(forKey: element[0].labelType[0]) as! Int
                var priceTopping = 0
                for keyAccess in element[1].labelType {
                    priceTopping += (item.value(forKey: keyAccess)!) as! Int
                }
                let quantity = Int(element[3].labelType[0])
                let subTotal = (prisize + priceTopping) * quantity!
                totalMoney += subTotal
                }
            }
        }
        showNotiView(with: nameItem)
        handlerDismissInforView()
    }
}
extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexItem.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = indexItem[indexPath.row].textLabel
        cell.selectionStyle = .gray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Danh mục món"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

