//
//  SolutionOverViewController.swift
//  CBL
//
//  Created by Ada 2018 on 30/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SolutionOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
//       tabBarItem.image = #imageLiteral(resourceName: "solution")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Solution"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
       
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "greenApp")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }

}
