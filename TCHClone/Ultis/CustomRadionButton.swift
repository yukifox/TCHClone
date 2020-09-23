//
//  CustomRadionButton.swift
//  TCHClone
//
//  Created by Trần Huy on 6/18/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    internal var outerCircleLayer = CAShapeLayer()
    internal var innerCircleLayer = CAShapeLayer()
    internal var buttonTextLabel = UILabel()
    internal var buttonTailLabel = UILabel()
    
    private var width: CGFloat = 20
    private var height: CGFloat = 20
    private let saparator: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        
        return v
    }()
    
    //MARK: - Properties
    public var deselectedColor: UIColor = UIColor.orange {
        didSet {
            outerCircleLayer.strokeColor = deselectedColor.cgColor
        }
    }
    
    public var selectedColor: UIColor = UIColor.orange {
        didSet {
            setFillState()
        }
    }
    
    public var outerCircleLineWidth: CGFloat = 1.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    public var circlePadding: CGFloat = 2.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    public var titleText: String = "" {
        didSet {
            self.buttonTextLabel.text = titleText
        }
    }
    
    public var titleTextTail: String = "" {
        didSet {
            self.buttonTailLabel.text = titleTextTail
        }
    }
    
    public var titleFontType: String = "Helvetica" {
        didSet {
            self.buttonTextLabel.font = UIFont(name: titleFontType, size: titleSize)
        }
    }
    
    public var titleSize: CGFloat = 16 {
        didSet {
            self.titleLabel?.font = UIFont(name: titleFontType, size: titleSize)
        }
    }
    
    public var buttonHeight: CGFloat = 20 {
        didSet {
        self.height = buttonHeight
    
        }
    }
    
    public var buttonWidth: CGFloat = 20 {
        didSet {
            self.width = buttonWidth
        }
    }
    
    //MARK: - Private properties
    
    internal var setCircelRadius: CGFloat {
        let lenght = width > height ? height : width
        return (lenght - outerCircleLineWidth) / 2
    }
    
    private var setCircleFrame: CGRect {
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private var outerCirclePath: UIBezierPath {
        return UIBezierPath(roundedRect: setCircleFrame, cornerRadius: setCircelRadius)
    }
    
    private var innerCirclePath: UIBezierPath {
        let trueGap = circlePadding + (outerCircleLineWidth / 2)
        return UIBezierPath(roundedRect: setCircleFrame.insetBy(dx: trueGap, dy: trueGap), cornerRadius: setCircelRadius)
    }
    
    //MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
//        print(self.isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        initialise()
    }
    
    convenience init(frame: CGRect,  titleLable: String, titleTailLabel: String) {
        self.init(frame: frame)
    }
    //MARK: - Private Methods
    
    
    
    private func initialise() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = deselectedColor.cgColor
        layer.addSublayer(outerCircleLayer)
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeColor  = UIColor.clear.cgColor
        
        layer.addSublayer(innerCircleLayer)
        
        buttonTextLabel.frame = CGRect(x: width + 25, y: 0, width: 100, height: height)
        self.addSubview(buttonTextLabel)
        self.addSubview(buttonTailLabel)
        buttonTailLabel.setAnchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
//        self.addSubview(saparator)
//        saparator.setAnchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -1, paddingRight: 0, width: self.frame.width, height: 0.5)
        setFillState()
        
        
    }
    //MARK: - Private Methods
    private func setCircleLayouts() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.path = outerCirclePath.cgPath
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.path = innerCirclePath.cgPath
        
        buttonTextLabel.frame = CGRect(x: width + 10, y: 0, width: 100, height: height + 5)
    }
    
    private func setFillState() {
        if self.isSelected {
            outerCircleLayer.strokeColor = selectedColor.cgColor
            innerCircleLayer.fillColor = selectedColor.cgColor
            self.buttonTailLabel.font = UIFont(name: titleFontType + "-Bold", size: titleSize)
            self.buttonTextLabel.font = UIFont(name: titleFontType + "-Blod", size: titleSize)
        } else {
            outerCircleLayer.strokeColor = deselectedColor.cgColor
            innerCircleLayer.fillColor = UIColor.clear.cgColor
            self.buttonTailLabel.font = UIFont(name: titleFontType, size: titleSize)
            self.buttonTextLabel.font = UIFont(name: titleFontType, size: titleSize)
        }
    }
    
    //MARK: - Overridden Methods
    public override func prepareForInterfaceBuilder() {
        initialise()
    }
    
    public override func layoutSubviews() {
        setCircleLayouts()
    }
    
    public override var isSelected: Bool {
        didSet {
            setFillState()
        }
    }
}
