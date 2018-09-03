//
//  NewQuestionDelegate.swift
//  CBL
//
//  Created by Ada 2018 on 31/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

@objc protocol NewQuestionDelegate {
    @objc optional func addEssentialQuestion(_ question: EssentialQuestion)
    @objc optional func addGuidingQuestion(_ question: GuidingQuestion)
}
