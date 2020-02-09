//
//  models.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import AVFoundation

struct question {
    var id:Int?
    var questionSentence:String?
    var answerToTheQuestion:String?
    var availability:Bool? = false
    
    init(id:Int?, questionSentence:String?, answerToTheQuestion:String?) {
        self.id = id
        self.questionSentence = questionSentence
        self.answerToTheQuestion = answerToTheQuestion
        self.questionSpeechHolder = questionSentence
    }
    
    private var questionSpeechHolder:String?
    var questionSpeech:AVSpeechUtterance {
        get{
            return AVSpeechUtterance(string: questionSpeechHolder ?? "")
        }
    }
}
