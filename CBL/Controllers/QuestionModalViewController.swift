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
    
    var questionType = QuestionType.essential
    var delegate: NewQuestionDelegate?
    var editingObject: NSManagedObject?
    
    enum QuestionType {
        case essential
        case guiding
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let hideGesture = UISwipeGestureRecognizer(target: self, action: #selector(keyboardWillHide(notification:)))
        hideGesture.direction = .down
        self.view.addGestureRecognizer(hideGesture)
        
        let showGesture = UITapGestureRecognizer(target: self, action: #selector(answerTextViewTouched(_ :)))
        self.answerTextView.addGestureRecognizer(showGesture)
        
        setEditingObject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

    func dismiss() {
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
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.answerTextView.endEditing(true)
        }, completion: nil)
        NotificationCenter.default.removeObserver(self)

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
                    
                case .guiding:
                    let guidingQuestion = self.editingObject as! GuidingQuestion
                    guidingQuestion.question = question
                    guidingQuestion.activities = activities
                    guidingQuestion.resources = resources
                    guidingQuestion.answer = answer
                }
            }
            
            CoreDataManager.shared.saveContext()
            dismiss()
            
        } catch let error {
            let textFieldError = error as? TextFieldError
            let alertErrorMessage = (textFieldError != nil) ? (textFieldError?.localizedDescription)! : error.localizedDescription
            
            let alert = UIAlertController(title: "Error", message: alertErrorMessage, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
}
