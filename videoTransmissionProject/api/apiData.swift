//
//  apiData.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/22/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import Foundation

struct cameraSet: Codable {
    var name: String
    
    var reqName: String?
}

struct cameraDelete: Codable {
    var id: String
    
    var reqName: String?
}

struct cameraList: Codable {
    var reqName: String?
}

struct cameraResponseArr: Codable {
    var status: Int?
    var errMsg: String?
    var result: [String:[list]]
    
    var resName: String?
}

/**
 {
     "status": 0,
     "errMsg": "",
     "result": {
         "list": [
             {
                 "id": "1587556091828",
                 "name": "qewrreqw"
             },
             {
                 "id": "1587559090610",
                 "name": "品牌"
             }
         ]
     }
 }
 */

struct cameraResponse: Codable {
    var status: Int?
    var errMsg: String?
    var result: list?
    
    var resName: String?
}

struct list: Codable {
    var id: String?
    var name: String?
}
