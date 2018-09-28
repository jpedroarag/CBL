//
//  TransitioningIndicesProtocol.swift
//  CBL
//
//  Created by Ada 2018 on 28/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//
import UIKit
protocol TransitioningIndices {
    func tabBarControllerTransitioningGetIndices(from: UIViewController, to: UIViewController) -> (from: Int, to: Int)
}
