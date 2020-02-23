//
//  speakerManager.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

enum INFORMATION_PAGE {
    case baseInformation
}

protocol speakerManagerDelegate:class {
    
}

extension speakerManagerDelegate {
    
}

class speakerManager: NSObject {
    private let TAG:String = "speakerManager: "
    
    private var preview:UIView?
    private var vc:cameraViewController?
    
    weak var delegate:speakerManagerDelegate?
    
    var stepList:[question?] = []
    
    var stepCount:Int = 0
    
    var navController:UINavigationController?
    
    override init() {
        super.init()
    }

    convenience init(preview:UIView?, page:INFORMATION_PAGE, vc:cameraViewController?) {
        self.init()
        self.preview = preview
        self.vc = vc
        self.delegate = vc
        setPage(page: page)
    }
    
    private func setPage(page:INFORMATION_PAGE?) {
        guard let page = page else { return }
        switch page {
        case .baseInformation:
            setView()
            stepList = questionPrepare()
            break
        }
    }
    
    private func setView() {
        guard let vc = self.vc, let preview = self.preview else { return }
        navController = (UIStoryboard(name: "userInformation", bundle: nil).instantiateViewController(withIdentifier: "userInfoNav") as! UINavigationController)
        vc.addChild(navController!)
        preview.addSubview(navController!.view)
        self.preview?.backgroundColor = .clear
        navController?.view.backgroundColor = .clear
        navController!.view.frame = preview.bounds
    }
    
    func questionPrepare() -> [question] {
        let question1:question = question(id: 1, questionSentence: "Adınızı ve Soyadınızı söyler misiniz?", answerToTheQuestion: nil)
        let question2:question = question(id: 2, questionSentence: "Cinsiyetinizi söyler misiniz? Kadın veya Erkek diyebilirsiniz.", answerToTheQuestion: nil)
        let question3:question = question(id: 3, questionSentence: "Vatandaşı olduğunuz ülke hangisi?", answerToTheQuestion: nil)
        let question4:question = question(id: 4, questionSentence: "Anadilinizi Türkçe olarak kaydedeyim mi? Evet veya hayır diyebilirsiniz.", answerToTheQuestion: nil)
        let question5:question = question(id: 5, questionSentence: "Doğum tarihinizi gün ay yıl olarak söyleyebilir misiniz?", answerToTheQuestion: nil)
        let question6:question = question(id: 6, questionSentence: "Doğduğun şehri söyleyebilir misin?", answerToTheQuestion: nil)
        let question7:question = question(id: 7, questionSentence: "Medeni halinizi söyler misiniz? Bekar veya Evli şeklinde cevaplayabilirsiniz.", answerToTheQuestion: nil)
        let question8:question = question(id: 8, questionSentence: "Engel durumunuz var mı?", answerToTheQuestion: nil)
        let question9:question = question(id: 9, questionSentence: "Eski hükümlü müsünüz?", answerToTheQuestion: nil)
        var allQuestions:[question] = []
        allQuestions = [question1,question2,question3,question4,question5,question6,question7,question8,question9]
        return allQuestions
    }
    
    func getStepData() -> question?{
        let count = stepCount
        stepCount += 1
        if stepList.count-1 == stepCount {
            return nil
        }else {
            return stepList[count]
        }
    }
    
    func setText(str:String) {
        if let vc = navController?.visibleViewController as? textViewController {
            vc.setText = str
        }
    }
    
}
