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
    
    var currentActionIndex: Int = 0
    
    
    var currentAction : FocusLayerAction? {
        let check = self.actions.indices.contains(currentActionIndex)
        if check {
            return self.actions[currentActionIndex]
        }
        return nil
    }
    
    weak var delegate : UIViewController?
    
    public init (delegate: UIViewController, actions: FocusLayerAction...) {
        self.delegate = delegate
        self.actions = actions
    }
    
    public func start() -> Void {
        self.nextAction()
    }
    
    public func nextAction() -> Void {
        if let focusLayer = self.delegate?.getFocusLayerIfPossible() {
            guard let action = self.currentAction else {
                self.currentActionIndex = 0
                focusLayer.dismiss(animated: true, completionHandler: nil)
                return
            }
            self.currentActionIndex += 1
            self.delegate?.reproducingFromFocus(on: action.view, text: action.text, completionHandler: nil)
        }
    }
    
    
    
}
