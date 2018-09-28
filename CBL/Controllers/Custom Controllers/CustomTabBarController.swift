//
//  CustomTabBarController.swift
//  CBL
//
//  Created by Ada 2018 on 28/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import TransitionKit

class CustomTabBarController: UITabBarController {

    var transition = Transition(typeTransition: .slide, transitionTime: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    

}

extension CustomTabBarController: TransitioningIndices {
    func tabBarControllerTransitioningGetIndices(from: UIViewController, to: UIViewController) -> (from: Int, to: Int) {
        func getIndex(from vc: UIViewController) -> Int {
            switch vc {
            case vc as CBLOverViewController:
                return 0
            case vc as EssentialOverViewController:
                return 1
            case vc as GuidingOverViewController:
                return 2
            case vc as SynthesisOverViewController:
                return 3
            case vc as SolutionOverViewController:
                return 4
            default:
                return -1
            }
        }
        
        return (getIndex(from: from), getIndex(from: to))
    }
    
}

extension CustomTabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var runTransition : UIViewControllerAnimatedTransitioning
        let indices = self.tabBarControllerTransitioningGetIndices(from: fromVC, to: toVC)

        if indices.from > -1 && indices.to > -1 {
            if indices.to > indices.from {
                runTransition = self.transition.runTransition(side: .right)
            } else {
                runTransition = self.transition.runTransition(side: .left)
            }
        } else {
            return nil
        }
        
        return runTransition
        
    }
    
}
