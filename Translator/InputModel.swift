/// Copyright (c) 2018 Margarita Konnova
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
    
    // Red color
    private let colorFromRussianToEnglish = UIColor(red: 237/255, green: 76/255, blue: 92/255, alpha: 255)
    // Blue color
    private let colorFromEnglishToRussian = UIColor(red: 0, green: 124/255, blue: 233/255, alpha: 255)
    
    public var currentTypeOfTranslation: TypeOfTranslation
    private var backgroundColor: UIColor
    private var textColor: UIColor
    private var statusOfSendAndRecordButton: StatusOfSendAndRecordButton
    private var messages: [Message]
    var isKeyboardWasShown: Bool
    
    init() {
        currentTypeOfTranslation = TypeOfTranslation.FromRussianToEnglish
        backgroundColor = colorFromRussianToEnglish
        textColor = UIColor.white
        statusOfSendAndRecordButton = StatusOfSendAndRecordButton.Microphone
        messages = [Message]()
        isKeyboardWasShown = false
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
    
    public mutating func addNewMessage(old: String, new: String, type: Input.TypeOfTranslation) {
        let newType: Input.TypeOfTranslation
        // Detecting current type of translation and initializing newType variable with opposite type of translation
        if (type == Input.TypeOfTranslation.FromEnglishToRussian) {
            newType = Input.TypeOfTranslation.FromRussianToEnglish
        }
        else {
            newType = Input.TypeOfTranslation.FromEnglishToRussian
        }
        
        // Message from bot
        messages.insert(Message(notTranslatedText: "Подскажите, как пройти в библиотеку?", translatedText: "Tell me how to get to the library?", type: newType, isMessageFromUser: false), at: 0)
        // Message from user
        messages.insert(Message(notTranslatedText: old, translatedText: new, type: type, isMessageFromUser: true), at: 1)
    }
    
    public func getCurrentTypeForIndex(index: Int) -> Input.TypeOfTranslation {
        return messages[index].getTypeOfTranslation()
    }
    
    public func getTitleForIndex(index: Int) -> String {
        return messages[index].notTranslatedText
    }
    
    public func getDetailsForIndex(index: Int) -> String {
        return messages[index].translatedText
    }
    
    public func getIsMessageFromUser(index: Int) -> Bool {
        return messages[index].isMessageFromUser
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
