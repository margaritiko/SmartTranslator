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
import Speech
import SwiftGifOrigin

class InputView: UIView, SFSpeechRecognizerDelegate {
    public let inputPresenter = InputPresenter()
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var leftFlag: UIImageView?
    @IBOutlet weak var rightFlag: UIImageView?
    @IBOutlet weak var sendAndRecordButton: UIButton?
    
    var audioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isLeftInFront: Bool
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            return
        }
    
        guard let myRecognizer = SFSpeechRecognizer() else {
            // A recognizer is not supported for the current locale
            return
        }
        
        if !myRecognizer.isAvailable {
            // A recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.textField?.text = bestString
            }
        })
        node.removeTap(onBus: 0)
        request.endAudio()
    }
    
    override init(frame: CGRect) {
        isLeftInFront = false
        super.init(frame: frame)
        commonInit()
        inputPresenter.attachView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        isLeftInFront = false
        super.init(coder: aDecoder)
        commonInit()
        inputPresenter.attachView(self)
    }
    
    override func awakeFromNib() {
        textField?.addTarget(self, action: #selector(InputView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Changing size and color of text field color
        textField?.layer.borderColor = UIColor(red: 237/255, green: 76/255, blue: 92/255, alpha: 255).cgColor
        textField!.layer.borderWidth = 2
        
        // Making transparent background for pictures
        leftFlag?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        rightFlag?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // Setting pictures
        leftFlag?.image = #imageLiteral(resourceName: "russian")
        rightFlag?.image = #imageLiteral(resourceName: "english")
        bringSubviewToFront(rightFlag!)
        
        // Setting microphone image to button
        sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
        inputPresenter.changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Microphone)
        
        // Adding mouse down and mouse up regonizers
        sendAndRecordButton?.addTarget(self, action:#selector(buttonDown(sender:)), for: .touchDown)
        sendAndRecordButton?.addTarget(self, action:#selector(buttonUp(sender:)), for: [.touchUpInside, .touchUpOutside])
        
        // Setting tint color for button
        sendAndRecordButton?.tintColor = UIColor.white
    }
    
    @objc func buttonDown(sender: AnyObject) {
        // Check button type
        if (inputPresenter.getCurrentStatusOfSendAndRecordButton() == Input.StatusOfSendAndRecordButton.Microphone) {
            // Setting dynamic image to button
            textField?.text = ""
            let recordGif = UIImage.gif(name: "record")
            sendAndRecordButton?.setImage(recordGif, for: .normal)
            textField?.placeholder = "Говорите..."
            
            audioEngine = AVAudioEngine()
            speechRecognizer = SFSpeechRecognizer()
            request = SFSpeechAudioBufferRecognitionRequest()
            recordAndRecognizeSpeech()
        }
        else {
            if (textField?.text ?? "").isContainsOnlySpaces() {
                return
            }
            // Remove all unnecessary whitespaces
            textField?.text = textField?.text?.replacingOccurrences(of: "  ", with: "")
            inputPresenter.prepareForSendingMessage(message: textField?.text ?? "")
        }
    }
    
    // Clearing textField and calling table update
    func updateTable() {
        textField?.text = ""
        inputPresenter.updatePlaceholder()
        tableView?.reloadData()
    }
    
    @objc func buttonUp(sender: AnyObject) {
        inputPresenter.updatePlaceholder()
        if textField?.text != Optional("") {
            // Setting send image to button
            sendAndRecordButton?.setImage(#imageLiteral(resourceName: "send"), for: .normal)
            inputPresenter.changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Send)
        }
        else {
            // Setting microphone image to button
            sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            inputPresenter.changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Microphone)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != Optional("") {
            // Setting send image to button
            sendAndRecordButton?.setImage(#imageLiteral(resourceName: "send"), for: .normal)
            inputPresenter.changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Send)
        }
        else {
            // Setting microphone image to button
            sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            inputPresenter.changeStatusOfSendAndRecordButton(status: Input.StatusOfSendAndRecordButton.Microphone)
        }
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        self.backgroundColor = inputPresenter.getCurrentBackgroundColor()
        // Creating shadow
        self.layer.shadowColor = inputPresenter.getCurrentBackgroundColor().cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -1, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.7
    }
    
    @IBAction func rightFlagTapped(_ sender: Any) {
        inputPresenter.changeLanguages(leftFlag: leftFlag, rightFlag: rightFlag)
        moveFlags()
    }
    
    @IBAction func leftFlagTapped(_ sender: Any) {
        inputPresenter.changeLanguages(leftFlag: leftFlag, rightFlag: rightFlag)
        moveFlags()
    }
    
    func moveFlags() {
        let rightDestination = rightFlag?.layer.position
        let leftDestination = leftFlag?.layer.position
        
        leftFlag?.move(to: rightDestination!.applying(
            CGAffineTransform(translationX: 0.0, y: 0.0)),
                          duration: 0.1,
                          options: UIView.AnimationOptions.curveEaseIn)
        rightFlag?.move(to: leftDestination!.applying(
            CGAffineTransform(translationX: 0.0, y: 0.0)),
                       duration: 0.1,
                       options: UIView.AnimationOptions.curveEaseIn)
        
        // Bringing one of the flag to front
        if (isLeftInFront) {
            leftFlag!.layer.zPosition = 0
            rightFlag!.layer.zPosition = 1
        }
        else {
            rightFlag!.layer.zPosition = 0
            leftFlag!.layer.zPosition = 1
        }
        
        isLeftInFront = !isLeftInFront
    }
}

// MARK: - UIImageView
extension UIImageView {
    
    func move(to destination: CGPoint, duration: TimeInterval,
              options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.center = destination
        }, completion: nil)
    }
    
}

// MARK: - String
extension String {
    func isContainsOnlySpaces() -> Bool {
        for character in self {
            if character != " " {
                return false
            }
        }
        return true
    }
}
