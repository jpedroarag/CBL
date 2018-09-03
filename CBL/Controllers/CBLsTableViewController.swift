//
//  CBLsTableViewController.swift
//  TemporaryTableView
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class CBLsTableViewController: UIViewController {

    var cbls: [CBL] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cbls = CoreDataManager.shared.getObjects(forEntity: "CBL") as? [CBL] ?? [CBL]()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? UITabBarController
        let tabBarControllers = dest?.viewControllers!
        let target = tabBarControllers![0] as? CBLOverViewController
        target?.delegate = self
        
        if let object = sender as? CBL {
            target?.cbl = object
        }
    }

}
extension CBLsTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cbls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cblCell")!
        cell.textLabel?.text = cbls[indexPath.row].engage?.bigIdea
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "addCbl", sender: self.cbls[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            CoreDataManager.shared.deleteObject(self.cbls[indexPath.row])
            self.cbls.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteAction.backgroundColor = UIColor(named: "redApp")
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "addCbl", sender: self.cbls[indexPath.row])
        }
        editAction.backgroundColor = UIColor(named: "blueApp")
        
        return [deleteAction, editAction]
    }
    
}

extension CBLsTableViewController : NewCblDelegate {
    func saveCbl(_ cbl: CBL) {
        if !cbls.contains(cbl) {
            self.cbls.append(cbl)
        }
        self.tableView.reloadData()
    }
}
