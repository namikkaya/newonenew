//
//  siriSpeaker.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import AVFoundation


enum QUESTION_STATUS {
    case preparing
    case questionAskedNow
    case nowBeingAnswered
    case finished
}

protocol siriSpeakerDelegate:class {
    func SiriSpeechDidFinish()
    func SiriSpeechStart()
}

class siriSpeaker: NSObject,AVSpeechSynthesizerDelegate {
    private let TAG:String = "siriSpeaker:"
    
//    MARK:- class
    private var speechSynthesizer:AVSpeechSynthesizer?
    weak var delegate:siriSpeakerDelegate?
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer?.delegate = self
    }

    func startQuestion(sentence:AVSpeechUtterance?) {
        guard let sentence = sentence, let speechSynthesizer = speechSynthesizer else { return }
        sentence.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        sentence.voice = AVSpeechSynthesisVoice(language: "tr_TR")
        speechSynthesizer.speak(sentence)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.SiriSpeechStart()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.SiriSpeechDidFinish()
    }
}
