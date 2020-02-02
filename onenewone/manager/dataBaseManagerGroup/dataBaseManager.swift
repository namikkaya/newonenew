//
//  dataBaseManager.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
class dataBaseManager: NSObject {
    let TAG:String = "dataBaseManager: "
    
    private var userDBManager:userDB?

    static let sharedInstance: dataBaseManager = {
        let instance = dataBaseManager()
        return instance
    }()

    override init() {
        super.init()
        userDBManager = userDB()
    }
    
    
}
