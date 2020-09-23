//
//  CustomSegmentControll.swift
//  TCHClone
//
//  Created by Trần Huy on 5/17/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class CustomSegmentControll: UIControl {
    var buttonTitles: [String]!
    var buttons = [CustomButtonImageVertical]()
    var selector: UIView!
    var imageButtons: [UIImage]?
    private var widthSize: CGFloat?
    
    var startButton: Int = 0 {
        didSet {
            updateView()
        }
    }
    var selectedSegmentIndex: Int! {
        didSet {
            
        }
    }
    
    @IBInspectable
    var borderWith:CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWith
        }
    }
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable
    var commaSaperatorButton: String = "" {
        didSet {
            updateView()

        }
    }
    @IBInspectable
    var textColor: UIColor = .black {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var selectorColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    @IBInspectable var selectorBottomColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet{
            updateView()
        }
    }
    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitles
        updateView()
    }
    
    override func layoutSubviews() {
        self.widthSize = self.bounds.width
        super.layoutSubviews()
    }
    

    func updateView() {
        buttons.removeAll()
        subviews.forEach{$0.removeFromSuperview()}
        if commaSaperatorButton != "" {
            buttonTitles = commaSaperatorButton.components(separatedBy: ",")
        }
        for (buttonIndex, buttonTitle) in buttonTitles.enumerated() {
            let button = CustomButtonImageVertical(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(textColor, for: .normal)
            
            if let buttonImage = imageButtons?[buttonIndex] {
                button.setImage(buttonImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            
            
            button.addTarget(self, action: #selector(btnTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        self.layoutIfNeeded()
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        let y = (self.frame.maxY - self.frame.minY) - 3
        selector = UIView(frame: CGRect(x: 0 + selectorWidth * CGFloat(startButton), y: 0, width: selectorWidth, height: frame.height))
        let bottomSearator: UIView = {
           let v = UIView()
            v.backgroundColor = selectorBottomColor
            return v
        }()
        selector.addSubview(bottomSearator)
        bottomSearator.setAnchor(top: nil, left: nil, bottom: selector.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: selector.frame.width, height: 1)
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setAnchor(top: self.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    @objc func btnTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.12, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    
    
    
    
}
