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
    var delegate: NewCblDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarItem.image = #imageLiteral(resourceName: "chalenge")
        
        do {
            let context = try CoreDataManager.shared.getContext()
            let cblEntity = NSEntityDescription.entity(forEntityName: "CBL", in: context)
            let engageEntity = NSEntityDescription.entity(forEntityName: "Engage", in: context)
            let investigateEntity = NSEntityDescription.entity(forEntityName: "Investigate", in: context)
            
            cbl = CBL(entity: cblEntity!, insertInto: context)
            cbl?.engage = Engage(entity: engageEntity!, insertInto: context)
            cbl?.investigate = Investigate(entity: investigateEntity!, insertInto: context)
            
            let tabBarControllers = self.tabBarController?.viewControllers!
            
            let essentialController = tabBarControllers![1] as? EssentialOverViewController
            let guidingController = tabBarControllers![2] as? GuidingOverViewController
//            let synthesisController = tabBarControllers![3] as? SynthesisOverViewController
//            let solutionController = tabBarControllers![4] as? SolutionOverViewController
            
            essentialController?.essentialQuestions = (cbl?.engage?.essentialQuestions)?.allObjects as! [EssentialQuestion]
            guidingController?.guidingQuestions = (cbl?.engage?.essentialQuestions)?.allObjects as! [GuidingQuestion]
//            synthesisController?.textAreaSynthesis.text = cbl?.investigate?.researchSynthesis
            
            CoreDataManager.shared.saveContext(context)
            
        } catch let error {
            NSLog("There was an error. Error description: '\(error.localizedDescription)'")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Overview"

        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "redApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }

}
