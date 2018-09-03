//
//  EssentialOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Foundation
class EssentialOverViewController: UIViewController {
    
    var essentialQuestions = [EssentialQuestion]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        essentialQuestions = CoreDataManager.shared.getObjects(forEntity: "EssentialQuestion") as? [EssentialQuestion] ?? [EssentialQuestion]()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Essential Questions"
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addQuestion(_ :)))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "redApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? UINavigationController
        let target = destination?.topViewController as? QuestionModalViewController
        target?.questionType = .essential
        target?.delegate = self
        
        if let element = sender as? EssentialQuestion {
            target?.editingObject = element
        }
        
    }
    
    @objc func addQuestion(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newEssentialQuestion", sender: nil)
    }

}
extension EssentialOverViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return essentialQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let questionObject = essentialQuestions[indexPath.row]
        cell?.textLabel?.text = questionObject.question
        
        if questionObject.answer == "" {
            cell?.detailTextLabel?.text = questionObject.resources ?? ""
        } else {
            cell?.detailTextLabel?.text = questionObject.answer ?? ""
        }
        
        return cell!
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            CoreDataManager.shared.deleteObject(self.essentialQuestions[indexPath.row])
            self.essentialQuestions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteAction.backgroundColor = UIColor(named: "redApp")
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "newEssentialQuestion", sender: self.essentialQuestions[indexPath.row])
        }
        editAction.backgroundColor = UIColor(named: "blueApp")
        
        let answerAction = UITableViewRowAction(style: .default, title: "Answer") { (action, indexPath) in
            print("Celula respondida")
        }
        answerAction.backgroundColor = UIColor(named: "greenApp")
        return [deleteAction, editAction, answerAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newEssentialQuestion", sender: essentialQuestions[indexPath.row])
    }
}

extension EssentialOverViewController : NewQuestionDelegate {
    func saveEssentialQuestion(_ question: EssentialQuestion) {
        if !essentialQuestions.contains(question) {
            self.essentialQuestions.append(question)
        }
        self.tableView.reloadData()
    }
}
