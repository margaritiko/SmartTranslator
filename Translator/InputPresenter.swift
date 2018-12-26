//
//  InputPresenter.swift
//  Translator
//
//  Created by Маргарита Коннова on 12/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class InputPresenter {
    weak fileprivate var inputView: InputView?
    fileprivate var inputModel: Input;
    
    init() {
        inputModel = Input();
        
    }
    
    func attachView(_ view: InputView){
        inputView = view
    }
    
    func detachView() {
        inputView = nil
    }
    
    func getCurrentBackgroundColor() -> UIColor {
        return inputModel.getCurrentBackgroundColor()
    }
    
    func getCurrentStatusOfSendAndRecordButton() -> Input.StatusOfSendAndRecordButton {
        return inputModel.getCurrentStatusOfSendAndRecordButton()
    }
    
    func changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton) {
        inputModel.changeCurrentStatusOfSendAndRecordButton(status: status)
    }

    func changeLanguages(leftFlag: UIImageView?, rightFlag: UIImageView?) {
        if (inputModel.currentTypeOfTranslation == Input.TypeOfTranslation.FromRussianToEnglish) {
            
            // Setting pictures.
            leftFlag?.image = #imageLiteral(resourceName: "russian")
            rightFlag?.image = #imageLiteral(resourceName: "english")
            inputView?.textField?.text = "English"
            inputView?.textField?.placeholder = "Write a text";
        }
        else {
            // Setting pictures.
            leftFlag?.image = #imageLiteral(resourceName: "english")
            rightFlag?.image = #imageLiteral(resourceName: "russian")
            inputView?.textField?.text = "Русский"
            inputView?.textField?.placeholder = "Введите текст";
        }
        
        inputModel.changeTypeOfTranslation()
        inputView?.bringSubviewToFront(rightFlag!)
        inputView?.textField?.backgroundColor = inputModel.getCurrentBackgroundColor()
        inputView?.textField?.layer.borderColor = inputModel.getCurrentBackgroundColor().cgColor
        inputView?.backgroundColor = inputModel.getCurrentBackgroundColor()
        // Setting microphone image to button
        inputView?.sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
    }
    
    func sendMessage(message: String) {
        inputModel.addNewMessage(old: message, new: message + "!!!")
        
    }
    
    func getTitleForARow(index: Int) -> String {
        return inputModel.getTitleForIndex(index: index)
    }
    
    func getDetailsForARow(index: Int) -> String {
        return inputModel.getDetailsForIndex(index: index)
    }
    
    func getNumberOfMessages() -> Int {
        return inputModel.getNumberOfMessages()
    }

}
