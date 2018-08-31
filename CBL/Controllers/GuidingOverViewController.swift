//
//  GuidingOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class GuidingOverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? UINavigationController
        let target = destination?.topViewController as? QuestionModalViewController
        target?.questionType = .guiding
    }
    
    @objc func addQuestion(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newGuidingQuestion", sender: nil)
    }
    
}
extension GuidingOverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Por que estudamos?"
        cell?.detailTextLabel?.text = "Para um pedreiro ganhar mais que a gente"
        return cell!
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            print("Celula deletada")
        }
        deleteAction.backgroundColor = UIColor(named: "redApp")
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            print("Celula editada")
        }
        editAction.backgroundColor = UIColor(named: "blueApp")
        
        let answerAction = UITableViewRowAction(style: .default, title: "Answer") { (action, indexPath) in
            print("Celula respondida")
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
