//
//  mainViewController.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class mainViewController: BaseViewController {
    private var dbMan:dataBaseManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        UIConfig()
        DBConfig()
    }
    
//    MARK:- Class Configuration
    private func UIConfig() {
        
    }
    
    private func DBConfig() {
        dbMan = dataBaseManager.sharedInstance
    }
    

}
