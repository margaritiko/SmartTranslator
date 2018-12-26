//
//  InputView.swift
//  Translator
//
//  Created by Маргарита Коннова on 11/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import UIKit
import Speech

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
            return print(error)
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
            else if let error = error {
                print(error)
            }
        })
        node.removeTap(onBus: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        inputPresenter.attachView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        inputPresenter.attachView(self)
    }
    
    override func awakeFromNib() {
        textField?.addTarget(self, action: #selector(InputView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Changing size and color of text field color
        textField?.layer.borderColor = UIColor(red: 220/255, green: 88/255, blue: 96/255, alpha: 255).cgColor
        textField!.layer.borderWidth = 1
        
        // Making transparent background for pictures
        leftFlag?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        rightFlag?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // Setting pictures
        leftFlag?.image = #imageLiteral(resourceName: "russian")
        rightFlag?.image = #imageLiteral(resourceName: "english")
        
        // Setting microphone image to button
        sendAndRecordButton?.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
        
        // Adding mouse down and mouse up regonizers
        sendAndRecordButton?.addTarget(self, action:#selector(buttonDown(sender:)), for: .touchDown)
        sendAndRecordButton?.addTarget(self, action:#selector(buttonUp(sender:)), for: [.touchUpInside, .touchUpOutside])
        
        // Setting tint color for button
        sendAndRecordButton?.tintColor = UIColor.white
    }
    
    @objc func buttonDown(sender: AnyObject) {
        if (inputPresenter.getCurrentStatusOfSendAndRecordButton() == Input.StatusOfSendAndRecordButton.Microphone) {
            // Setting dynamic image to button
            textField?.text = ""
            let recordGif = UIImage.gifImageWithName("record")
            sendAndRecordButton?.setImage(recordGif, for: .normal)
            
            audioEngine = AVAudioEngine()
            speechRecognizer = SFSpeechRecognizer()
            request = SFSpeechAudioBufferRecognitionRequest()
            recordAndRecognizeSpeech()
        }
        else {
            inputPresenter.sendMessage(message: textField?.text ?? "")
            textField?.text = ""
            tableView?.reloadData()
        }
    }
    
    @objc func buttonUp(sender: AnyObject) {
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
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = true;
        self.backgroundColor = inputPresenter.getCurrentBackgroundColor()
    }
    
    @IBAction func rightFlagTapped(_ sender: Any) {
        inputPresenter.changeLanguages(leftFlag: leftFlag, rightFlag: rightFlag)
    }
    
    @IBAction func leftFlagTapped(_ sender: Any) {
        inputPresenter.changeLanguages(leftFlag: leftFlag, rightFlag: rightFlag)
    }
    
}
