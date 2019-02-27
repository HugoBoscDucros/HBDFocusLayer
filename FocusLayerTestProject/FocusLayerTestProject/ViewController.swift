//
//  ViewController.swift
//  FocusLayerTestProject
//
//  Created by Hugo Bosc-Ducros on 27/02/2019.
//  Copyright © 2019 HBD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var focusIsOnLabel = false
    var focusIsOnButton = false
    var isAnimating = false
    
    //let color = UIColor.black//.withAlphaComponent(0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isAnimatingFocus {
            if self.focusIsOnButton {
                self.removeFocus(animated: true, completionHandler: {
                    self.focusIsOnButton = false
                    self.focusIsOnLabel = false
                    print("finished")
                })
            } else if self.focusIsOnLabel {
                //                self.removeFocus(animated: true, completionHandler: {
                //                    self.focusIsOnLabel = false
                //                    print("finished")
                //                })
                self.reproducingFromFocus(on: button, completionHandler: {
                    self.focusIsOnButton = true
                    self.focusIsOnLabel = false
                    print("button")
                })
            } else {
                self.reproducingFromFocus(on: button, completionHandler: {
                    self.focusIsOnButton = true
                    self.focusIsOnLabel = false
                    print("button")
                })
                //                self.circleFocus(on: self.label) {
                //                    self.focusIsOnLabel = true
                //                    self.focusIsOnButton = false
                //                    print("label")
                //                }
            }
        }
        
    }
    
}

