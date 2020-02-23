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
    
    
    func completionHandler(_ status: Bool)->Void{
        self.navigationController?.popViewController(animated: true)
    }
    
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
        
        if segue.identifier == "cameraSegue" {
            let vc:cameraViewController = segue.destination as! cameraViewController
            vc.callBack = completionHandler(_:)
        }
    }
    
//    MARK:- IBAction
    
    @IBAction func cameraButtonEvent(_ sender: Any) {
        
    }
    
    @IBAction func openCameraButtonEvent(_ sender: Any) {
        
    }
    
    

}
