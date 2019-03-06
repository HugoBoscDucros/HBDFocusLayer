//
//  FocusLayerManager.swift
//  FocusLayer
//
//  Created by Kiefer Wiessler on 01/03/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit


public struct TutorialAction {
    
    let view: UIView!
    let text: String
    
    public init(view: UIView!, text: String) {
        self.view = view
        self.text = text
    }
    
}



public class TutorialAnimator {
    

    static public func run(sender: UIViewController, actions: [TutorialAction], completion: (()->())?) -> Void {
        guard let action = actions.first else {
            return
        }
        sender.reproducingFromFocus(on: action.view, text: action.text) {
            if actions.count > 1 {
                var newActions = actions
                newActions.removeFirst()
                self.run(sender: sender, actions: newActions, completion: nil)
            } else {
                sender.removeFocus(animated: true, completionHandler: nil)
                completion?()
            }
        }
    }
    
    
    
}
