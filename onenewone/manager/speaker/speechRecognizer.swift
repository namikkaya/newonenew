//
//  speechRecognizer.swift
//  onenewone
//
//  Created by namik kaya on 16.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

protocol speechRecognizerDelegate:class {
    func speechRecognizerDidFinish(result:String?)
    func speechRecognizerDidFail()
    func speechRecognizerDidStart()
}

extension speechRecognizerDelegate {
    func speechRecognizerDidFinish(result:String?) {}
    func speechRecognizerDidStart() {}
    func speechRecognizerDidFail() {}
}

class speechRecognizer: NSObject,SFSpeechRecognizerDelegate {
    private let LOG:String = "speechRecognizer"
    private var audioEngine:AVAudioEngine?
    private var speech:SFSpeechRecognizer?
    private var request:SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    private var listenerTimer:Timer?
    
    private var ResultString:String? {
        didSet{
            self.startTimer()
        }
    }
    
    weak var delegate:speechRecognizerDelegate?
    
    override init() {
        super.init()
    }
    
    /// ilk başta sınıfın hazır olması için bunu çağırman gerekiyor
    public func prepare() {
        configAudioEngine()
    }
    
    public func startSpeechListener() {
        print("\(self.LOG): startSpeechListener - ")
        setupProcess()
        recognitionTaskHandler()
    }
    
    private func recognitionTaskHandler() {
        print("\(self.LOG): recognitionTaskHandler start - ")
        recognitionTask = speech?.recognitionTask(with: request!, resultHandler: { (result, error) in
            var isFinal = false
            print("\(self.LOG): result: \(result!.bestTranscription.formattedString) -  status: \(result!.isFinal) - isfinish \(self.recognitionTask?.isFinishing)")
            if let result = result {
                self.ResultString = result.bestTranscription.formattedString
            }
            
            if let result = result, result.isFinal {
                isFinal = result.isFinal
                
            }
            if error != nil || isFinal {
                self.stopListening()
            }
            
        })
    }
    
    private func startTimer() {
        stopTimer()
        print("\(self.LOG): startTimer")
        listenerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerComplete), userInfo: nil, repeats: false)
    }
    
    @objc func timerComplete() {
        self.stopListening()
        stopTimer()
        delegate?.speechRecognizerDidFinish(result: ResultString)
        print("\(self.LOG): timerComplete")
    }
    
    private func stopTimer() {
        print("\(self.LOG): stopTimer")
        if listenerTimer != nil {
            listenerTimer?.invalidate()
            listenerTimer = nil
        }
    }
}

extension speechRecognizer {
    private func setupProcess() {
        print("\(LOG): speach - setupProcess")
        if speech == nil {
            speech = SFSpeechRecognizer(locale: Locale.init(identifier: "tr-TR"))
            speech?.delegate = self
        }
        if recognitionTask == nil {
            recognitionTask = SFSpeechRecognitionTask()
        }
        if request == nil {
            request = SFSpeechAudioBufferRecognitionRequest()
            request?.shouldReportPartialResults = true
        }
    }
    
    private func stopListening() {
        print("\(LOG): speach - stopListening")
        stopTimer()
        if audioEngine != nil {
            audioEngine!.stop()
            audioEngine!.inputNode.removeTap(onBus: 0)
            self.audioEngine = nil
        }
        if request != nil {
            self.request?.endAudio()
            self.request = nil
        }
        if speech != nil {
            self.speech = nil
        }
        if recognitionTask != nil {
            self.recognitionTask?.finish()
            self.recognitionTask = nil
        }
    }
    
    private func configAudioEngine() {
        if audioEngine == nil {
            audioEngine = AVAudioEngine()
        }else {
            return
        }
        
        print("\(LOG): speach - prepare")
        guard let node = audioEngine?.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, avtime) in
            self.request?.append(buffer)
        }
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch let error {
            print("ERROR: \(error)")
        }
    }
    
}
