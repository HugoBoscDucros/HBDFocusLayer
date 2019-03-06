//
//  FocusLayerManager.swift
//  FocusLayer
//
//  Created by Kiefer Wiessler on 01/03/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit






public class TutorialAnimator {
    
    struct Action {
        let view: UIView?
        let point: CGPoint?
        let frame: CGRect?
        let diameter: CGFloat?
        let text: String
    }
    
    var actions : [Action] = [Action]()
    
    public init () {}
    
    
    
    //MARK: - Actions Handlers
    
    public func addAction(view: UIView, text: String) -> Void {
        self.actions.append(Action(view: view, point: nil, frame: nil, diameter: nil, text: text))
    }
    
    public func addAction(point: CGPoint, diameter: CGFloat, text: String) -> Void {
        self.actions.append(Action(view: nil, point: point, frame: nil, diameter: diameter, text: text))
    }
    
    public func addAction(frame: CGRect, text: String) -> Void {
        self.actions.append(Action(view: nil, point: nil, frame: frame, diameter: nil, text: text))
    }
    
 
    //MARK: - Animator Engine

    public func run(sender: UIViewController, completion: @escaping() -> Void) -> Void {
        guard let action = self.actions.first else {
            return
        }
        if let view = action.view {
            self.reproducingFromFocus(sender: sender, on: view, text: action.text) {
                self.focusCompletion(sender: sender, completion: completion)
            }
        } else if let point = action.point, let diameter = action.diameter {
            self.circleFocus(sender: sender, on: point, radius: diameter/2.0, text: action.text) {
                self.focusCompletion(sender: sender, completion: completion)
            }
        } else if let frame = action.frame {
            self.rectFocus(sender: sender, on: frame, text: action.text) {
                self.focusCompletion(sender: sender, completion: completion)
            }
        }
        
    }
    
    

    //MARK:- Utils
    

    
    private func reproducingFromFocus(sender: UIViewController, on view:UIView, padding:CGFloat = 4, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION,text:String,completionHandler:(()->())?) {
        let focusLayer = sender.getFocusLayerIfPossible()
        focusLayer.reproducingFormFocus(on: view, padding: padding, animationDuration: animationDuration) {
            focusLayer.popoverCompletion = completionHandler
            let vc = TextBubbleViewController()
            vc.preparePopover(with: text, focusLayer: focusLayer)
            sender.present(vc, animated: true, completion: nil)
        }
    }
    
    private func circleFocus(sender: UIViewController, on center:CGPoint, radius:CGFloat, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION, text: String, completionHandler:(()->())?) {
        let focusLayer = sender.getFocusLayerIfPossible()
        focusLayer.circleFocus(on: center, with: radius, animationDuration: animationDuration) {
            focusLayer.popoverCompletion = completionHandler
            let vc = TextBubbleViewController()
            vc.preparePopover(with: text, focusLayer: focusLayer)
            sender.present(vc, animated: true, completion: nil)
        }
    }
    
    private func rectFocus(sender: UIViewController, on frame:CGRect, padding:CGFloat = 4, cornerRadius:CGFloat = 5, animationDuration:CFTimeInterval = DEFAULT_FOCUS_ANIMATION_DURATION, text: String, completionHandler:(()->())?) {
        let focusLayer = sender.getFocusLayerIfPossible()
        focusLayer.rectFocus(on: frame, padding: padding, cornerRadius: cornerRadius, animationDuration: animationDuration) {
            focusLayer.popoverCompletion = completionHandler
            let vc = TextBubbleViewController()
            vc.preparePopover(with: text, focusLayer: focusLayer)
            sender.present(vc, animated: true, completion: nil)
        }
    }
    
    private func focusCompletion(sender: UIViewController, completion: @escaping()->()) -> Void {
        if self.actions.count > 1 {
            self.actions.removeFirst()
            self.run(sender: sender, completion: completion)
        } else {
            self.actions.removeFirst()
            sender.removeFocus(animated: true, completionHandler: nil)
            completion()
        }
    }
    
}
