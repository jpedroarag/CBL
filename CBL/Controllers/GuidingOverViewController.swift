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
    
    
}
extension GuidingOverViewController: UITableViewDropDelegate, UITableViewDragDelegate{
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator){
        
    }
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        return []
    }

}
