//
//  Config.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import Foundation

class Config {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            fatalError("Not file 'Config.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("NOT API_KEY in Config.plist.")
        }
        
        return value
    }
}
