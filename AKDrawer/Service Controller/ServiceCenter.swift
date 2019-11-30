//
//  ServiceCall.swift
//  AKDrawer
//
//  Created by macmini3 on 14/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import Foundation
import UIKit

let ServiceCenter = Services()

//class ServiceCenter {
class Services {
    
    enum imageTypes {
        case jpeg
        case png
    }
    
    enum responseTypes {
        case json
        case none
    }
    
    struct jsonObject {
        var ResponseCode: String?
        var ResponseStatus: String?
        var ResponseData: Any?
        
        init(with dictionary: [String: AnyObject]) {
            ResponseCode = dictionary["ResponseCode"] as? String
            ResponseStatus = dictionary["ResponseStatus"] as? String
            ResponseData = dictionary["ResponseData"] as Any?
        }
    }
    
    /// Network call with AsyncTask using GET method which returns HTTP Response, JSON Response and Error
    func serviceCallGetWithAsync(urlString: String, responseType: responseTypes, completionHandler: ((HTTPURLResponse?, Any?, Error?)->())?) {
        
        let tempUrl = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: tempUrl!) { (data, response, error) in
            
            guard error == nil else {
                completionHandler?(nil, nil, error)
                return
            }
            
            guard data != nil else {
                completionHandler?(nil, nil, NSError(domain: "Data is nil", code: 101, userInfo: Dictionary<String,Any>()))
                return
            }
            
            if let data = data {
                do {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if responseType == .json {
                            let json = jsonObject(with: try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>)
                            completionHandler?(httpResponse,json,nil)
                        }
                        else {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                            completionHandler?(httpResponse,json,nil)
                        }
                    } else {
                        completionHandler?(response as? HTTPURLResponse, nil, nil)
                    }
                }
                catch {
                    completionHandler?(nil, nil, error)
                }
            }
        }
        task.resume()
    }
    
    /// Network call with SynchronizeTask using GET method which returns JSON Response and Error
    func serviceCallGetWithSync(urlString: String, responseType: responseTypes, completionHandler: ((Any?, Error?)->())?) {
        
        let tempUrl = URL(string: urlString)
        
        var tempData = Data()
        
        do {
            if let url = tempUrl {
                tempData = try Data(contentsOf: url)
            } else {
                completionHandler?(nil, NSError(domain: "URL Problem", code: 101, userInfo: Dictionary<String,Any>()))
            }
        }
        catch {
            completionHandler?(nil, error)
        }
        
        do {
            if responseType == .json {
                let json = jsonObject(with: try JSONSerialization.jsonObject(with: tempData, options: []) as! Dictionary<String,AnyObject>)
                completionHandler?(json, NSError(domain: "Parsing Error", code: 101, userInfo: Dictionary<String,Any>()))
            }
            else {
                let json = try JSONSerialization.jsonObject(with: tempData, options: []) as! Dictionary<String,AnyObject>
                completionHandler?(json, nil)
            }
        }
        catch {
            completionHandler?(nil, error)
        }
        
    }
    
    /// Network Call Function With AsyncTask POST method with Header Key and Value which returns HTTP Response, JSON Response and Error
    func serviceCallPost(urlString: String, headerKey: String, headerValue: String, responseType: responseTypes, completionHandler: ((HTTPURLResponse?, Any?, Error?)->())?) {
        
        let tempURL = URL(string: urlString)
        var request = URLRequest(url: tempURL!)
        request.httpMethod = "POST"
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.addValue(headerValue, forHTTPHeaderField: headerKey)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                completionHandler?(nil, nil, error)
                return
            }
            guard data != nil else {
                completionHandler?(nil, nil, NSError(domain: "Data is nil", code: 101, userInfo: Dictionary<String,Any>()))
                return
            }
            
            if let data = data {
                
                do {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if responseType == .json {
                            let json = jsonObject(with: try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>)
                            completionHandler?(httpResponse,json,nil)
                        }
                        else {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                            completionHandler?(httpResponse,json,nil)
                        }
                    } else {
                        completionHandler?(response as? HTTPURLResponse, nil, nil)
                    }
                }
                catch {
                    completionHandler?(nil, nil, error)
                }
            }
        }
        task.resume()
    }
    
    /// Image Uploading Service which returns HTTP Response and Error
    func serviceCallImageUpload(url: String, image : UIImage, imageType: imageTypes, completionHandler: ((HTTPURLResponse?,Error?)->())?) {
        
        var request = URLRequest(url: URL(string: url)!)
        let dateFormatter = DateFormatter()
        let boundary = "---------------------------14737809831466499882746641449"
        var imageName = String()
        var imageData = Data()
        var body = Data()
        let date = Date()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        switch imageType {
        case .jpeg:
            imageData = image.jpegData(compressionQuality: 1.0) ?? Data()
            imageName = "Gatisofttech_\(dateFormatter.string(from: date)).jpg"
        case .png:
            imageData = image.pngData() ?? Data()
            imageName = "Gatisofttech_\(dateFormatter.string(from: date)).png"
        }
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"filenames\"\r\n\r\n".data(using: .utf8)!)
        body.append("filenames\r\n".data(using: .utf8)!)
        let mimetype = "multipart/form-data; boundary=\(boundary)"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"UserFile\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completionHandler?(nil, error)
                return }
            
            if data != nil {
                do {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        completionHandler?(httpResponse, nil)
                    }
                    else {
                        completionHandler?(response as? HTTPURLResponse, NSError(domain: "Data is nil", code: 101, userInfo: Dictionary<String,Any>()))
                    }
                }
            } else {
               completionHandler?(nil, NSError(domain: "Data is nil", code: 101, userInfo: Dictionary<String,Any>()))
            }
        }
        task.resume()
    }
    
}


