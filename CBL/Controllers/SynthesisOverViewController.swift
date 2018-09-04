//
//  SynthesisOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SynthesisOverViewController: UIViewController {

    @IBOutlet weak var textAreaSynthesis: UITextView!
   
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewSizeConstraint: NSLayoutConstraint!
    
    var numberOfLines: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textAreaSynthesis.delegate = self
        
//        self.tabBarItem.image = #imageLiteral(resourceName: "synthesis")
        
        //Set placeholder for textView
        if textAreaSynthesis.text == ""{
            textAreaSynthesis.textColor = UIColor.lightGray
            textAreaSynthesis.text = "Type what you learn"
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Synthesis"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "blueApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
 
}
extension SynthesisOverViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numLines = (textAreaSynthesis.contentSize.height / (textAreaSynthesis.font?.lineHeight)!)
        let fontSize = textAreaSynthesis.font?.pointSize
        
        print(numLines)
        if numberOfLines < Int(numLines){
            numberOfLines = Int(numLines)
            
            textViewSizeConstraint.constant = textViewSizeConstraint.constant + fontSize!
        }
        
        return true
    }
}
