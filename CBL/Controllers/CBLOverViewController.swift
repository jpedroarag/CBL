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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var equipeTextField: UITextField!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var solutionLabel: UILabel!
    
    var cbl: CBL?
    var delegate: NewCblDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigIdeaTextField.addTarget(self, action: #selector(bigIdeaTextFieldDidChange(_ :)), for: .editingChanged)
        equipeTextField.addTarget(self, action: #selector(teamTextFieldDidChange(_ :)), for: .editingChanged)
        
        setTextFieldsTexts()
        
        let tabBarControllers = self.tabBarController?.viewControllers!
        
        let essentialController = tabBarControllers![1] as? EssentialOverViewController
        let guidingController = tabBarControllers![2] as? GuidingOverViewController
        let synthesisController = tabBarControllers![3] as? SynthesisOverViewController
        // let solutionController = tabBarControllers![4] as? SolutionOverViewController
        
        essentialController?.essentialQuestions = (cbl?.engage?.essentialQuestions)?.allObjects as! [EssentialQuestion]
        guidingController?.guidingQuestions = (cbl?.engage?.essentialQuestions)?.allObjects as! [GuidingQuestion]
        synthesisController?.text = cbl?.investigate?.researchSynthesis
    }
    
    private func setTextFieldsTexts() {
        bigIdeaTextField.text = cbl?.engage?.bigIdea ?? ""
        equipeTextField.text = cbl?.team ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "pt-br")
        
        if let date = cbl?.date {
            dateTextField.text = dateFormatter.string(from: date)
        } else {
            dateTextField.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 0))
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
    
    @objc func bigIdeaTextFieldDidChange(_ sender: UITextField) {
        cbl?.engage?.bigIdea = sender.text ?? ""
        delegate?.saveCbl(cbl!)
    }
    
    @objc func teamTextFieldDidChange(_ sender: UITextField) {
        cbl?.team = sender.text ?? ""
        delegate?.saveCbl(cbl!)
    }
    
}
