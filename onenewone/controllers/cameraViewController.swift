//
//  cameraViewController.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class cameraViewController: UIViewController {

    private let TAG:String = "CameraViewController: "
    
    //cameraPreviewView
    @IBOutlet var cameraPreviewView: UIView!
    
    private var camManager:cameraManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.rotated),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        if (camManager == nil) {
            camManager = cameraManager(root: self.view, preview: cameraPreviewView)
            let orientation = UIDevice.current.orientation.isLandscape
            print("\(TAG) orientation: \(orientation)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
        if (camManager != nil) {
            camManager = nil
        }
    }
    
    @objc func rotated() {
        guard let camMan = camManager else { return }
        camMan.orientationStatus(status: UIDevice.current.orientation)
        /*switch UIDevice.current.orientation {
        case .landscapeLeft:
            break
        case .landscapeRight:
            break
        case .unknown:
            break
        case .portrait:
            break
        case .portraitUpsideDown:
            break
        case .faceUp:
            break
        case .faceDown:
            break
            
        }*/
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    
    @IBAction func changeCameraButtonEvent(_ sender: Any) {
        if (camManager != nil) {
            camManager?.changeCamera()
        }
    }

}
