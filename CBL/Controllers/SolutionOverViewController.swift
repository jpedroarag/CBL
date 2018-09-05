//
//  SolutionOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SolutionOverViewController: UIViewController {
    
    @IBOutlet weak var solutionTextView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewSizeConstraint: NSLayoutConstraint!
    
    var numberOfLines: Int = 0
    var text: String?
    var isSolutionTextViewEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        solutionTextView.delegate = self
        
//       tabBarItem.image = #imageLiteral(resourceName: "solution")
        //Set placeholder for textView
        if solutionTextView.text == "" {
            solutionTextView.textColor = UIColor.lightGray
        }
        
        self.solutionTextView.text = text ?? "Type your solution"
        
        let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(endEditingGesture)
        
        let changeControllerSwipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeController(_:)))
        changeControllerSwipeRightGesture.direction = .right
        self.view.addGestureRecognizer(changeControllerSwipeRightGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Solution"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "greenApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    @objc func changeController(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            tabBarController?.selectedIndex -= 1
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5) {
                if self.isSolutionTextViewEditing { self.solutionTextView.resignFirstResponder() }
            }
        }
    }
    
}

extension SolutionOverViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isSolutionTextViewEditing = true
        if textView.textColor == UIColor.lightGray  {
            textView.textColor = UIColor.black
        }
        
        if textView.text == "Type your solution" {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numLines = (solutionTextView.contentSize.height / (solutionTextView.font?.lineHeight)!)
        let fontSize = solutionTextView.font?.pointSize
        
        if numberOfLines < Int(numLines){
            numberOfLines = Int(numLines)
            
            if let _ = textViewSizeConstraint {
                textViewSizeConstraint.constant = textViewSizeConstraint.constant + fontSize!
            }
        }
        
        return true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isSolutionTextViewEditing = false
        textView.textColor = UIColor.lightGray
        if textView.text == "" {
            textView.text = "Type your solution"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        let cblOverViewVC = tabBarController?.viewControllers![0] as? CBLOverViewController
        cblOverViewVC?.cbl?.investigate?.solutionConcept = self.text
        CoreDataManager.shared.saveContext()
    }
    
}
