//
//  ViewControllerDelegate.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/27/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import Foundation

@objc protocol ViewControllerDelegate{
   func presentCameraList(id: String , name: String , vcString: String )
}
