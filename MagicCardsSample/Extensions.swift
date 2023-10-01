//
//  Extensions.swift
//  MagicCardsSample
//
//  Created by Sultan on 14.09.2023.
//

import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 25, y: 2.5, width: 25, height: 25))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 30, y: 0, width: 55, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }

    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: padding,
                                           height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: padding,
                                           height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
