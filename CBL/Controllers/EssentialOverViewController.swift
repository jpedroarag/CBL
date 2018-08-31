//
//  EssentialOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? UINavigationController
        let target = destination?.topViewController as? QuestionModalViewController
        target?.questionType = .essential
        target?.delegate = self
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
}

extension EssentialOverViewController : NewQuestionDelegate {
    func addEssentialQuestion(_ question: EssentialQuestion) {
        self.essentialQuestions.append(question)
        self.tableView.reloadData()
    }
}
