//
//  NotificationViewCell.swift
//  TCHClone
//
//  Created by Trần Huy on 9/30/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
class NotificationViewCell: UITableViewCell {
    //MARK: - Properties
    let lblTitle: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = .black
        return lbl
    }()
    let lblBody: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .gray
        return lbl
    }()
    let lblTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .gray
        return lbl
    }()
    let imgNoti: UIImageView = {
       let img = UIImageView()
        img.image = #imageLiteral(resourceName: "resources_images_icons_coupon_ic")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    let dotNewNoti: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .blue
        img.frame = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
        return img
    }()
    var notiItem: NotificationData? {
        didSet {
            if notiItem?.notiID != nil {
            if notiItem!.isRead {
                backgroundColor = .white
            } else {
                backgroundColor = .lightGray
            }
                dotNewNoti.isHidden = notiItem!.isRead
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                dateFormatter.locale = NSLocale(localeIdentifier: "vn_VN_POSIX") as Locale
                dateFormatter.accessibilityLanguage = "vn_VN_POSIX"
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "HH: mm"
                dateFormatter.doesRelativeDateFormatting = true
                let dateString = dateFormatter.string(from: (notiItem?.date)!) + " \(dateFormatter2.string(from: (notiItem?.date)!))"
                
                lblTime.text = dateString
                lblBody.text = notiItem?.body
                lblTitle.text = notiItem?.title
            }
        }
    }
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Handler
    func initView() {
        addSubview(imgNoti)
        imgNoti.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        imgNoti.layer.cornerRadius = 20
        imgNoti.addSubview(dotNewNoti)
        dotNewNoti.setAnchor(top: imgNoti.topAnchor, left: nil, bottom: nil, right: imgNoti.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        addSubview(lblTitle)
        lblTitle.setAnchor(top: imgNoti.topAnchor, left: imgNoti.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        addSubview(lblBody)
        lblBody.setAnchor(top: lblTitle.bottomAnchor, left: imgNoti.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        addSubview(lblTime)
        lblTime.setAnchor(top: lblBody.bottomAnchor, left: imgNoti.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        
    }
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.timeStyle = .none
        df.dateStyle = .long
        df.doesRelativeDateFormatting = true
        return df
    }()
}
