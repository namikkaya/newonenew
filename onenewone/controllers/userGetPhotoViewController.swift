//
//  userGetPhotoViewController.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class userGetPhotoViewController: BaseViewController {
    private var dbMan:dataBaseManager?
    @IBOutlet weak var cameraButtonObject: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBConfig()
    }
    
//    MARK:- Class Configuration
    private func UIConfig() {
        
    }
    
    private func DBConfig() {
        dbMan = dataBaseManager.sharedInstance
    }
    
    private func navigationConfig() {
        self.setNavigationBarTitle(titleText: "Profil Fotoğrafı")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
//    MARK:- IBAction
    
    @IBAction func cameraButtonEvent(_ sender: Any) {
        
    }
    
    @IBAction func openCameraButtonEvent(_ sender: Any) {
        
    }
    
    

}
