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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cbls = CoreDataManager.shared.getObjects(forEntity: "CBL") as? [CBL] ?? [CBL]()
    }
    

}
extension CBLsTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cbls.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cblCell")!
        //cell.textLabel?.text = cbls[indexPath.row].bigIdea!
        return cell
        
    }
    
}
