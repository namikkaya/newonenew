//
//  extensions.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import UIKit
import SQLite

private var dataAssocKey = 0
public var myHolderView:UIViewController?

extension UIViewController {
    var data:AnyObject? {
        get {
            return objc_getAssociatedObject(self, &dataAssocKey) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self, &dataAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**
     Usage: Onaylatma bilgi alert
     - Parameter title:  Başlık
     - Parameter message:  Mesaj
     - Parameter positiveButtonTitle:  olumlu cevap button
     - Parameter negativeButtonTitle:  olumsuz cevap button / sadece bilgilendirme ise bu parametreye nil yollanırsa tek button olarak görüntülencek.
     - Parameter buttonClick: true / false
     - Returns: No return value
     */
    func informationAlert(title:String = "Başlık",
                          message:String = "Mesaj",
                          positiveButtonTitle:String = "Tamam",
                          negativeButtonTitle:String? = "İptal",
                          onButtonClick buttonClick: @escaping (Bool?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveButtonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            buttonClick(true)
        }))
        if negativeButtonTitle != nil {
            alert.addAction(UIAlertAction(title: negativeButtonTitle, style: UIAlertAction.Style.cancel, handler: { (action) in
                buttonClick(false)
            }))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard_viewController))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard_viewController() {
        self.view.endEditing(true)
    }
    
    func goto(screenID:String,
              animated:Bool,
              data:AnyObject!,
              isModal:Bool,
              transition: UIViewControllerTransitioningDelegate) {
        let vc:UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: screenID))!
        myHolderView = vc
        if (data != nil) {
            vc.data = data
        }
        if isModal == true {
            vc.modalPresentationStyle = .overFullScreen//.overCurrentContext
            vc.transitioningDelegate = transition
            self.present(vc, animated: animated, completion:nil)
        }else {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    /**
     Usage:  Özellikle preloader için kullanılır.
     - Parameter screenID:  viewcontroller storyboard id
     - Parameter animated:  true/false
     - Parameter color:  3 rent alır dıştan içe hareket
     - Parameter message:  açıklama satırı için string
     - Parameter transition:  Açılış kapanış animasyonu
     - Returns: No return value
     */
    func goto(screenID:String, animated:Bool, color:[UIColor], message:String? = "Yükleniyor...", transition: UIViewControllerTransitioningDelegate) {
        let vc:preloaderPopupController = (self.storyboard?.instantiateViewController(withIdentifier: screenID)) as! preloaderPopupController
        myHolderView = vc
        vc.modalPresentationStyle = .overFullScreen//.overCurrentContext
        vc.transitioningDelegate = transition
        vc.spinnerColor = color[0]
        vc.bSpinnerColor = color[1]
        vc.aSpinnerColor = color[2]
        vc.setDescription = message
        self.present(vc, animated: animated, completion:nil)
    }
    
    func back(animated:Bool, isModal:Bool) {
        myHolderView = nil
        if isModal == true {
            self.dismiss(animated: animated, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func setNavigationColor(color:UIColor?){
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    /**
     Usage: ViewController için background rengi atar
     - Parameter color:  UIColor
     - Returns: No return value
     */
    func bgColor(color:UIColor) {
        self.view.backgroundColor = color
    }
    
    /**
     Usage:  NavigationController bar için title atar. Title için gölge efekti ve 17 size verir.
     - Parameter titleText:  String
     - Returns: No return value
     */
    func setNavigationBarTitle(titleText:String){
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        textShadow.shadowColor = UIColor.gray
        
        var attrs:[NSAttributedString.Key : Any] = [:]
        if #available(iOS 8.2, *) {
            attrs = [
                /*NSAttributedString.Key.shadow: textShadow,*/
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
            ]
        } else {
            attrs = [
                /*NSAttributedString.Key.shadow: textShadow,*/
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
            ]
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        self.navigationItem.title = titleText
        
    }
    
}

//MARK: - SQLite extension
extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
