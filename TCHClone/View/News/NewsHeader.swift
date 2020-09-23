//
//  NewsHeader.swift
//  TCHClone
//
//  Created by Trần Huy on 7/29/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class NewsHeader: UICollectionViewCell {
    //MARK: - Properties
    
    var delegate: NewsHeaderDelegate?
    let view: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .black
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHeaderView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initHeaderView(){
        addSubview(view)
        view.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        
        
        
        let firstbtn = createBtn(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg1"), title: "Tích điểm", action: #selector(handlerPointTapped))
        let second = createBtn(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg2"), title: "Đặt hàng", action: #selector(handlerOrderTapped))
        let third = createBtn(image: #imageLiteral(resourceName: "resources_images_icons_coupon_ic"), title: "Coupon", action: #selector(handlerCouponTapped))
        let fourth = createBtn(image: #imageLiteral(resourceName: "resources_images_intro_onboadingbg4"), title: "Rewards", action: #selector(handlerChangeCouponTapped))
//        var stackView: UIStackView
        let stackView = UIStackView(arrangedSubviews: [firstbtn, second, third])
        if Utilities.shared.checkIfUserIsLogIn() == true {
            stackView.addArrangedSubview(fourth)
        } else {
            stackView.removeArrangedSubview(fourth)
        }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        stackView.setAnchor(top: view.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func createBtn(image: UIImage, title: String, action: Selector?) -> UIView {
        let view: UIView = {
            let v = UIView(frame: .zero)
            
            v.isUserInteractionEnabled = true
            let gestures = UITapGestureRecognizer(target: self, action: action)
            
            gestures.numberOfTouchesRequired = 1
            v.addGestureRecognizer(gestures)
            return v
        }()
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = image
            iv.clipsToBounds = true
            iv.contentMode = .scaleAspectFit
//            iv.backgroundColor = .lightGray
           return iv
        }()
        let lbl: UILabel = {
           let lbl = UILabel()
            lbl.text = title
            lbl.font = UIFont.systemFont(ofSize: 13)
            return lbl
        }()
        view.addSubview(imageView)
        imageView.setAnchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 0, width: 70, height: 70)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(lbl)
        lbl.setAnchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
        
    }
    //MARK: - Selector
    @objc func handlerCouponTapped() {
        print("tap")
    }
    @objc func handlerOrderTapped() {
        delegate?.handlerOrderTapped(for: self)
    }
    @objc func handlerPointTapped() {
        print("tap")
    }
    @objc func handlerChangeCouponTapped() {
        print("tap")
    }
}
