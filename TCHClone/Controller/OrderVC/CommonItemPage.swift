//
//  CommonItemPage.swift
//  TCHClone
//
//  Created by Trần Huy on 9/16/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkeletonView
protocol CommonItemPageDelegate: class {
    func handlerCellOrderTapped(with itemData: ItemData)
}

class CommonItemPage: UICollectionViewController {

    //MARK: - Properties
    var listItem: [String: [ItemData]]! {
        didSet {
            if viewingMode == ViewingMode.drinkPage {
                self.refactorListItem()
            }
            self.collectionView.reloadData()
        }
    }
    var listTypeDrinkAvailable = [String]()
    enum ViewingMode: Int {
        case commonPage
        case drinkPage
        case foodPage
        
        init(index: Int) {
            switch index {
            case 0:
                self = .commonPage
            case 1:
                self = .drinkPage
            case 2:
                self = .foodPage
            default:
                self = .commonPage
            }
        }
    }
    var viewingMode: ViewingMode!
    var delegate: CommonItemPageDelegate?
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        initSkeletonView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //MARK: - Handler
    func configCollectionView() {
        
        self.view.backgroundColor = .groupTableViewBackground
        self.collectionView.backgroundColor = .groupTableViewBackground
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 30, right: 15)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CellItem")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TitleSectionItem.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionItem")
    }
    func initSkeletonView(){
        
        self.collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.collectionView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.collectionView.reloadData()
        })
    }
    func refactorListItem() {
        listTypeDrinkAvailable.removeAll()
        for index in 0...stringDrinkItem.allCases.count - 1 {
            if listItem[stringDrinkItem.allCases[index].rawValue] != nil {
                listTypeDrinkAvailable.append(stringDrinkItem.allCases[index].rawValue)
            }
        }
        
//        listTypeDrinkAvailable
    }
    
    
    //Delegate ColectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewingMode == .drinkPage {
            return listTypeDrinkAvailable.count
        }
        return listItem != nil ? listItem.count : 0
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewingMode {
        case .commonPage:
            return listItem[stringTypeCommon.commonItems.rawValue] != nil ? listItem[stringTypeCommon.commonItems.rawValue]?.count as! Int : 0
        case .drinkPage:
            return listItem[listTypeDrinkAvailable[section]] != nil ? listItem[listTypeDrinkAvailable[section]]?.count as! Int : 0
        case .foodPage:
            return listItem[stringTypeFoods.fastfood.rawValue]?.count != nil ? listItem[stringTypeFoods.fastfood.rawValue]?.count as! Int : 0
        case .none:
            return 0
        }
        
//        return listItem != nil ? listItem[section].count : 0
    }
    
    //MARK: - Delegate
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellItem", for: indexPath) as! OrderCell
        var arrayItems: [ItemData] = []
        if listItem.count != nil {
            switch viewingMode {
            case .commonPage:
                arrayItems = listItem[stringTypeCommon.commonItems.rawValue]!
                break
            case .drinkPage:
                arrayItems = listItem[listTypeDrinkAvailable[indexPath.section]]!
            case .foodPage:
                arrayItems = listItem[stringTypeFoods.fastfood.rawValue]!
            case .none:
                break
            }
            cell.item = arrayItems[indexPath.item]
            cell.imageItem.image = UIImage(data: arrayItems[indexPath.item].imageData!)
            cell.lblName.text = arrayItems[indexPath.item].name
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale.current
            let price = currencyFormatter.string(from: NSNumber(value: arrayItems[indexPath.item].smallprice!))!
            cell.lblSmallPrice.text = price
        }
        
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSectionItem", for: indexPath) as! TitleSectionItem
        var title = String()
        if listItem != nil {
            switch viewingMode {
            case .commonPage:
                if indexPath.section == 0 {
                    title = stringTypeCommon.commonItems.description
                }
                break
            case .drinkPage:
                let drinkType = listTypeDrinkAvailable[indexPath.section]
                title = stringDrinkItem(rawValue: drinkType)!.description
                break
            case .foodPage:
                title = stringTypeFoods.fastfood.description
                break
            default:
                title = ""
                break
        
            }
        }
        header.lblTitle.text = title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - 10, height: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! OrderCell
        let itemData = cell.item
        delegate?.handlerCellOrderTapped(with: itemData!)
        
    }

}

extension CommonItemPage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.setSize(iPhone: self.view.frame.width / 2 - 25, iPad: (self.view.frame.width - 60) / 3), height: UIDevice.setSize(iPhone: (self.view.frame.height - 30) / 2, iPad: self.view.frame.height / 3))
    }
}
extension CommonItemPage: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellItem"
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return "HeaderSectionItem"
    }
    
}
