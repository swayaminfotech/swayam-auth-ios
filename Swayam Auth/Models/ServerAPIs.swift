//
//  ServerAPIs.swift
//  Swayam Auth
//
//  Created by Swayam Infotech on 19/09/20.
//  Copyright © 2020 Swayam Infotech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServerAPIs: NSObject {
    
    class func postRequest(apiUrl:String, _ parameter: [String: Any], completion: @escaping (_ response: JSON, _ error: NSError?, _ statusCode: Int)-> ()){
        
        Alamofire.request(apiUrl, method: .post, parameters: parameter,encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            
            if (response.result.error == nil) {
                print(response.result);
                if (response.result.value != nil) {
                    let dataLog = try! JSON(data: response.data!)
                    print(dataLog);
                    completion(dataLog,nil,(response.response?.statusCode)!)
                }else{
                    completion(JSON.null, nil,(response.response?.statusCode)!)
                }
            }else{
                if (response.response != nil){
                    completion(JSON.null,nil,(response.response?.statusCode)!)
                }else{
                    completion(JSON.null,nil,0)
                }
            }
        }
    }
    
    class func getRequest(apiUrl:String, completion: @escaping (_ response: JSON, _ error: NSError?, _ statusCode: Int)-> ()){
        
        Alamofire.request(apiUrl, method: .get).responseJSON { (response) -> Void in
            
            if (response.result.error == nil) {
                print(response.result);
                if response.data?.count == 0 {
                    completion(JSON.null,nil,(response.response?.statusCode)!)
                }else{
                    let dataLog = try! JSON(data: response.data!)
                    completion(dataLog,nil,(response.response?.statusCode)!)
                }
            }else{
                if (response.response != nil){
                    completion(JSON.null,nil,(response.response?.statusCode)!)
                }else{
                    completion(JSON.null,nil,0)
                }
            }
        }
    }
    
    class func postMultipartRequestWithOptionData (apiUrl: String,_ parameter: [String: Any], imageParameterName: String,imageData: Data?, mimeType: String, fileName: String, completion: @escaping (_ response: JSON, _ error: NSError?, _ statusCode: Int)-> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if imageData != nil {
                multipartFormData.append(imageData!, withName: imageParameterName, fileName: fileName, mimeType: mimeType);
            }
            for (key, value) in parameter {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:apiUrl, method:.post){ (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value {
                        
                        print("JSON: \(JSON)")
                    }
                    if (response.result.error == nil) {
                        
                        let dataLog = try! JSON(data: response.data!)
                        print(dataLog);
                        completion(dataLog,nil,(response.response?.statusCode)!)
                        
                    }else{
                        completion(JSON.null,nil,(response.response?.statusCode)!)
                    }
                }
                
            case .failure(let encodingError):
                
                print(encodingError)
            }
        }
    }
}
