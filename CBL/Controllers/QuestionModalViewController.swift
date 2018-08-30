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
    
    @IBAction func saveQuestion(_ sender: UIBarButtonItem) {
        let question = questionTextField.text
        let activities = activityTextField.text
        let resources = resourcesTextField.text
        let answer = answerTextView.text
        
        if question == "" { return }
        if activities == "" { return }
        if resources == "" { return }
        if answer == "" { return }
        
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
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving the context. \(error) \(error.userInfo)")
        }
        
        dismiss()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
}
