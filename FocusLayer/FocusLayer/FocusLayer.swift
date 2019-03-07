//
//  FocusLayerView.swift
//  animationTest
//
//  Created by Hugo Bosc-Ducros on 21/03/2018.
//  Copyright © 2018 Hugo Bosc-Ducros. All rights reserved.
//

import UIKit

public let DEFAULT_FOCUS_ANIMATION_DURATION:CFTimeInterval = 0.6

public class FocusLayer : CAShapeLayer, UIPopoverPresentationControllerDelegate {
    
    weak var owner:UIView!
    var focusFrame:CGRect!
    var currentCornerRadius:CGFloat!
    var isAnimating = false
    var TextLayer:BubbleLayer?
    var popoverCompletion:(()->())?

    
//MARK: - Init
    
    init(owner:UIView) {
        super.init()
        self.owner = owner
        self.fillRule = CAShapeLayerFillRule.evenOdd
        self.fillColor = UIColor.black.cgColor
        self.opacity = 0.5
        owner.layer.addSublayer(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK: - focuses
    
    public func circleFocus(on frame:CGRect, padding:CGFloat, animationDuration:CFTimeInterval,completionHandler:(()->())?) {
        let (focusFrame,radius) = self.getCircleFocusFrameAndRadius(for: frame, padding: padding)
        self.focusFrame = focusFrame
        self.currentCornerRadius = radius
        let (startPath, endPath) = self.pathes(focusFrame: focusFrame, cornerRadius: radius)
        self.animate(from:startPath,to: endPath, duration: animationDuration,completionHandler: {
            self.TextLayer = self.makeBuble(focusFame: focusFrame, orientation: .top)
            self.animateApparition(layer: self.TextLayer!, duration: 0.2, completionHandler: completionHandler)
        })
    }
    
    public func circleFocus(on view:UIView, padding:CGFloat, animationDuration:CFTimeInterval, completionHandler:(()->())?) {
        let frame = self.getAbsoluteFrame(of: view)
        self.circleFocus(on: frame, padding: padding, animationDuration: animationDuration, completionHandler: completionHandler)
    }
    
    public func circleFocus(on center:CGPoint, with radius:CGFloat, animationDuration:CFTimeInterval,completionHandler:(()->())?) {
        self.focusFrame = self.getCircleFocusFrame(for: center, radius: radius)
        self.currentCornerRadius = radius
        let (startPath, endPath) = self.pathes(focusFrame: focusFrame, cornerRadius: radius)
        self.animate(from:startPath,to: endPath, duration: animationDuration,completionHandler: completionHandler)
    }
    
    public func rectFocus(on frame:CGRect, padding:CGFloat, cornerRadius:CGFloat, animationDuration:CFTimeInterval,completionHandler:(()->())?) {
        self.focusFrame = self.getRectFocusFrame(for: frame, padding: padding)
        self.currentCornerRadius = cornerRadius
        let (startPath, endPath) = self.pathes(focusFrame: focusFrame, cornerRadius: cornerRadius)
        self.animate(from:startPath,to: endPath, duration: animationDuration,completionHandler: completionHandler)
    }
    
    public func rectFocus(on view:UIView, padding:CGFloat, cornerRadius:CGFloat, animationDuration:CFTimeInterval,completionHandler:(()->())?) {
        let frame = self.getAbsoluteFrame(of: view)
        self.rectFocus(on: frame, padding: padding, cornerRadius: cornerRadius, animationDuration: animationDuration, completionHandler: completionHandler)
    }
    
    public func reproducingFormFocus(on view:UIView, padding:CGFloat, animationDuration:CFTimeInterval,completionHandler:(()->())?) {
        let frame = self.getAbsoluteFrame(of: view)
        self.focusFrame = self.getRectFocusFrame(for: frame, padding: padding)
        self.currentCornerRadius = self.getPropCornerRadius(from: frame, cornerRadius: view.layer.cornerRadius, to: focusFrame)
        let (startPath, endPath) = self.pathes(focusFrame: focusFrame, cornerRadius: currentCornerRadius)
        self.animate(from:startPath,to: endPath, duration: animationDuration,completionHandler: completionHandler)
    }
    
    public func dismiss(animated:Bool, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,completionHandler:(()->())?) {
        if animated {
            let path = self.ownerPath(from: self.focusFrame, cornerRadius: self.currentCornerRadius)
            self.animate(to: path, duration: animationDuration, completionHandler: {
                self.removeFromSuperlayer()
                self.focusFrame = nil
                completionHandler?()
            })
        } else {
            self.removeFromSuperlayer()
            self.focusFrame = nil
            completionHandler?()
        }
    }
    
    
//MARK: - Animation
    
    private func animate(from:UIBezierPath? = nil,to:UIBezierPath, duration:CFTimeInterval, completionHandler:(()->())?) {
        if let bubble = self.TextLayer {
            let durationPartOne = duration/4.0
            let durationPartTwo = duration - durationPartOne
            self.animateDisparition(layer: bubble, duration: durationPartOne, completionHandler: {
                self.animateShapeTransformation(from: from, to: to, duration: durationPartTwo, completionHandler: completionHandler)
            })
        } else {
            self.animateShapeTransformation(from: from, to: to, duration: duration, completionHandler: completionHandler)
        }
    }
    
    private func animateShapeTransformation(from:UIBezierPath? = nil,to:UIBezierPath, duration:CFTimeInterval, completionHandler:(()->())?) {
        self.isAnimating = true
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "path")
        if let startPath = from, self.path == nil {
            animation.fromValue = startPath.cgPath
            
        }
        animation.toValue = to.cgPath
        animation.duration = duration// duration is 1 sec
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut) // animation curve is Ease Out
        animation.fillMode = CAMediaTimingFillMode.forwards // keep to value after finishing
        animation.isRemovedOnCompletion = false // don't remove after finishing
        CATransaction.setCompletionBlock {
            self.isAnimating = false
            self.path = to.cgPath
            completionHandler?()
        }
        self.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    private func animateApparition(layer:CAShapeLayer,duration:CFTimeInterval,completionHandler:(()->())?) {
        layer.opacity = 0
        self.addSublayer(layer)
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "opacity")
        //animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards // keep to value after finishing
        animation.isRemovedOnCompletion = false // don't remove after finishing
        CATransaction.setCompletionBlock {
            self.isAnimating = false
            completionHandler?()
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    private func animateDisparition(layer:CAShapeLayer,duration:CFTimeInterval,completionHandler:(()->())?) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards // keep to value after finishing
        animation.isRemovedOnCompletion = false // don't remove after finishing
        CATransaction.setCompletionBlock {
            self.isAnimating = false
            layer.removeFromSuperlayer()
            completionHandler?()
        }
        layer.add(animation, forKey: nil)
        CATransaction.commit()
    }

    
//MARK: - Layer path
    
    private func pathes(focusFrame:CGRect, cornerRadius:CGFloat) -> (UIBezierPath, UIBezierPath) {
//        let ownerFrame = self.getownerFrame(for: focusFrame)
//        let ownerPath = self.ownerPath(from: focusFrame, cornerRadius: cornerRadius)
        let (ownerFrame,ownerRadius) = self.getOwnerFrameAndRadius(for: focusFrame, cornerRadius: cornerRadius)
        let ownerPath = UIBezierPath(roundedRect: ownerFrame, cornerRadius: 0)
        ownerPath.append(UIBezierPath(roundedRect: ownerFrame, cornerRadius: ownerRadius))
        let focusPath = UIBezierPath(roundedRect:ownerFrame, cornerRadius:0)
        focusPath.append(UIBezierPath(roundedRect: focusFrame, cornerRadius: cornerRadius))
        return (ownerPath, focusPath)
    }
    
    private func ownerPath(from:CGRect, cornerRadius:CGFloat) -> UIBezierPath {
//        let endFrame = self.getownerFrame(for: from)
//        let endRadius = self.getPropCornerRadius(from: from, cornerRadius: cornerRadius, to: endFrame)
        //let frame = self.owner.frame
        let (endFrame,endRadius) = self.getOwnerFrameAndRadius(for: from, cornerRadius: cornerRadius)
        let path = UIBezierPath(roundedRect: endFrame, cornerRadius: 0)
        path.append(UIBezierPath(roundedRect: endFrame, cornerRadius: endRadius))
        return path
    }
    
    
//MARK: - Calculate frame & corner radius methods
    
    private func getRectFocusFrame(for frame:CGRect, padding:CGFloat) -> CGRect {
        let x = frame.origin.x - padding
        let y = frame.origin.y - padding
        let width = frame.width + 2 * padding
        let height = frame.height + 2 * padding
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func getCircleFocusFrameAndRadius(for frame:CGRect, padding:CGFloat) -> (CGRect, CGFloat) {
        let radius:CGFloat = sqrt(pow(frame.width, 2) + pow(frame.height, 2))/2.0 + padding
        let x = (frame.origin.x + frame.size.width/2.0) - radius
        let y = (frame.origin.y + frame.size.height/2.0) - radius
        let frame = CGRect(x: x, y: y, width: 2*radius, height: 2*radius)
        return (frame, radius)
    }
    
    private func getCircleFocusFrame(for center:CGPoint, radius:CGFloat) -> CGRect {
        let x = center.x - radius
        let y = center.y - radius
        let frame = CGRect(x:x, y:y, width: 2 * radius, height: 2 * radius)
        return frame
    }
    
    private func getOwnerFrameAndRadius(for frame:CGRect, cornerRadius:CGFloat) -> (CGRect, CGFloat) {
        let Hp = owner.frame.height
        let Wp = owner.frame.width
        let denumParam:CGFloat = 2.0 * cornerRadius * (1.0 - (1.0 / sqrt(2)))
        let H1a = Hp * frame.height / (frame.height - denumParam)
        let H1b = Wp * frame.height / (frame.width - denumParam)
        let height = max(H1a, H1b)
        let width = height * frame.width / frame.height
        let x = owner.center.x - width/2.0
        let y = owner.center.y - height/2.0
        let ownerRadius = height * cornerRadius / frame.height
        let ownerFrame = CGRect(x: x, y: y, width: width, height: height)
        return (ownerFrame, ownerRadius)
    }
    
    private func getPropCornerRadius(from:CGRect, cornerRadius:CGFloat, to:CGRect) -> CGFloat {
        if cornerRadius == 0 { return 1.0 }
        let startDiag:CGFloat = sqrt(pow(from.width, 2) + pow(from.height, 2))
        let endDiag:CGFloat = sqrt(pow(to.width, 2) + pow(to.height, 2))
        let diagProp = endDiag/startDiag
        return cornerRadius * diagProp
    }
    
//MARK: - Calculate absolute frame
    
    private func getAbsoluteFrame(of:UIView) -> CGRect{
        var frame = of.frame
        frame.origin = self.getAbsoluteCoordinate(of: of, from: self.owner)
        return frame
    }
    
    private func getAbsoluteCoordinate(of:UIView,from:UIView) -> CGPoint {
        var view = of
        var coordinate = view.frame.origin
        while view != from, let superView = view.superview {
            coordinate += superView.frame.origin
            view = superView
        }
        return coordinate
    }
    
    
    //MARK: - UIPopoverPresentationControllerDelegate
    

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        return true
//    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.popoverCompletion?()
        self.popoverCompletion = nil
    }
    
    
//MARK: - Make bubble
    
    private func makeBuble(focusFame:CGRect, orientation:BubbleLayer.BubbleLayerOrientation) -> BubbleLayer {
        let y = focusFrame.origin.y - 60 - 18
        let x = focusFrame.center.x - 100
        let frame = CGRect(x: x, y: y, width: 200, height: 60)
        return BubbleLayer(frame: frame, cornerRadius: 10, orientation: orientation)
        //self.addSublayer(bubble)
    }
    
}



protocol PopoverFocusDelegate:UIPopoverPresentationControllerDelegate {

}

typealias FocusViewController = PopoverFocusDelegate & UIViewController

extension PopoverFocusDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}






