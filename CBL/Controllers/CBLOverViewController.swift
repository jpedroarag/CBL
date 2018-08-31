//
//  CBLOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import CoreData

class CBLOverViewController: UIViewController {

    @IBOutlet weak var bigIdeaTextField: UITextField!
    @IBOutlet weak var equipeTextField: UITextField!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var solutionLabel: UILabel!
    
    var cbl: CBL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let context = try CoreDataManager.shared.getContext()
            let cblEntity = NSEntityDescription.entity(forEntityName: "CBL", in: context)
            let engageEntity = NSEntityDescription.entity(forEntityName: "Engage", in: context)
            let investigateEntity = NSEntityDescription.entity(forEntityName: "Investigate", in: context)
            
            cbl = CBL(entity: cblEntity!, insertInto: context)
            cbl?.engage = Engage(entity: engageEntity!, insertInto: context)
            cbl?.investigate = Investigate(entity: investigateEntity!, insertInto: context)
            
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Overview"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

}
