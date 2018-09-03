//
//  SynthesisOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SynthesisOverViewController: UIViewController {

    @IBOutlet weak var textAreaSynthesis: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textAreaSynthesis.layer.borderWidth = 3
        textAreaSynthesis.layer.borderColor = UIColor.gray.cgColor
        textAreaSynthesis.layer.cornerRadius = 14
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Synthesis"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
 
}
