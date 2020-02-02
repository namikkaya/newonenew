//
//  mainViewController.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//
//  version: 1

import UIKit

class mainViewController: BaseViewController {
    private var dbMan:dataBaseManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        UIConfig()
        DBConfig()
        navigationConfig()
    }
    
//    MARK:- Class Configuration
    private func UIConfig() {
        
    }
    
    private func DBConfig() {
        dbMan = dataBaseManager.sharedInstance
    }
    
    private func navigationConfig() {
        self.setNavigationBarTitle(titleText: "Hoşgeldiniz")
        //self.setNavigationColor(color: UIColor.blue)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    

}
