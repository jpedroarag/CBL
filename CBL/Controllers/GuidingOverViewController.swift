//
//  GuidingOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class GuidingOverViewController: UIViewController {

    var guidingQuestions: [GuidingQuestion]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if guidingQuestions == nil {
            guidingQuestions = [GuidingQuestion]()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
//        self.tabBarItem.image = #imageLiteral(resourceName: "guiding")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Guiding Questions"
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addQuestion(_ :)))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "blueApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? UINavigationController
        let target = destination?.topViewController as? QuestionModalViewController
        target?.questionType = .guiding
        target?.delegate = self
        
        if let object = sender as? GuidingQuestion {
            target?.editingObject = object
        }
    }
    
    @objc func addQuestion(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newGuidingQuestion", sender: nil)
    }
    
}
extension GuidingOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guidingQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let questionObject = guidingQuestions[indexPath.row]
        cell?.textLabel?.text = questionObject.question
        
        if questionObject.answer == "" {
            cell?.detailTextLabel?.text = questionObject.activities ?? ""
        } else {
            cell?.detailTextLabel?.text = questionObject.answer ?? ""
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "newGuidingQuestion", sender: guidingQuestions[indexPath.row])
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            CoreDataManager.shared.deleteObject(self.guidingQuestions[indexPath.row])
            self.guidingQuestions.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteAction.backgroundColor = UIColor(named: "redApp")
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "newGuidingQuestion", sender: self.guidingQuestions[indexPath.row])
        }
        editAction.backgroundColor = UIColor(named: "blueApp")
        
        let answerAction = UITableViewRowAction(style: .default, title: "Answer") { (action, indexPath) in
            self.performSegue(withIdentifier: "newGuidingQuestion", sender: self.guidingQuestions[indexPath.row])
        }
        answerAction.backgroundColor = UIColor(named: "greenApp")
        return [deleteAction, editAction, answerAction]
    }
    
}
extension GuidingOverViewController: UITableViewDropDelegate, UITableViewDragDelegate{
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator){
        
    }
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        return []
    }

}

extension GuidingOverViewController : NewQuestionDelegate {
    func saveGuidingQuestion(_ question: GuidingQuestion) {
        if !guidingQuestions.contains(question) {
            let vc = tabBarController?.viewControllers![0] as? CBLOverViewController
            question.investigate = vc?.cbl?.investigate
            self.guidingQuestions.append(question)
        } else {
            let index = guidingQuestions.index(of: question)
            guidingQuestions[index!] = question
        }
        CoreDataManager.shared.saveContext()
        self.tableView.reloadData()
    }
}
