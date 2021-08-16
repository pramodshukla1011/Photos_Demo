//
//  NetworkManager.swift
//  Photos_Demo
//
//  Created by Pramod Shukla on 16/08/21.
//

import Foundation


enum HttpMethod:String{
    case get = "get"
    case post = "post"
}

let BaseURL : String = "https://parallelteam.website/mytruth/"

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func dataTask(serviceURL:String,httpMethod:HttpMethod,parameters:[String:String]?,completion:@escaping (AnyObject?, Error?) -> Void) -> Void {
        requestResource(serviceURL: serviceURL, httpMethod: httpMethod, parameters: parameters ?? [:], completion: completion)
    }
    
    private func requestResource(serviceURL:String,httpMethod:HttpMethod,parameters:[String:String],completion:@escaping (AnyObject?, Error?) -> Void) -> Void {
        
        var request = URLRequest(url: URL(string:"\(BaseURL)\(serviceURL)")!)
       
        if var urlComponents = URLComponents(url: URL(string:"\(BaseURL)\(serviceURL)")!,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                if let arr = value as? [Any] {
                    for value in arr {
                        let queryItem = URLQueryItem(name: key,
                                                     value: "\(value)")
                        urlComponents.queryItems?.append(queryItem)
                    }
                } else {
                    let queryItem = URLQueryItem(name: key,
                                                 value: "\(value)")
                    urlComponents.queryItems?.append(queryItem)
                }
            }
            
            request.httpMethod = httpMethod.rawValue
            request.httpBody = urlComponents.query?.data(using : .utf8)
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
      

        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
           
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Photo.self, from: data)
                completion (data as AnyObject, nil)
            } catch let err {
                completion (nil, err)
                print("Err", err)
            }
    
        }.resume()
    }
}
