//
//  Extensions.swift
//  TCHClone
//
//  Created by Trần Huy on 7/28/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import UIKit
import CoreLocation

extension UIView {
    func setAnchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
          return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
      }

      var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
          return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
      }

      var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
          return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
      }

}
extension UIButton {

    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}

extension UIDevice {
    static func setSize(iPhone: CGFloat, iPad: CGFloat) -> CGFloat  {
        switch UIDevice.current.userInterfaceIdiom {
            
        case .phone:
            return iPhone
        case .pad:
            return iPad
        default:
            return 0
        }
    }
}

var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var selectedColorHandle: UInt8 = 0

extension UIButton {
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var selectedColor1: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension Hashable where Self : CaseIterable {
    var index: Self.AllCases.Index {
        return type(of: self).allCases.firstIndex(of: self)!
    }
}
extension NSMutableAttributedString {
    func addImageAttachment(image: UIImage, font: UIFont, textColor: UIColor, size: CGSize? = nil) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: textColor,
            .foregroundColor: textColor,
            .font: font
        ]

        self.append(
            NSAttributedString.init(
                //U+200C (zero-width non-joiner) is a non-printing character. It will not paste unnecessary space.
                string: "\u{200c}",
                attributes: textAttributes
            )
        )

        let attachment = NSTextAttachment()
        attachment.image = image.withRenderingMode(.alwaysTemplate)
        
        //P.S. font.capHeight sets height of image equal to font size.
        let imageSize = size ?? CGSize.init(width: font.capHeight, height: font.capHeight)
        attachment.bounds = CGRect(
            x: 0,
            y: 0,
            width: imageSize.width,
            height: imageSize.height
        )
        let attachmentString = NSMutableAttributedString(attachment: attachment)
        attachmentString.addAttributes(
            textAttributes,
            range: NSMakeRange(
                0,
                attachmentString.length
            )
        )
        self.append(attachmentString)
    }
}

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        get {
            return self[index(startIndex, offsetBy: i)]
        }
    }
}
extension UIImageView {
    func loadImage1(with urlString: String) {
        //check if image exits in cache
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        //url for image location
        guard let url = URL(string: urlString) else { return }
        
        //fetch content of url
        URLSession.shared.dataTask(with: url, completionHandler: {(data, respon, error) in
            //handler error
            if let err = error {
                print(err.localizedDescription)
            }
            
            // image data
            guard let imageData = data else { return }
            //set image using image data
            
            let photoImage = UIImage(data: imageData)
            
            //set key and value for imageCache
            imageCache[url.absoluteString] = photoImage
            //set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }).resume()
        
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension Array where Element == Store {
//    mutating func sort(by location: CLLocation) {
//        return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
//    }
//    
//    func sorted(by location: CLLocation) -> [Place] {
//        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
//    }
}

//extension Sequence {
//    func group<U: Hashable>(by key: (ItemData.Type) -> U) -> [U:[ItemData]] {
//        var categories: [U: [ItemData.Type]] = [:]
//                for element in self {
//                    let key = key(element as! ItemData.Type)
//                    if case nil = categories[key]?.append(element as! ItemData.Type) {
//                        categories[key] = [element]
//                    }
//                }
//                return categories
//            }
//
//}

extension UILabel{

public var requiredHeight: CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
  }
}

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension Int {
    func toStringCurrency(currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.currencyCode = currencyCode
        let textOuput = currencyFormatter.string(from: NSNumber(value: self))
        return textOuput
    }
}
extension UIView {

        func startRotating(duration: CFTimeInterval = 7, repeatCount: Float = Float.infinity, clockwise: Bool = true) {

            if self.layer.animation(forKey: "transform.rotation.z") != nil {
                return
            }

            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            let direction = clockwise ? 1.0 : -1.0
            animation.toValue = NSNumber(value: .pi * 2 * direction)
            animation.duration = duration
            animation.isCumulative = true
            animation.repeatCount = repeatCount
            animation.isRemovedOnCompletion = false
            self.layer.add(animation, forKey:"transform.rotation.z")
            
        }

        func stopRotating() {

            self.layer.removeAnimation(forKey: "transform.rotation.z")

        }

    }





