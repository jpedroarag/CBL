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
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textAreaSynthesis.delegate = self
        
        textAreaSynthesis.layer.borderWidth = 3
        textAreaSynthesis.layer.borderColor = UIColor.gray.cgColor
        textAreaSynthesis.layer.cornerRadius = 14
        
        if let text = text {
            self.textAreaSynthesis.text = text
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Synthesis"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "blueApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
 
}

extension SynthesisOverViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        let cblOverViewVC = tabBarController?.viewControllers![0] as? CBLOverViewController
        cblOverViewVC?.cbl?.investigate?.researchSynthesis = self.text
        CoreDataManager.shared.saveContext()
    }
}
