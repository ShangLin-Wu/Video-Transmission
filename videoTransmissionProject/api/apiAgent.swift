//
//  apiAgent.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/22/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import Foundation

let apiURL = "https://asia-east2-networkcamera-b5adf.cloudfunctions.net/NetworkCamera"

class apiAgent{
    
    static func httpPost<S,T>(apiName:String,req:S , res:T.Type) where S : Encodable,T : Decodable{
        let reqJSON = try? req.self.toString()
        print("Request JSON : \(reqJSON ?? "Request NULL") ")
        
        let address = "\(apiURL)/\(apiName)";
        var request = URLRequest(url: URL(string: address)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
//            let req = try? req.self.toData()
            let req = try? JSONEncoder().encode(req)
            request.httpBody = req
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                let resJSON = String(data: data!, encoding: .utf8)
                print("Response JSON : \(resJSON ?? "Response NULL") ")
                
                if ( data == nil || error != nil){
                    print("http error",error.debugDescription)
                    return
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                print("\(res): \n", responseString!)
                
                do{
                    let resData = try JSONDecoder().decode(res, from: data!)
                    let dic = [apiName:resData]
                    NotificationCenter.default.post(name: NSNotification.Name("APINotification"), object: dic)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("decode error :",error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}

extension Encodable{
    func toString(encoder: JSONEncoder = JSONEncoder()) throws -> String?{
        return try String(data: encoder.encode(self), encoding: .utf8)!
    }
    func toData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
