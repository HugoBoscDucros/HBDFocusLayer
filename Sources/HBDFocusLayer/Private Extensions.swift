//
//  Extensions.swift
//  FocusLayer
//
//  Created by Kiefer Wiessler on 06/03/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit







//MARK: - CGPoint

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func += ( left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
}




//MARK: - CGSize

extension CGSize {
    static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    static func -= ( left: inout CGSize, right: CGSize) {
        left = left - right
    }
    
    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    var area : CGFloat {
        return self.width * self.height
    }
}




//MARK: - CGRect

extension CGRect {
    var center:CGPoint {
        return CGPoint(x: (self.origin.x + self.width/2.0), y: (self.origin.y + self.height/2.0 ))
    }
}




//MARK: - UILabel

extension UILabel {
    
    func textBoundingRect(for size: CGSize) -> CGRect {
        guard
            let text = self.text,
            let font = self.font
            else { return .zero }
        
        let rect = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return rect
    }
    
    var textBoundingSize : CGSize {
        let rect = self.textBoundingRect(for: self.frame.size)
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
    
    
    func textBoundingSizeForConstrainted(width: CGFloat) -> CGSize {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.textBoundingRect(for: size)
        return CGSize(width: width, height: ceil(rect.height))
    }
    
    func textBoundingSizeForConstrainted(height: CGFloat) -> CGSize {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        let rect = self.textBoundingRect(for: size)
        return CGSize(width: ceil(rect.width), height: height)
    }
    
}
