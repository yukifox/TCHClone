//
//  CustomSegmentViewControll.swift
//  TCHClone
//
//  Created by Trần Huy on 9/16/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
@IBDesignable
class CustomSegmentViewControll: UIControl {
    
    var buttonTitles: [String]!
    var buttons = [CustomButtonImageVertical]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    var imagesLogo = [UIImage]()
    var imageButtons: [UIImage]?
    var startButton: Int = 0 {
        didSet {
            updateView()
        }
    }

    
    
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = .clear {
        
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var commaSeperatedButtonTitles: String = "" {
        
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var textColor: UIColor = .lightGray {
        
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var selectorColor: UIColor = .darkGray {
        
        didSet {
            updateView()
        }
    }
    @IBInspectable var selectorBottomColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var selectorTextColor: UIColor = .green {
        
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateView() {
        
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        
        if commaSeperatedButtonTitles != "" {
            buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        }
        
        if buttonTitles == nil{
            return
        }
        for (buttonIndex, buttonTitle) in buttonTitles.enumerated() {
            
            let button = CustomButtonImageVertical.init(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            
            if let buttonImage = imageButtons?[buttonIndex] {
                button.setImage(buttonImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            //            button.setTitleColor(button.isSelected ? UIColor.gray : selectorTextColor, for: .normal)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        
        let y =    (self.frame.maxY - self.frame.minY) - 1.0
        
//        selector = UIView.init(frame: CGRect.init(x: 0, y: y, width: selectorWidth, height: 1.0))
//        //selector.layer.cornerRadius = frame.height/2
//        selector.backgroundColor = selectorColor
//        addSubview(selector)
        
        selector = UIView(frame: CGRect(x: 0 + selectorWidth * CGFloat(startButton), y: 0, width: selectorWidth, height: frame.height))
        selector.backgroundColor = selectorColor
        let bottomSearator: UIView = {
           let v = UIView()
            v.backgroundColor = selectorBottomColor
            return v
        }()
        selector.addSubview(bottomSearator)
        bottomSearator.setAnchor(top: nil, left: nil, bottom: selector.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: selector.frame.width, height: 2)
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        // Create a StackView
        
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        stackView.setAnchor(top: self.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        // layer.cornerRadius = frame.height/2
        
    }
    
    
    @objc func buttonTapped(button: UIButton) {
        
        
        for (buttonIndex, btn) in buttons.enumerated() {
            
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectedSegmentIndex = buttonIndex
                
                let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.selector.frame.origin.x = selectorStartPosition
                })
                
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
        
        
        
        
    }
    
    
    func updateSegmentedControlSegs(index: Int) {
        
        for btn in buttons {
            btn.setTitleColor(textColor, for: .normal)
        }
        
        let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.selector.frame.origin.x = selectorStartPosition
        })
        
        buttons[index].setTitleColor(selectorTextColor, for: .normal)
        
    }
    
    
    
    //    override func sendActions(for controlEvents: UIControlEvents) {
    //
    //        super.sendActions(for: controlEvents)
    //
    //        let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(selectedSegmentIndex)
    //
    //        UIView.animate(withDuration: 0.3, animations: {
    //
    //            self.selector.frame.origin.x = selectorStartPosition
    //        })
    //
    //        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
    //
    //    }
    
    
    
    
}
