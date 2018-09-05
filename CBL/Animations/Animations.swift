//
//  Animations.swift
//  CBL
//
//  Created by Ada 2018 on 05/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation
import UIKit


struct Animations{
    static func fadeIn(withDuration duration: TimeInterval, forView view: UIView, completion: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    static func fadeOut(withDuration duration: TimeInterval, forView view: UIView){
        UIView.animate(withDuration: 1, animations: {
            view.alpha = 0.0
        }) { (true) in
            view.removeFromSuperview()
            
        }
        
    }

    
}

