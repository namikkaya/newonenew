//
//  userBaseNavigationController.swift
//  onenewone
//
//  Created by namik kaya on 9.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class userBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    

}
