//
//  CornerRadiusViewShadow.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit

@IBDesignable
class CornerRadiusViewShadow: UIView {

    var shadowLayer = CAShapeLayer()
    var shadowColorSet = UIColor.lightGray
    var shadowRadiusSet : CGFloat = 2.5
    var shadowOpacitySet : Float = 0.25

    @IBInspectable var cornerRadiusValue : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor : UIColor {
        get {
            return theamColor
        }
        set {
            self.shadowColorSet = newValue
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat {
        get {
            return 8.0
        }
        set {
            self.shadowRadiusSet = newValue
        }
    }
    
    @IBInspectable var shadowOpacity : Float {
        get {
            return 0.3
        }
        set {
            self.shadowOpacitySet = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shadowLayer = CAShapeLayer()
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadiusValue ).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowPath = shadowLayer.path;
        shadowLayer.shadowColor = shadowColorSet.cgColor
        shadowLayer.shadowRadius = shadowRadiusSet;
        shadowLayer.shadowOpacity = shadowOpacitySet;
        shadowLayer.shadowOffset = CGSize(width: 0 , height: 0)
    }
}
