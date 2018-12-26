//
//  ScrollViewController.swift
//  Translator
//
//  Created by Маргарита Коннова on 10/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var isKeyboardWasShown: Bool = false
    //  get current text box when user Begin editing
    @IBOutlet weak var downView: InputView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLayoutTextField: NSLayoutConstraint!
    
    let animals = ["Cat", "Dog", "Cow", "Mulval"]
    override func viewWillAppear(_ animated: Bool) {
        // call method for keyboard notification
        self.setNotificationKeyboard()
        
        // textField!.layer.borderColor = UIColor(red: 47/255, green: 125/255, blue: 225/255, alpha: 255).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AF.request("http://jsonplaceholder.typicode.com/posts").responseJSON { response in
            print("REQUEST")
            print(response)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as? MessageViewCell
        cell?.setRedColor()
        cell?.setHeaderText(text: downView.inputPresenter.getTitleForARow(index: indexPath.row))
        cell?.setDetailsText(text: downView.inputPresenter.getDetailsForARow(index: indexPath.row))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downView.inputPresenter.getNumberOfMessages()
    }
    
    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    // Changes the position of the text field to avoid overlapping.
    @objc func keyboardWasShown(notification: NSNotification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // Raising input field when keyboard appears.
            // Necessary as the keyboard overlaps the text field.
            bottomLayoutTextField.constant += keyboardFrame.cgRectValue.height;
            isKeyboardWasShown = true
        }
    }
    
    // Moves the objects down after the keyboard disappears.
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if isKeyboardWasShown {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                // Raising input field when keyboard appears.
                // Necessary as the keyboard overlaps the text field.
                bottomLayoutTextField.constant -= keyboardFrame.cgRectValue.height;
                isKeyboardWasShown = false
            }
        }
        self.view.endEditing(true)
        
    }
    
    // Pressing anywhere other than the keyboard causes it to disappear.
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
        isKeyboardWasShown = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        // Try to find next responder
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}
