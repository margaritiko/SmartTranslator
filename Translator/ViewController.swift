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

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // A field for information on whether the keyboard is raised
    var isKeyboardWasShown: Bool = false
    @IBOutlet weak var rightYandexLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftYandexLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var downView: InputView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLayoutTextField: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        // Calling method for keyboard notification
        self.setNotificationKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting dataSource and delegate for tableView
        tableView.dataSource = self
        tableView.delegate = self
        // Setting for row height automatic dimensions
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Updating constraints for logo depending on the orientation of the device
        if UIDevice.current.orientation.isLandscape {
            let width = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            leftYandexLogoConstraint.constant = (width - 202) / 2
            rightYandexLogoConstraint.constant = (width - 202) / 2
        }
        else {
            let width = UIScreen.main.bounds.size.width
            leftYandexLogoConstraint.constant = (width - 202) / 2
            rightYandexLogoConstraint.constant = (width - 202) / 2
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Updating constraints for logo depending on the orientation of the device
        if UIDevice.current.orientation.isLandscape {
            let width = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            leftYandexLogoConstraint.constant = (width - 202) / 2
            rightYandexLogoConstraint.constant = (width - 202) / 2
        }
        else {
            let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            leftYandexLogoConstraint.constant = (width - 202) / 2
            rightYandexLogoConstraint.constant = (width - 202) / 2
        }
    }
    
    override func viewDidLayoutSubviews() {
        let scrollSize = CGSize(width: tableView.frame.size.width - 200,
                                height: tableView.frame.size.height - 200)
        scrollView.contentSize = scrollSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as? MessageViewCell
        
        // Setting color for current cell
        if (downView.inputPresenter.getTypeForARowAt(index: indexPath.row) == Input.TypeOfTranslation.FromRussianToEnglish) {
            cell?.setRedColor()
        }
        else {
            cell?.setBlueColor()
        }
        // Getting and setting title and details text
        let title = downView.inputPresenter.getTitleForARowAt(index: indexPath.row)
        let details = downView.inputPresenter.getDetailsForARowAt(index: indexPath.row)
        cell?.setHeaderText(text: title)
        cell?.setDetailsText(text: details)
        // Making some updates if this message not from user
        if !downView.inputPresenter.getIsMessageFromUserForARowAt(index: indexPath.row) {
            cell?.moveToRight()
            cell?.changeCornerRadiusForNotUserMessages()
            cell?.isMessageFromUser = false
        }
        else {
            cell?.correctLength(length: max(title.count, details.count))
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downView.inputPresenter.getNumberOfMessages()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    // Changes the position of the text field to avoid overlapping
    @objc func keyboardWasShown(notification: NSNotification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if !isKeyboardWasShown {
                // Raising input field when keyboard appears
                // Necessary as the keyboard overlaps the text field
                bottomLayoutTextField.constant += keyboardFrame.cgRectValue.height
                isKeyboardWasShown = true
                downView.inputPresenter.ChangeIsKeyboardWasShownValue()
                downView.inputPresenter.updatePlaceholder()
            }
        }
    }
    
    // Moves the objects down after the keyboard disappears
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        if isKeyboardWasShown {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                // Raising input field when keyboard appears
                // Necessary as the keyboard overlaps the text field
                bottomLayoutTextField.constant -= keyboardFrame.cgRectValue.height
                isKeyboardWasShown = false
                downView.inputPresenter.ChangeIsKeyboardWasShownValue()
                downView.inputPresenter.updatePlaceholder()
            }
        }
        self.view.endEditing(true)
    }
    
    // Pressing anywhere other than the keyboard causes it to disappear
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
        isKeyboardWasShown = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false
    }
}
