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

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var detailsText: UILabel!
    @IBOutlet weak var cell: UIView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var isMessageFromUser: Bool
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        isMessageFromUser = true
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        isMessageFromUser = true
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cell.layer.cornerRadius = 15
        cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        self.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setRedColor() {
        cell.backgroundColor = RED_COLOR
    }
    
    public func setBlueColor() {
        cell.backgroundColor = BLUE_COLOR
    }
    
    public func setHeaderText(text: String) {
        headerText.text = text
    }
    
    public func setDetailsText(text: String) {
        detailsText.text = text
    }
    
    func moveToRight() {
        leftConstraint.constant = 100
        rightConstraint.constant = 0
    }
    
    func changeCornerRadiusForNotUserMessages() {
        cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }

    // Change the length of the message depending on the length of the text
    func correctLength(length: Int) {
        if UIScreen.main.bounds.size.width > 320 {
            leftConstraint.constant = CGFloat(0)
            rightConstraint.constant = CGFloat(max(270 - 10 * length, 100))
            isMessageFromUser = true
        }
    }
}
