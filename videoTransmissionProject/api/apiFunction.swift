//
//  apiFunction.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/22/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import Foundation
extension apiAgent{
    
    static func doCameraName(req:cameraSet){
        self.httpPost(apiName: CAMERA_SET_API_NAME,req: req, res: cameraResponse.self)
    }
    
    static func doCameraDelete(req:cameraDelete){
        self.httpPost(apiName: CAMERA_DELETE_API_NAME,req: req, res: cameraResponse.self)
    }
    
    static func doCameraList(req:cameraList){
        self.httpPost(apiName: CAMERA_LIST_API_NAME,req: req, res: cameraResponseArr.self)
    }
    
}
