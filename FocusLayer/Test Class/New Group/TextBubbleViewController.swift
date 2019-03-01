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
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
    public var text:String?
    
    
    private var bubbleMargins : CGSize {
        let width = self.labelLeadingConstraint.constant + self.labelTrailingConstraint.constant
        let height = self.labelTopConstraint.constant + self.labelBottomConstraint.constant
        return CGSize(width: width, height: height)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }
    
    public init() {
        super.init(nibName: "TextBubbleViewController", bundle: Bundle(for: TextBubbleViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let delegate = self.popoverPresentationController?.delegate as? FocusLayer
//        self.dismiss(animated: true, completion: {
//            delegate?.dismiss(animated: true, completionHandler: nil)
//        })
        
    }
    
    func preparePopover(for sourceview: UIView, with text: String, focusLayer: FocusLayer) -> Void {
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.sourceView = sourceview.superview!
        self.popoverPresentationController?.sourceRect = focusLayer.focusFrame//view.frame
        self.popoverPresentationController?.permittedArrowDirections = .any
        self.popoverPresentationController?.delegate = focusLayer
        self.popoverPresentationController?.backgroundColor = self.view.backgroundColor
        self.label.text = text
        self.preferredContentSize = self.transformRectIfNeeded(self.label.textBoundingSize, fixedWidth: 200) + self.bubbleMargins
    }
    
    
    private func transformRectIfNeeded(_ original: CGSize, fixedWidth: CGFloat) -> CGSize {
        if original.width > fixedWidth {
            return self.label.textBoundingSizeForConstrainted(width: fixedWidth)
        } else {
            return original
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



