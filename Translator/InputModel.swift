//
//  InputModel.swift
//  Translator
//
//  Created by Маргарита Коннова on 12/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import UIKit
import Foundation

struct Input {
    public enum TypeOfTranslation {
        case FromRussianToEnglish
        case FromEnglishToRussian
    }
    
    public enum StatusOfSendAndRecordButton {
        case Microphone
        case Send
    }
    
    private let colorFromRussianToEnglish = UIColor(red: 220/255, green: 88/255, blue: 96/255, alpha: 255)
    private let colorFromEnglishToRussian = UIColor(red: 47/255, green: 125/255, blue: 225/255, alpha: 255)
    
    public var currentTypeOfTranslation: TypeOfTranslation
    private var backgroundColor: UIColor
    private var textColor: UIColor
    private var statusOfSendAndRecordButton: StatusOfSendAndRecordButton
    
    var messages: [Message]
    
    init() {
        currentTypeOfTranslation = TypeOfTranslation.FromRussianToEnglish;
        backgroundColor = colorFromRussianToEnglish;
        textColor = UIColor.white;
        statusOfSendAndRecordButton = StatusOfSendAndRecordButton.Microphone
        messages = [Message]()
    }
    
    mutating func changeTypeOfTranslation() {
        if self.currentTypeOfTranslation == TypeOfTranslation.FromEnglishToRussian {
            currentTypeOfTranslation = .FromRussianToEnglish
            backgroundColor = colorFromRussianToEnglish
        }
        else {
            currentTypeOfTranslation = .FromEnglishToRussian
            backgroundColor = colorFromEnglishToRussian
        }
    }
    
    public func getCurrentBackgroundColor() -> UIColor {
        return backgroundColor
    }
    
    public func getCurrentStatusOfSendAndRecordButton() -> StatusOfSendAndRecordButton {
        return statusOfSendAndRecordButton
    }
    
    public func getNumberOfMessages() -> Int {
        return messages.count
    }
    
    public mutating func addNewMessage(old: String, new: String) {
        messages.append(Message(notTranslatedText: old, translatedText: new))
    }
    
    public func getTitleForIndex(index: Int) -> String {
        return messages[index].notTranslatedText
    }
    
    public func getDetailsForIndex(index: Int) -> String {
        return messages[index].translatedText
    }
    
    mutating public func changeCurrentStatusOfSendAndRecordButton(status: StatusOfSendAndRecordButton) {
        if status == StatusOfSendAndRecordButton.Send {
            statusOfSendAndRecordButton = .Send
        }
        else {
            statusOfSendAndRecordButton = .Microphone
        }
    }
}
