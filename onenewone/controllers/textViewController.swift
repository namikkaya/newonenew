//
//  textViewController.swift
//  onenewone
//
//  Created by namik kaya on 22.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class textViewController: UIViewController {

    
    @IBOutlet weak var listText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var setText:String? {
        didSet {
            if let text = setText {
                listText.text += text
            }
        }
    }

}
