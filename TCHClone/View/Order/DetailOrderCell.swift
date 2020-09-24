//
//  DetailOrderCell.swift
//  TCHClone
//
//  Created by Trần Huy on 9/23/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
protocol DetailOrderCellProtocol: class {
    func updateheightOfTextView(_ cell: DetailOrderCell, textView: UITextView)
}

class DetailOrderCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblPriceTotalSmall: UILabel!
    @IBOutlet weak var lblPriceTotal: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tvNote: UITextView!
    weak var cellDelegate: DetailOrderCellProtocol?
    var textChanged: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblNumber.layer.borderWidth = 0.5
        lblNumber.layer.borderColor = UIColor.black.cgColor
        lblNumber.textColor = UIColor.orange
        lblNumber.textAlignment = .center
        lblNumber.frame.size = CGSize(width: 30, height: 30)
        tvNote.sizeToFit()
        tvNote.isEditable = true
        tvNote.delegate = self
        tvNote.text = "Bạn muốn dặn dò gì không? (50 kí tự)"
        tvNote.textColor = .lightGray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textChanged(action: @escaping (String) -> Void) {
            self.textChanged = action
    }
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        self.textChanged!(tvNote.text)
//    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
        if let delegate = cellDelegate {
            delegate.updateheightOfTextView(self, textView: tvNote)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Bạn muốn dặn dò gì không? (50 kí tự)"
            textView.textColor = .lightGray
        }
    }
    
}
