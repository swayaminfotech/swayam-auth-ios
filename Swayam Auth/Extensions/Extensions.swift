//
//  Extensions.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
}

extension UIView {
    
    @IBInspectable
    var borderColor : UIColor {
        get {
            return .white
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return 0
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius : CGFloat {
        get {
            return 0
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func getX() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor(red: 221/255, green: 142/255, blue: 217/255, alpha: 1).cgColor,
                                UIColor(red: 244/255, green: 188/255, blue: 160/255, alpha: 1).cgColor]
        gradientLayer.locations = [0.0,1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController {
    var appHeaderHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return (UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0))
        }
    }

    var appTabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 49.0
    }
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Notification.Name {
    static let refreshChat = Notification.Name("refreshChat")
    static let refreshConvList = Notification.Name("refreshConvList")
    static let refreshPayments = Notification.Name("refreshPayments")
}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
