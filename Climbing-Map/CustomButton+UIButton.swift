//
//  CustomButton+UIButton.swift
//  Climbing-Map
//
//  Created by riku on 2021/04/26.
//

import UIKit

@IBDesignable

// UIButtonと書いているが、たとえばUIViewと書けば "View" のパーツに適応される
class CustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
