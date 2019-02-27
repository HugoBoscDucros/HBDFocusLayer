//
//  TextBubbleViewController.swift
//  animationTest
//
//  Created by Hugo Bosc-Ducros on 18/02/2019.
//  Copyright © 2019 Hugo Bosc-Ducros. All rights reserved.
//

import UIKit

class TextBubbleViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var text:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        if let text = self.text {
            self.label.text = text
        }
        //self.preferredContentSize = CGSize(width: 100, height: 40)
    }
    
    init() {
        super.init(nibName: "TextBubbleViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    private func size(for view:UIView) -> CGSize {
//        return view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//    }
    
    override func systemLayoutFittingSizeDidChange(forChildContentContainer container: UIContentContainer) {
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
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
