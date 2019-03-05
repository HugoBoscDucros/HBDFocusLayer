//
//  FocusLayerManager.swift
//  FocusLayer
//
//  Created by Kiefer Wiessler on 01/03/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit


public struct FocusLayerAction {
    
    let view: UIView!
    let text: String
    
    public init(view: UIView!, text: String) {
        self.view = view
        self.text = text
    }
    
}



public class FocusLayerManager {
    
    let actions : [FocusLayerAction]
    
    //var currentActionIndex: Int = 0
    
    
//    var currentAction : FocusLayerAction? {
//        let check = self.actions.indices.contains(currentActionIndex)
//        if check {
//            return self.actions[currentActionIndex]
//        }
//        return nil
//    }
    
    //weak var delegate : UIViewController?
    
    public init ( actions: FocusLayerAction...) {
        //self.delegate = delegate
        self.actions = actions
    }
    
    public func start(sender:UIViewController) -> Void {
        self.run(sender: sender, actions: self.actions)
        //self.nextAction()
    }
    
//    public func nextAction() -> Void {
//        if let focusLayer = self.delegate?.getFocusLayerIfPossible() {
//            guard let action = self.currentAction else {
//                self.currentActionIndex = 0
//                focusLayer.dismiss(animated: true, completionHandler: nil)
//                return
//            }
//            self.currentActionIndex += 1
//            self.delegate?.reproducingFromFocus(on: action.view, text: action.text, completionHandler: nil)
//        }
//    }
    
    private func run(sender:UIViewController, actions:[FocusLayerAction]) {
        guard let action = actions.first else {
            return
        }
        sender.reproducingFromFocus(on: action.view, text: action.text) {
            if actions.count > 1 {
                var newActions = actions
                newActions.removeFirst()
                self.run(sender: sender, actions: newActions)
            } else {
                sender.removeFocus(animated: true, completionHandler: nil)
            }
        }
    }
    
    
    
}
