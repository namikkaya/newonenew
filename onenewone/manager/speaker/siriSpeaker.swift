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
    func speechDidFinish()
    func speechStart()
}

class siriSpeaker: NSObject,AVSpeechSynthesizerDelegate {
//    MARK:- class
    private var speechSynthesizer:AVSpeechSynthesizer?
    weak var delegate:siriSpeakerDelegate?
    
    override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        speechSynthesizer = AVSpeechSynthesizer()
    }

    func startQuestion(sentence:AVSpeechUtterance?) {
        guard let sentence = sentence, let speechSynthesizer = speechSynthesizer else { return }
        sentence.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        sentence.voice = AVSpeechSynthesisVoice(language: "tr_TR")
        speechSynthesizer.speak(sentence)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.speechStart()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speechDidFinish()
    }
}
