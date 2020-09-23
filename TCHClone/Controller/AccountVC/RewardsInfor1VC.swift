//
//  RewardsInfor1VC.swift
//  TCHClone
//
//  Created by Trần Huy on 8/31/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class RewardsInforVC1: UIViewController {
    var user: User? {
        didSet {
            lblText.text = user?.name
        }
    }
    //MARK: - Properties
    var lblText: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    lazy var mainView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .groupTableViewBackground
        scrollView.addSubview(lblText)
        lblText.setAnchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 55)
        return scrollView
    }()
    let namCardView: DesignableView = {
       let v = DesignableView()
        return v
    }()
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        view.addSubview(mainView)
        mainView.setAnchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
}
