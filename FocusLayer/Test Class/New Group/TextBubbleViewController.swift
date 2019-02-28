//
//  TextBubbleViewController.swift
//  animationTest
//
//  Created by Hugo Bosc-Ducros on 18/02/2019.
//  Copyright © 2019 Hugo Bosc-Ducros. All rights reserved.
//

import UIKit

public class TextBubbleViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    public var text:String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
//        if let text = self.text {
//            self.label.text = text
//        }
        //self.preferredContentSize = CGSize(width: 100, height: 40)
    }
    
    public init() {
        super.init(nibName: "TextBubbleViewController", bundle: Bundle(for: TextBubbleViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func preparePopover(for sourceview: UIView, with text: String, focusLayer: FocusLayer) -> Void {
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.sourceView = sourceview.superview!
        self.popoverPresentationController?.sourceRect = focusLayer.focusFrame//view.frame
        self.popoverPresentationController?.permittedArrowDirections = .any
        self.popoverPresentationController?.delegate = focusLayer
        self.popoverPresentationController?.backgroundColor = self.view.backgroundColor
        self.label.text = text
        if let textRect = self.label.getBoundingRect() {
            let margins = CGSize(width: 16, height: 16) // Margins = Left,Top,Right,Bottom constraints constants of the label
            self.preferredContentSize = textRect + margins
        }
    }
    
    
    override public func systemLayoutFittingSizeDidChange(forChildContentContainer container: UIContentContainer) {
        view.setNeedsLayout()
    }
    
    override public func viewWillLayoutSubviews() {
        let size = self.label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var frame = self.label.frame
        frame.size = size
        self.label.frame = frame
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
