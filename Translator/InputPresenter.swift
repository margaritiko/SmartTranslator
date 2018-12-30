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

import Foundation
import UIKit
import Alamofire

class InputPresenter {
    weak fileprivate var inputView: InputView?
    fileprivate var inputModel: Input
    
    var listOfSupportedLanguages: [String: [String]]
    
    init() {
        inputModel = Input()
        listOfSupportedLanguages = ["default" : []]
        getAnArrayOfLanguagesThatCanBeTranslatedFromThe(Language: "ru")
        getAnArrayOfLanguagesThatCanBeTranslatedFromThe(Language: "en")
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
    
    func getCurrentTypeOfTranslation() -> Input.TypeOfTranslation {
        return inputModel.currentTypeOfTranslation
    }
    
    func updatePlaceholder() {
        if (inputModel.currentTypeOfTranslation == Input.TypeOfTranslation.FromRussianToEnglish) {
            if inputView?.textField?.text == "" && !inputModel.isKeyboardWasShown {
                inputView?.textField?.placeholder = "Русский"
                // Setting microphone image to button
                inputView?.sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            }
            else if inputView?.textField?.text == "" {
                inputView?.textField?.placeholder = "Введите текст"
            }
        }
        else {
            if inputView?.textField?.text == ""  && !inputModel.isKeyboardWasShown {
                inputView?.textField?.placeholder = "Английский"
                // Setting microphone image to button
                inputView?.sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            }
            else if inputView?.textField?.text == "" {
                inputView?.textField?.placeholder = "Введите текст"
            }
        }
    }

    func changeLanguages(leftFlag: UIImageView?, rightFlag: UIImageView?) {
        inputModel.changeTypeOfTranslation()
        // Changing placeholder depending on the current state
        self.updatePlaceholder()
        // Updating color of input field
        inputView?.textField?.backgroundColor = inputModel.getCurrentBackgroundColor()
        inputView?.layer.shadowColor = inputModel.getCurrentBackgroundColor().cgColor
        inputView?.textField?.layer.borderColor = inputModel.getCurrentBackgroundColor().cgColor
        inputView?.backgroundColor = inputModel.getCurrentBackgroundColor()
    }
    
    func ChangeIsKeyboardWasShownValue() {
        inputModel.isKeyboardWasShown = !inputModel.isKeyboardWasShown
    }
    
    func IsKeyboardWasShown() -> Bool {
        return inputModel.isKeyboardWasShown
    }
    
    func prepareForSendingMessage(message: String) {
        detectLanguageOf(message: message, typeOfTranslation: getCurrentTypeOfTranslation())
    }
    
    // Sending message
    func send(untranslatedMessage: String, translatedMessage: String) {
        inputModel.addNewMessage(old: untranslatedMessage, new: translatedMessage, type: getCurrentTypeOfTranslation())
        inputView?.sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
        changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Microphone)
        inputView?.updateTable()
    }
    
    func getTypeForARowAt(index: Int) -> Input.TypeOfTranslation {
        return inputModel.getCurrentTypeForIndex(index: index)
    }
    
    func getTitleForARowAt(index: Int) -> String {
        return inputModel.getTitleForIndex(index: index)
    }
    
    func getDetailsForARowAt(index: Int) -> String {
        return inputModel.getDetailsForIndex(index: index)
    }
    
    func getNumberOfMessages() -> Int {
        return inputModel.getNumberOfMessages()
    }
    
    func getIsMessageFromUserForARowAt(index: Int) -> Bool {
        return inputModel.getIsMessageFromUser(index: index)
    }
    
    // Getting an array with languages using Yandex API functionality
    func getAnArrayOfLanguagesThatCanBeTranslatedFromThe(Language lang: String) {
        AF.request("https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=" + KEY + "&ui=" + lang).responseJSON { response in
            
            switch response.result {
            case .success:
                guard let jsonArray = response.result.value as? Optional<[String: Any]> else { return }
                guard let arrayWithLanguages = jsonArray?["dirs"]! as? [String] else { return }
                self.listOfSupportedLanguages[lang] = arrayWithLanguages
            case .failure:
                return
            }
        }
    }
    
    // Detecting language using Yandex API functionality
    func detectLanguageOf(message: String, typeOfTranslation type: Input.TypeOfTranslation) {

        let encoded = message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        AF.request("https://translate.yandex.net/api/v1.5/tr.json/detect?key=" + KEY + "&text=" + encoded!).responseJSON { response in
            switch response.result {
            case .success:
                guard let jsonArray = response.result.value as? Optional<[String: Any]> else { return }
                guard let language = jsonArray?["lang"] as? String? else { return }
                
                if language ?? "" == "en" && type == Input.TypeOfTranslation.FromEnglishToRussian {
                    self.translate(Message: message, ToLanguage: "ru")
                }
                else if language ?? "" == "ru" && type == Input.TypeOfTranslation.FromRussianToEnglish {
                    self.translate(Message: message, ToLanguage: "en")
                }
                else {
                    self.send(untranslatedMessage: message, translatedMessage: message)
                }
            case .failure:
                return
            }
        }
    }
    
    // Translating text using Yandex API functionality
    func translate(Message message: String, ToLanguage lang: String) {
        let encoded = message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        AF.request("https://translate.yandex.net/api/v1.5/tr.json/translate?key=" + KEY + "&text=" + encoded! + "&lang=" + lang).responseJSON { response in
            switch response.result {
            case .success:
                guard let jsonArray = response.result.value as? [String: Any] else { return }
                guard let translatedMessage = jsonArray["text"]! as? [String] else { return }
                self.send(untranslatedMessage: message, translatedMessage: translatedMessage[0])
            case .failure:
                return
            }
        }
    }
}
