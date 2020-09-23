//
//  NewsCell.swift
//  TCHClone
//
//  Created by Trần Huy on 7/29/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

protocol NewsCellDelegate {
    var delegate: CustomNewsCellDelegate { get }
}
private let reuseIdentifer = "CustomNewsCell"
class NewsCell: UICollectionViewCell {
    //MARK: - Properties
    

    let lblTitleCell: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.black
        
        return lbl
    }()
    
    let btnOption: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.tintColor = .black
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        btn.addTarget(self, action: #selector(handlerOptionTapped), for: .touchUpInside)
        return btn
    }()
    
    fileprivate let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
        layout.minimumLineSpacing = 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomNewsCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        cv.delaysContentTouches = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    var posts: [PostData]? {
        didSet {
            guard let labelType = posts![0].type else { return }
            lblTitleCell.text = StringPostCell.init(rawValue: labelType)?.description
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNewsCell()
        collectionView.delegate = self
        collectionView.dataSource = self

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initNewsCell() {
        
        addSubview(lblTitleCell)
        lblTitleCell.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 1, paddingLeft: 10, paddingBottom: 5, paddingRight: 0)
        addSubview(btnOption)
        btnOption.setAnchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        btnOption.centerYAnchor.constraint(equalTo: lblTitleCell.centerYAnchor).isActive = true
        
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.setAnchor(top: lblTitleCell.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
    }
}

extension NewsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
        return CGSize(width: UIDevice.setSize(iPhone: collectionView.frame.width / 2, iPad: (collectionView.frame.width) / 4), height: collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! CustomNewsCell
        if indexPath.item < posts!.count {
            cell.cell = posts![indexPath.item]
        }
        return cell
    }
}


