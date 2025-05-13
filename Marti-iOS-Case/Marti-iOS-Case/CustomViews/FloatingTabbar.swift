//
//  FloatingTabbar.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 13.05.2025.
//

import UIKit

final class FloatingTabbar: UITabBar {
    private let customHeight: CGFloat = 70
    private let horizontalMargin: CGFloat = 32
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = customHeight
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        let yOffset = safeArea > 0 ? safeArea / 2 : 10
        
        self.frame = CGRect(
            x: horizontalMargin,
            y: self.superview!.bounds.height - customHeight - yOffset - 10,
            width: self.superview!.bounds.width - 2 * horizontalMargin,
            height: customHeight
        )
        
        self.layer.cornerRadius = customHeight / 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.systemBackground
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
    }
}
