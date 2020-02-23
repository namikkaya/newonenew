//
//  cameraViewController.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import AVFoundation

class cameraViewController: UIViewController, speakerManagerDelegate, siriSpeakerDelegate, speechRecognizerDelegate {
    private let LOG:String = "CameraViewController: "
    
    var callBack: ((_ status: Bool)-> Void)?
    
//    MARK:- Views
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var questionView: UIView!
    
    
//    MARK:- Class
    private var camManager:cameraManager?
    private var speakerMan:speakerManager?
    private var siriMan:siriSpeaker?
    private var speechRecognizerMan:speechRecognizer?
    
    private var questions:[question?] = []
    
    private var audioSession:AVAudioSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (siriMan != nil) {
            siriMan = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        microphonePermissionRequest()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let camMan = camManager else { return }
        camMan.autoRefreshView()
    }
    
    //    MARK: - İZİNLER
    
    private func microphonePermissionRequest() {
        self.askMicrophonePermission { (status) in
            if status {
                self.speechPermissionRequest()
            }else {
                self.infoAlert(title: "Mikrofon İzinleri", msg: "Mikrofon izinleriniz yok lütfen izin verin.") { (status) in
                    if status {
                        if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { (status) in
                                if (status) {
                                    print("status shared open okey")
                                }else {
                                    print("status shared open cancel")
                                }
                            }
                        }else {
                            print("bu url okunamaz.")
                        }
                    }else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func speechPermissionRequest() {
        self.askSpeechPermission { (status) in
            if status {
                self.cameraPermissionRequest()
            }else {
                self.infoAlert(title: "Konuşma Tanıma", msg: "Konuşma tanımayı kullanmak için izin verin.") { (status) in
                    if status {
                        if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { (status) in
                                if (status) {
                                    print("status shared open okey")
                                }else {
                                    print("status shared open cancel")
                                }
                            }
                        }else {
                            print("bu url okunamaz.")
                        }
                    }else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func cameraPermissionRequest() {
        self.askCameraPermission { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.configuration()
                    self.setupSubManagers()
                }
            }else {
                self.infoAlert(title: "Kamera İzinleri", msg: "Kamera izinleriniz yok lütfen izin verin.") { (status) in
                    if status {
                        if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { (status) in
                                if (status) {
                                    print("status shared open okey")
                                }else {
                                    print("status shared open cancel")
                                }
                            }
                        }else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func configuration() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .videoRecording)
            try audioSession?.setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func setupSubManagers() {
        camManager = cameraManager(root: self.view, preview: self.cameraPreviewView)
        speakerMan = speakerManager(preview: questionView, page: INFORMATION_PAGE.baseInformation, vc: self)
        
        siriMan = siriSpeaker()
        siriMan?.delegate = self
        
        speechRecognizerMan = speechRecognizer()
        speechRecognizerMan?.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    
    var startText:String = ""
    var currentId:Int?
    private func startVoice() {
        guard let speaker = speakerMan, let siri = siriMan else { return }
        let data = speaker.getStepData()
        if data != nil {
            //speakerMan?.setText(str: <#T##String#>)
            startText = ""
            currentId = data?.id
            switch data?.id {
            case 1:
                startText += "İsim: "
                break
            case 2:
                startText += "\nCinsiyet: "
                break
            case 3:
                startText += "\nUyruk: "
                break
            case 4:
                startText += "\nDil: "
                break
            case 5:
                startText += "\nDoğum Tarihi: "
                break
            case 6:
                startText += "\nDoğum Yeri: "
                break
            case 7:
                startText += "\nMedeni Hal: "
                break
            case 8:
                startText += "\nEngel: "
                break
            case 9:
                startText += "\nHükümlü: "
                break
            default:
                break
            }
            siri.startQuestion(sentence: data?.questionSpeech)
        }else{
            let alert = UIAlertController(title: "Tebrikler", message: "Başarılı bir şekilde bu formu doldurdunuz.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: { (act) in
                self.dismiss(animated: true) {
                    self.callBack!(true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func SiriSpeechDidFinish() {
        print("\(LOG) siri konuşması bitti.")
        guard let speechRecognizerMan = speechRecognizerMan else { return }
        speechRecognizerMan.prepare()
        speechRecognizerMan.startSpeechListener()
    }
    
    
    // siri konuşması başlattıldı.
    func SiriSpeechStart() {
        print("\(LOG) siri konuşması başladı.")
    }
    
    // --
    func speechRecognizerDidStart() {
        print("\(LOG) dinlemeye başladı")
    }
    
    func speechRecognizerDidFinish(result: String?) {
        if let str = result {
            print("\(LOG) anladığını döndü: \(str)")
            
            switch currentId {
            case 4:
                if str == "Evet" || str == "Evet" {
                    startText += "Türkçe"
                }else {
                    startText += "Bilinmeyen dil"
                }
                break
            default:
                startText += " \(str)"
                break
            }
            
            if let speakerMan = speakerMan {
                speakerMan.setText(str: startText)
            }
            startVoice()
        }
    }
    
    func speechRecognizerDidFail() {
        print("\(LOG) konuşmada hata alındı.")
    }
}
