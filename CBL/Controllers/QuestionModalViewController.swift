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
    
    enum QuestionType {
        case essential
        case guiding
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func verifyTextFieldsForSaving() throws {
        if questionTextField.text == "" { throw TextFieldError.emptyTextField }
        if activityTextField.text == ""
            && questionType == .guiding { throw TextFieldError.emptyTextField }
        if resourcesTextField.text == "" { throw TextFieldError.emptyTextField }
        if answerTextView.text == "" { throw TextFieldError.emptyTextField }
    }
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        do {
            
            try verifyTextFieldsForSaving()
            let question = questionTextField.text
            let activities = activityTextField.text
            let resources = resourcesTextField.text
            let answer = answerTextView.text
            
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
                
            case .guiding:
                let questionEntityDescription = NSEntityDescription.entity(forEntityName: "GuidingQuestion", in: context)
                let guidingQuestion = GuidingQuestion(entity: questionEntityDescription!, insertInto: context)
                guidingQuestion.question = question
                guidingQuestion.activities = activities
                guidingQuestion.resources = resources
                guidingQuestion.answer = answer
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
