//
//  OrderCell.swift
//  TCHClone
//
//  Created by Trần Huy on 5/27/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import SkeletonView
class OrderCell: UICollectionViewCell {
    //MARK: - Properties
    var delegate: OrderCelldDelegate?
    var item: ItemData? {
        didSet {
            guard let dataImage = item?.imageData else { return }
            imageItem.image = UIImage(data: dataImage)
            lblName.text = item?.name
            guard let price = item?.smallprice else { return }
            let attributes = NSMutableAttributedString(string: "\(price)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributes.append(NSAttributedString(string: " đ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            lblSmallPrice.attributedText = attributes
            
        }
    }
    @IBOutlet weak var imgaeFavorite: UIImageView!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSmallPrice: UILabel!
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configComponent()
        
        
        // Initialization code
    }
    
    func configComponent() {
        self.layer.shadowRadius = 10
//        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(gesture)
    }
    
    //MARK: - Selector
    
    @objc func cellTapped() {
        guard let item = self.item else { return }
        delegate?.handlerCellOrderTapped(with: item)
    }

}


