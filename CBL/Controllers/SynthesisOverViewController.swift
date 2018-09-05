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
    var text: String?
    var isTextAreaSynthesisEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textAreaSynthesis.delegate = self
        
//        self.tabBarItem.image = #imageLiteral(resourceName: "synthesis")
        
        //Set placeholder for textView
        if textAreaSynthesis.text == "" {
            textAreaSynthesis.textColor = UIColor.lightGray
        }
        
        self.textAreaSynthesis.text = text ?? "Type what you learned"
        
        let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(endEditingGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Synthesis"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "blueApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5) {
                if self.isTextAreaSynthesisEditing { self.textAreaSynthesis.resignFirstResponder() }
            }
        }
    }
 
}

extension SynthesisOverViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isTextAreaSynthesisEditing = true
        if textView.textColor == UIColor.lightGray  {
            textView.textColor = UIColor.black
        }
        
        if textView.text == "Type what you learned" {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numLines = (textAreaSynthesis.contentSize.height / (textAreaSynthesis.font?.lineHeight)!)
        let fontSize = textAreaSynthesis.font?.pointSize
        
        if numberOfLines < Int(numLines){
            numberOfLines = Int(numLines)
            
            if let _ = textViewSizeConstraint {
                textViewSizeConstraint.constant = textViewSizeConstraint.constant + fontSize!
            }
        }
        
        return true

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isTextAreaSynthesisEditing = false
        textView.textColor = UIColor.lightGray
        if textView.text == "" {
            textView.text = "Type what you learned"
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        let cblOverViewVC = tabBarController?.viewControllers![0] as? CBLOverViewController
        cblOverViewVC?.cbl?.investigate?.researchSynthesis = self.text
        CoreDataManager.shared.saveContext()
    }

}
