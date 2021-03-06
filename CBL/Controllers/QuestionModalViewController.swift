//
//  QuestionModalViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class QuestionModalViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var resourcesTextField: UITextField!
    @IBOutlet weak var answerTextView: UITextView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewSizeConstraint: NSLayoutConstraint!
    
    var questionType = QuestionType.essential
    var delegate: NewQuestionDelegate?
    var editingObject: NSManagedObject?
    
    var numberOfLines = 0
    var isAnswerTextViewEditing = false
    var willAnswerTextViewBecomeFirstResponder = false
    
    enum QuestionType {
        case essential
        case guiding
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextField.delegate = self
        questionTextField.returnKeyType = .done
        
        activityTextField.delegate = self
        activityTextField.returnKeyType = .done
        
        resourcesTextField.delegate = self
        resourcesTextField.returnKeyType = .done
        
        answerTextView.delegate = self
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(hideGesture)
        
        let showGesture = UITapGestureRecognizer(target: self, action: #selector(answerTextViewTouched(_:)))
        self.answerTextView.addGestureRecognizer(showGesture)
        
        if answerTextView.text == "" {
            answerTextView.textColor = UIColor.lightGray
            answerTextView.text = "Type your answer"
        }
        
        // Configura a controller para o caso de ter sido chamada para editar um objeto
        setEditingObject()
    }
    
    func setEditingObject() {
        guard let object = editingObject else { return }
        
        let question: String
        let resources: String
        let answer: String
        
        switch questionType {
        case .essential:
            let essential = object as? EssentialQuestion
            question = (essential?.question)!
            resources = (essential?.resources)!
            answer = (essential?.answer)!
            
        case .guiding:
            let guiding = object as? GuidingQuestion
            question = (guiding?.question)!
            resources = (guiding?.resources)!
            answer = (guiding?.answer)!
            activityTextField.text = (guiding?.activities)!
            
        }
        
        questionTextField.text = question
        resourcesTextField.text = resources
        answerTextView.text = answer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if willAnswerTextViewBecomeFirstResponder {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
            answerTextView.becomeFirstResponder()
            willAnswerTextViewBecomeFirstResponder = false
        }
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func verifyTextFieldsBeforeSaving() throws {
        if questionTextField.text == "" { throw TextFieldError.emptyTextField }
    }
    
    @objc func answerTextViewTouched(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        answerTextView.becomeFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.answerTextView.resignFirstResponder()
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc func dismissKeyboard(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5) {
                if self.questionTextField.isEditing { self.questionTextField.endEditing(true) }
                if self.resourcesTextField.isEditing { self.resourcesTextField.endEditing(true) }
                if self.activityTextField.isEditing { self.activityTextField.endEditing(true) }
                if self.isAnswerTextViewEditing { self.keyboardWillHide() }
            }
        }
    }
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        do {
            
            try verifyTextFieldsBeforeSaving()
            let question = questionTextField.text
            let activities = activityTextField.text
            let resources = resourcesTextField.text
            let answer = answerTextView.text
            
            if editingObject == nil {
                var context: NSManagedObjectContext!
                
                do {
                    context = try CoreDataManager.shared.getContext()
                } catch let error as NSError {
                    print("Error getting the context. \(error) \(error.userInfo)")
                }
                
                
                switch questionType {
                case .essential:
                    let questionEntityDescription = NSEntityDescription.entity(forEntityName: "EssentialQuestion", in: context)
                    let essentialQuestion = EssentialQuestion(entity: questionEntityDescription!, insertInto: context)
                    essentialQuestion.question = question
                    essentialQuestion.resources = resources
                    essentialQuestion.answer = answer
                    delegate?.saveEssentialQuestion!(essentialQuestion)
                    
                case .guiding:
                    let questionEntityDescription = NSEntityDescription.entity(forEntityName: "GuidingQuestion", in: context)
                    let guidingQuestion = GuidingQuestion(entity: questionEntityDescription!, insertInto: context)
                    guidingQuestion.question = question
                    guidingQuestion.activities = activities
                    guidingQuestion.resources = resources
                    guidingQuestion.answer = answer
                    delegate?.saveGuidingQuestion!(guidingQuestion)
                }
                
            } else {
                switch self.questionType {
                case .essential:
                    let essentialQuestion = self.editingObject as! EssentialQuestion
                    essentialQuestion.question = question
                    essentialQuestion.resources = resources
                    essentialQuestion.answer = answer
                    delegate?.saveEssentialQuestion!(essentialQuestion)
                    
                case .guiding:
                    let guidingQuestion = self.editingObject as! GuidingQuestion
                    guidingQuestion.question = question
                    guidingQuestion.activities = activities
                    guidingQuestion.resources = resources
                    guidingQuestion.answer = answer
                    delegate?.saveGuidingQuestion!(guidingQuestion)
                }
            }
            
            self.dismiss(animated: true, completion: nil)
            
        } catch let error {
            let textFieldError = error as? TextFieldError
            let alertErrorMessage = (textFieldError != nil) ? (textFieldError?.localizedDescription)! : error.localizedDescription
            
            let alert = UIAlertController(title: "Unable to save", message: alertErrorMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}

extension QuestionModalViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5) {
            textField.endEditing(true)
        }
        return true
    }
}

extension QuestionModalViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isAnswerTextViewEditing = true
        if textView.textColor == UIColor.lightGray  {
            textView.textColor = UIColor.black
        }
        
        if textView.text == "Type your answer" {
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let numLines = (answerTextView.contentSize.height / (answerTextView.font?.lineHeight)!)
        let fontSize = answerTextView.font?.pointSize
        
        if numberOfLines < Int(numLines){
            numberOfLines = Int(numLines)
            
            if let _ = textViewSizeConstraint {
                textViewSizeConstraint.constant = textViewSizeConstraint.constant + fontSize!
            }
        }
        
        return true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isAnswerTextViewEditing = false
        textView.textColor = UIColor.lightGray
        if textView.text == "" {
            textView.text = "Type your answer"
        }
    }
    
}
