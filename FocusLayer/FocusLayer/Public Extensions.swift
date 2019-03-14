//
//  Public Extensions.swift
//  FocusLayer
//
//  Created by Kiefer Wiessler on 06/03/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit


//MARK: - UIViewController

public extension UIViewController {
    
    public func circleFocus(on frame:CGRect, padding:CGFloat = 4, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.circleFocus(on: frame, padding: padding, animationDuration: animationDuration, completionHandler:completionHandler)
    }
    
    public func circleFocus(on view:UIView, padding:CGFloat = 4, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.circleFocus(on: view, padding: padding, animationDuration: animationDuration, completionHandler:completionHandler)
    }
    
    public func circleFocus(on center:CGPoint, radius:CGFloat, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.circleFocus(on: center, with: radius, animationDuration: animationDuration, completionHandler: completionHandler)
    }
    
    public func rectFocus(on frame:CGRect, padding:CGFloat = 4, cornerRadius:CGFloat = 5, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.rectFocus(on: frame, padding: padding, cornerRadius: cornerRadius, animationDuration: animationDuration, completionHandler:completionHandler)
    }
    
    public func rectFocus(on view:UIView, padding:CGFloat = 4, cornerRadius:CGFloat = 5, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.rectFocus(on: view, padding: padding, cornerRadius: cornerRadius, animationDuration: animationDuration, completionHandler:completionHandler)
    }
    
    public func reproducingFromFocus(on view:UIView, padding:CGFloat = 4, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        let focusLayer = self.getFocusLayerIfPossible()
        focusLayer.reproducingFormFocus(on: view, padding: padding, animationDuration: animationDuration, completionHandler:completionHandler)
    }
    
    public func removeFocus(animated:Bool, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        if let focusLayer = detectFocusLayer() {
            focusLayer.dismiss(animated: true, animationDuration: animationDuration, completionHandler:completionHandler)
        }
    }
    
    func getFocusLayerIfPossible() -> FocusLayer {
        let focusLayer = self.detectFocusLayer() ?? FocusLayer(owner: self.highestView)
        return focusLayer //?? FocusLayer(owner: self.view)
    }
    
    private func detectFocusLayer() -> FocusLayer? {
        for sublayer in self.highestView.layer.sublayers ?? [CALayer]() {
            if let focusLayer = sublayer as? FocusLayer {
                return focusLayer
            }
        }
        return nil
    }
    
    private var highestView:UIView! {
        //        var ownerView = self.view
        //        while let superView = ownerView?.superview {
        //            ownerView = superView
        //        }
        let ownerView = self.navigationController?.view ?? self.view
        return ownerView
    }
    
    var isAnimatingFocus:Bool {
        if let focusLayer = self.detectFocusLayer() {
            return focusLayer.isAnimating
        }
        return false
    }
    
    public func getAbsoluteFrameOf(subview:UIView) -> CGRect? {
        var view = subview
        var x = subview.frame.origin.x
        var y = subview.frame.origin.y
        while view != self.view {
            if let parent = view.superview {
                view = parent
                x += view.frame.origin.x
                y += view.frame.origin.y
                if let scrollView = view as? UIScrollView {
                    x -= scrollView.contentOffset.x
                    y -= scrollView.contentOffset.y
                }
            } else {
                return nil
            }
        }
        let origin = CGPoint(x: x, y: y)
        return CGRect(origin: origin, size: subview.frame.size)
    }

}
