//
//  NewCBLTabBarController.swift
//  CBL
//
//  Created by Ada 2018 on 04/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class NewCBLTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let essentialViewControler = EssentialOverViewController()
//        essentialViewControler.tabBarItem.image = #imageLiteral(resourceName: "chalenge")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
        items[0].image = #imageLiteral(resourceName: "chalenge")
        items[1].image = #imageLiteral(resourceName: "chalenge")
        items[2].image = #imageLiteral(resourceName: "chalenge")
        items[3].image = #imageLiteral(resourceName: "chalenge")
        items[4].image = #imageLiteral(resourceName: "chalenge")
    }
    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        items[0].image = #imageLiteral(resourceName: "chalenge")
        items[1].image = #imageLiteral(resourceName: "chalenge")
        items[2].image = #imageLiteral(resourceName: "chalenge")
        items[3].image = #imageLiteral(resourceName: "chalenge")
        items[4].image = #imageLiteral(resourceName: "chalenge")
    }
    override func setToolbarItems(_ toolbarItems: [UIBarButtonItem]?, animated: Bool) {
        toolbarItems![1].image = #imageLiteral(resourceName: "essentialFilled")
        
    }

}
