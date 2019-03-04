//
//  DemoViewController.swift
//  animationTest
//
//  Created by Hugo Bosc-Ducros on 25/03/2018.
//  Copyright © 2018 Hugo Bosc-Ducros. All rights reserved.
//

import UIKit
import FocusLayer

class DemoViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var pipo: UIButton!
    @IBOutlet weak var tatouti: UIButton!
    @IBOutlet weak var helloWorld: UIButton!
    @IBOutlet weak var questionMark: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var validate: UIButton!
    @IBOutlet weak var inSubview: UIButton!
    
    
    var ActionManager : FocusLayerManager?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
        pipo.layer.borderColor = UIColor.red.cgColor
        pipo.layer.borderWidth = 1
        pipo.layer.cornerRadius = 15//38
        questionMark.layer.cornerRadius = questionMark.frame.size.height/2.0
        helloWorld.layer.borderColor = UIColor.darkGray.cgColor
        helloWorld.layer.borderWidth = 1
        inSubview.layer.cornerRadius = 8
        inSubview.layer.borderColor = UIColor.blue.cgColor
        inSubview.layer.borderWidth = 1
        
        self.ActionManager =  FocusLayerManager(delegate: self, actions:
            FocusLayerAction(view: self.pipo, text: "First Setp yataaaaa!"),
            FocusLayerAction(view: self.helloWorld, text: "Hello World! hello hello ??!!!"),
            FocusLayerAction(view: self.questionMark, text: "Any question ? call me I surely got the answer ;)")
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let double:Double = 2.3124
        let dictionary:[String:Any] = ["double":double, "int":4, "String" : "pipo"]
        let pipo = Pipo()
        let keyname = "price"
        let selector = NSSelectorFromString(keyname)
        print(selector)
        for (key, value) in dictionary {
            //pipo.setValue(value, forKey: keyname)
            if key == "double", pipo.responds(to: selector) {
                print("respond")
                pipo.setValue(value, forKey: keyname)
            } else {
                print("doesn't respond")
            }
        }
        print("pipo price : \(pipo.price)")
    }
    
    
//MARK: - Actions
    
    @IBAction func pipoDidTapped(_ sender: Any) {
//        self.reproducingFromFocus(on: pipo, completionHandler: nil)
//        let text = "Je suis un texte random, je n'ai pas d'autre raison d'exister que de remplir un foutu popover controller, YOLO !!!"
//        self.reproducingFromFocus(on: pipo, padding: 4, text: text ,completionHandler: {
//            self.reproducingFromFocus(on: self.tatouti, text: "NSM", completionHandler: nil)
//        })
        self.ActionManager?.start()
    }
    
    @IBAction func tatoutiDidTapped(_ sender: Any) {
        self.rectFocus(on: tatouti.frame,cornerRadius:1, completionHandler: nil)
//        self.reproducingFromFocus(on: tatouti, padding: 4, text: "Le ", completionHandler: nil)
    }
    
    @IBAction func helloWorldDidTapped(_ sender: Any) {
        //self.circleFocus(on: helloWorld, completionHandler: nil)
        self.circleFocus(on: helloWorld) {
//            let y = self.helloWorld.center.y + 80
//            let frame = CGRect(x: 20, y: y, width: self.view.frame.width - 40, height: 40)
//            let bubble = BubbleLayer(frame: frame, cornerRadius: 10, orientation: .up)
//            self.view.layer.addSublayer(bubble)
        }
    }
    
    @IBAction func questionMartkDidTapped(_ sender: Any) {
        //self.reproducingFromFocus(on: questionMark, completionHandler: nil)
//        self.reproducingFromFocus(on: questionMark, text:"test for popover", completionHandler: nil)
        let text = "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500 "
        self.reproducingFromFocus(on: questionMark, padding: 4, text: text ,completionHandler: nil)

    }
    
    
    @IBAction func infoButtonDidTapped(_ sender: Any) {
        self.circleFocus(on: infoButton.center, radius: infoButton.frame.width, completionHandler: nil)
    }
    
    @IBAction func validateDidTapped(_ sender: Any) {
        //self.rectFocus(on: validate.frame, cornerRadius: 10, completionHandler: nil)
        self.rectFocus(on: validate.frame, padding: 10) {
            let vc = TextBubbleViewController()
            vc.modalPresentationStyle = .popover
            vc.preferredContentSize = vc.view.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            )//CGSize(width: 280, height: 50)
            vc.popoverPresentationController?.sourceView = (sender as! UIView)
            vc.popoverPresentationController?.sourceRect = (sender as! UIView).bounds
            vc.popoverPresentationController?.permittedArrowDirections = .any
            vc.popoverPresentationController?.delegate = self
            vc.text = "pipo del pitcho"
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.removeFocus(animated: true, completionHandler: nil)
        self.ActionManager?.nextAction()
    }
    
    @IBAction func inSubviewDidTapped(_ sender: Any) {
        self.reproducingFromFocus(on: inSubview, completionHandler: nil)
    }
    
    
    
    //MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
