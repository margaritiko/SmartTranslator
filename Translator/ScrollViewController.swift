//
//  ScrollViewController.swift
//  Translator
//
//  Created by Маргарита Коннова on 10/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //  get current text box when user Begin editing
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeTextField: UITextField?
    @IBOutlet weak var bottomLayoutTextField: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        // call method for keyboard notification
        self.setNotificationKeyboard()
        
    }
    
    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    // get current text field
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField=textField;
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeTextField = nil;
    }
    
    // Changes the position of the text field to avoid overlapping.
    @objc func keyboardWasShown(notification: NSNotification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // Raising input field when keyboard appears.
            // Necessary as the keyboard overlaps the text field.
            bottomLayoutTextField.constant += keyboardFrame.cgRectValue.height;
            // tableView.frame.size.height -= keyboardFrame.cgRectValue.height;
        }
    }
    
    // Moves the objects down after the keyboard disappears.
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // Raising input field when keyboard appears.
            // Necessary as the keyboard overlaps the text field.
            bottomLayoutTextField.constant -= keyboardFrame.cgRectValue.height;
            // tableView.frame.size.height -= keyboardFrame.cgRectValue.height;
        }
        self.view.endEditing(true)
    }
    
    // Pressing anywhere other than the keyboard causes it to disappear.
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
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
