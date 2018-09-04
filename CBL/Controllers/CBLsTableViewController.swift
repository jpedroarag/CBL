//
//  CBLsTableViewController.swift
//  TemporaryTableView
//
//  Created by Ada 2018 on 29/08/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit
import CoreData

class CBLsTableViewController: UIViewController {

    var cbls: [CBL] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cbls = CoreDataManager.shared.getObjects(forEntity: "CBL") as? [CBL] ?? [CBL]()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "CBL"
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.newCbl(_ :)))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "greenApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? UITabBarController
        let tabBarControllers = dest?.viewControllers!
        let target = tabBarControllers![0] as? CBLOverViewController
        target?.delegate = self
        
        do {
            let cbl: CBL
            if let cblObj = sender as? CBL {
                cbl = cblObj
            } else {
                let context = try CoreDataManager.shared.getContext()
                let cblEntity = NSEntityDescription.entity(forEntityName: "CBL", in: context)
                let engageEntity = NSEntityDescription.entity(forEntityName: "Engage", in: context)
                let investigateEntity = NSEntityDescription.entity(forEntityName: "Investigate", in: context)
                
                cbl = CBL(entity: cblEntity!, insertInto: context)
                cbl.engage = Engage(entity: engageEntity!, insertInto: context)
                cbl.investigate = Investigate(entity: investigateEntity!, insertInto: context)
            }
            
            target?.cbl = cbl
            
        } catch let error {
            NSLog("There was an error. Error description: '\(error.localizedDescription)'")
        }
    }
    
    @objc func newCbl(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addCbl", sender: nil)
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
