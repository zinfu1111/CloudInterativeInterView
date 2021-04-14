//
//  DataManager.swift
//  CloudInterativeInterView
//
//  Created by 連振甫 on 2021/4/14.
//

import Foundation

struct ServicesURL {
    
    static var baseurl: String {
        return "https://jsonplaceholder.typicode.com"
    }
}

public protocol ServicesURLProtocol {
    var url: String { get }
}

public protocol APIServicesURLProtocol: ServicesURLProtocol {
    var rootURL: String { get }
}

enum APIURL: APIServicesURLProtocol {
    
    public var rootURL: String {
        return  "/"
    }
    
    case photos
    
    public var url: String {
        return getURL()
    }
    
    private func getURL() -> String {
        var resource = ""
        
        switch self {
        case .photos:
            resource = "photos"
        }
        
        return "\(ServicesURL.baseurl)\(rootURL)\(resource)"
    }
}



class DataManager {
    
    static let shared = DataManager()
    
    func queryData(completionHandler: @escaping ( [Photo])-> Void) {
        
        if let url = URL(string: APIURL.photos.url) {
            
            RestManager.shared.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
                guard let response = results.response,response.httpStatusCode == 200,let data = results.data else { return }
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: data)
                    completionHandler(photos)
               } catch  {
                   print(error)
               }
            }
            
        }
        
    }
    
}
