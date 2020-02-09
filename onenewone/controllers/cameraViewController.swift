//
//  cameraViewController.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class cameraViewController: UIViewController, speakerManagerDelegate, siriSpeakerDelegate {
    

    private let TAG:String = "CameraViewController: "
    
//    MARK:- Views
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var questionView: UIView!
    
    
//    MARK:- Class
    private var camManager:cameraManager?
    private var speakerMan:speakerManager?
    private var siriMan:siriSpeaker?
    
    private var questions:[question?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camManager = cameraManager(root: self.view, preview: cameraPreviewView)
        speakerMan = speakerManager(preview: questionView, page: INFORMATION_PAGE.baseInformation, vc: self)
        siriMan = siriSpeaker()
        siriMan?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.rotated),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
        if (camManager != nil) {
            camManager = nil
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.startVoice()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let camMan = camManager else { return }
        camMan.autoRefreshView()
    }
    
    
    private func startVoice() {
        guard let speaker = speakerMan, let siri = siriMan else { return }
        let data = speaker.getStepData()
        siri.startQuestion(sentence: data?.questionSpeech)
    }

    func speechDidFinish() {
        
    }
    
    func speechStart() {
        
    }
}
