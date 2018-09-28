//
//  CBLOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData
//import TransitionKit

class CBLOverViewController: UIViewController {

    @IBOutlet weak var bigIdeaTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var equipeTextField: UITextField!
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var challengeTextView: UITextView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewSizeConstraint: NSLayoutConstraint!
    
    var cbl: CBL?
    var delegate: NewCblDelegate?
    var numberOfLines = 0
    var isChallengeTextViewEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self

        bigIdeaTextField.delegate = self
        bigIdeaTextField.returnKeyType = .done
        
        dateTextField.delegate = self
        dateTextField.returnKeyType = .done
        
        equipeTextField.delegate = self
        equipeTextField.returnKeyType = .done
        
        challengeTextView.delegate = self
        
        view.isUserInteractionEnabled = true
        
        let changeControllerSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(changeController(_:)))
        changeControllerSwipeLeftGesture.direction = .left
        self.view.addGestureRecognizer(changeControllerSwipeLeftGesture)
        
        let hideKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(hideKeyboardTapGesture)
        
        let showGesture = UITapGestureRecognizer(target: self, action: #selector(challengeTextViewTouched(_:)))
        self.challengeTextView.addGestureRecognizer(showGesture)
        
        bigIdeaTextField.addTarget(self, action: #selector(bigIdeaTextFieldDidChange(_ :)), for: .editingChanged)
        equipeTextField.addTarget(self, action: #selector(teamTextFieldDidChange(_ :)), for: .editingChanged)
        
        setTextFieldsTexts()
        
        let tabBarControllers = self.tabBarController?.viewControllers!
        
        let essentialController = tabBarControllers![1] as? EssentialOverViewController
        let guidingController = tabBarControllers![2] as? GuidingOverViewController
        let synthesisController = tabBarControllers![3] as? SynthesisOverViewController
        let solutionController = tabBarControllers![4] as? SolutionOverViewController
        
        essentialController?.essentialQuestions = (cbl?.engage?.essentialQuestions)?.allObjects as! [EssentialQuestion]
        guidingController?.guidingQuestions = (cbl?.investigate?.guidingQuestions)?.allObjects as! [GuidingQuestion]
        synthesisController?.text = cbl?.investigate?.researchSynthesis
        solutionController?.text = cbl?.investigate?.solutionConcept
    }
    
    private func setTextFieldsTexts() {
        bigIdeaTextField.text = cbl?.engage?.bigIdea ?? ""
        equipeTextField.text = cbl?.team ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "pt-br")
        
        if let date = cbl?.date {
            dateTextField.text = dateFormatter.string(from: date)
        } else {
            dateTextField.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 0))
        }
        
        //Set placeholder for challengeTextView
        if challengeTextView.text == "" {
            challengeTextView.textColor = UIColor.lightGray
        }
        
        challengeTextView.text = cbl?.engage?.challenge ?? "Type your challenge"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Overview"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "redApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    @objc func changeController(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            tabBarController?.selectedIndex += 1
        }
    }
    
    @objc func bigIdeaTextFieldDidChange(_ sender: UITextField) {
        cbl?.engage?.bigIdea = sender.text ?? ""
        delegate?.saveCbl(cbl!)
    }
    
    @objc func dateTextFieldDidChange(_ sender: UITextField) {
        if let dateString = sender.text {
            let dateFormatter = DateFormatter()
            cbl?.date = dateFormatter.date(from: dateString)
        }
        delegate?.saveCbl(cbl!)
    }
    
    @objc func teamTextFieldDidChange(_ sender: UITextField) {
        cbl?.team = sender.text ?? ""
        delegate?.saveCbl(cbl!)
    }
    
   
    @IBAction func cancelViewDatePicker(_ sender: Any) {
        
        Animations.fadeOut(withDuration: 1, forView: viewDatePicker)
        
        
        
    }
    
    @IBAction func confirmViewDatePicker(_ sender: Any) {
        //Seting date formmater
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        dateTextField.text = formatter.string(from: datePicker.date)
        Animations.fadeOut(withDuration: 1, forView: viewDatePicker)
    }
    
    @objc func challengeTextViewTouched(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        challengeTextView.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.challengeTextView.resignFirstResponder()
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5) {
                if self.bigIdeaTextField.isEditing { self.bigIdeaTextField.endEditing(true) }
                if self.dateTextField.isEditing { self.dateTextField.endEditing(true) }
                if self.equipeTextField.isEditing { self.equipeTextField.endEditing(true) }
                if self.isChallengeTextViewEditing { self.keyboardWillHide() }
            }
        }
    }
    
}

extension CBLOverViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField{
            viewDatePicker.frame.origin.x = (self.view.frame.size.width / 2) - (viewDatePicker.frame.size.width / 2)
            viewDatePicker.frame.origin.y = (self.view.frame.size.height / 2) - (viewDatePicker.frame.size.height / 2)
            viewDatePicker.layer.shadowOpacity = 0.7
            viewDatePicker.layer.shadowOffset = CGSize(width: 3, height: 3)
            viewDatePicker.layer.shadowRadius = 15
            viewDatePicker.layer.shadowColor = UIColor.darkGray.cgColor
            
            viewDatePicker.layer.cornerRadius = viewDatePicker.frame.size.height / 10
            viewDatePicker.alpha = 0
            view.addSubview(viewDatePicker)
            
            Animations.fadeIn(withDuration: 1, forView: viewDatePicker, completion: nil)
            textField.resignFirstResponder()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5) {
            textField.endEditing(true)
        }
        return true
    }
    
    
}

extension CBLOverViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isChallengeTextViewEditing = true
        textView.textColor = UIColor.black
        
        if textView.text == "Type your challenge" {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numLines = (challengeTextView.contentSize.height / (challengeTextView.font?.lineHeight)!)
        let fontSize = challengeTextView.font?.pointSize
        
        if numberOfLines < Int(numLines){
            numberOfLines = Int(numLines)
            
            if let _ = textViewSizeConstraint {
                textViewSizeConstraint.constant = textViewSizeConstraint.constant + fontSize!
            }
        }
        
        return true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isChallengeTextViewEditing = false
        textView.textColor = UIColor.lightGray
        if textView.text == "" {
            textView.text = "Type your challenge"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "Type your challenge" {
            cbl?.engage?.challenge = textView.text
            CoreDataManager.shared.saveContext()
        }
    }
    
}
