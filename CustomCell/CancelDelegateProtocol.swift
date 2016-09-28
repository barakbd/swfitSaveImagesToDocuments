//
//  CancelDelegateProtocol.swift
//  CustomCell
//
//  Created by Barak Ben-David on 9/15/16.
//  Copyright © 2016 Barak Ben-David. All rights reserved.
//

import Foundation
import UIKit

protocol CancelDelegate: class{
    func cancelButtonPressedFrom(controller: UIViewController)
}

