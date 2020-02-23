//
//  ViewController.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class ViewController: UIViewController {

    var recorder: AVAudioRecorder?
    var levelTimer: Timer?
    var lowPassResults: Double = 0.0
    
    var audioSession:AVAudioSession?

    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default)
            try audioSession?.setActive(true)
        } catch {
            print(error)
        }

        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            recorderPrepare()
            print("permission okey")
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                print("permission okey")
                self.recorderPrepare()
            })
        @unknown default:
            fatalError()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopDecibelTimer()
        if let _ = levelTimer {
            levelTimer!.invalidate()
            levelTimer = nil
        }
        levelTimer = nil
        recorder = nil
    }
    
    private func recorderPrepare() {
        
        //let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = NSTemporaryDirectory()
        let documentDirectory = URL(fileURLWithPath: path)
        let originPath = documentDirectory.appendingPathComponent("audioFile1.m4a")
        
        
        let recordSettings = [AVFormatIDKey:kAudioFormatAppleLossless, //kAudioFormatAppleIMA4
        AVSampleRateKey:44100.0,
        AVNumberOfChannelsKey:2,
        AVEncoderBitRateKey:12800,
        AVLinearPCMBitDepthKey:16,
        AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
        ] as [String : Any]
        
        do {
            recorder = try AVAudioRecorder(url: originPath, settings: recordSettings)
            recorder!.prepareToRecord()
            recorder!.isMeteringEnabled = true
            recorder!.record()
            
            self.levelTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(levelTimerCallback(timer:)), userInfo: nil, repeats: true)
        } catch let error {
            print("HATA: \(error)")
        }
    }
    
    var status:Bool = false
    var speakStatus:Bool = false
    private let decibelTimerCount:Double = 2
    private var decibelTimer:Timer?
    
    private var noiseVolume:Float = 0
    private var noiseTotalVolume:Float = 0
    private var noiseCount:Float = 1
    
    private var averageVolume:Float?
    
    private var speakSureCount:Float = 0
    
    @objc func levelTimerCallback(timer: Timer) {
        if (recorder == nil) {
            return
        }
        recorder!.updateMeters()
        
        if (noiseCount > 500) {
            noiseCount = 1
            noiseTotalVolume = 0
            noiseVolume = 0
        }
        
        noiseTotalVolume = noiseTotalVolume + recorder!.averagePower(forChannel: 0)
        noiseVolume = noiseTotalVolume / noiseCount
        
        noiseCount = noiseCount + 1
        
        
        //print("noiseCount: \(noiseCount) = \(noiseVolume)")
        if (averageVolume == nil) {
            averageVolume = noiseVolume
        }
        
        print("noiseCount: - \(averageVolume! - 15) >= \(noiseVolume)")
        print("noiseCount: + \(averageVolume! + 15) <= \(noiseVolume)")
        
        if averageVolume! - 15 >= noiseVolume || averageVolume! + 15 <= noiseVolume {
            if (speakSureCount < 10) {
                speakSureCount = speakSureCount + 1
                return
            }
            if !status {
                print("Konuşuyor")
                status = !status
                speakStatus = true
                stopDecibelTimer()
                DispatchQueue.main.async {
                    self.statusLabel.text = "Konuşuyor..."
                }
            }
        }else {
            if status {
                print("Sustu")
                averageVolume = noiseVolume
                status = !status
                startDecibelTimer()
            }
        }
        
        /*
        if recorder.averagePower(forChannel: 0) > -30 {
            if !status {
                print("Konuşuyor")
                status = !status
                speakStatus = true
                stopDecibelTimer()
                DispatchQueue.main.async {
                    self.statusLabel.text = "Konuşuyor..."
                }
            }
        }else {
            if status {
                print("Sustu")
                status = !status
                startDecibelTimer()
            }
        }*/
        
        /*
        if recorder.averagePower(forChannel: 0) > -7 {
            print("Dis be da level I'm hearin' you in dat mic ")
            print(recorder.averagePower(forChannel: 0))
            print("Do the thing I want, mofo")
        }*/
    }

    
    private func startDecibelTimer() {
        stopDecibelTimer()
        self.decibelTimer = Timer.scheduledTimer(timeInterval: 2.0,
                                               target: self,
                                               selector: #selector(decibelTimerComplete(timer:)),
                                               userInfo: nil,
                                               repeats: false)
    }

    private func stopDecibelTimer() {
        if decibelTimer != nil {
            decibelTimer?.invalidate()
            decibelTimer = nil
        }
    }
    
    @objc func decibelTimerComplete(timer: Timer) {
        stopDecibelTimer()
        if speakStatus {
            DispatchQueue.main.async {
                self.statusLabel.text = "Konuşma BİTTİ"
            }
            speakSureCount = 0
            speakStatus = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

