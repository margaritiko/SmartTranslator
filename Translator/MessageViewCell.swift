//
//  MessageTableViewCell.swift
//
//
//  Created by Маргарита Коннова on 17/12/2018.
//

import UIKit

class MessageViewCell: UITableViewCell {
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var detailsText: UILabel!
    @IBOutlet weak var cell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setDefaultColor() {
        cell.backgroundColor = UIColor.lightGray
    }
    
    public func setRedColor() {
        cell.backgroundColor = UIColor(red: 220/255, green: 88/255, blue: 96/255, alpha: 255)
    }
    
    public func setBlueColor() {
        cell.backgroundColor = UIColor(red: 47/255, green: 125/255, blue: 225/255, alpha: 255)
    }
    
    public func setHeaderText(text: String) {
        headerText.text = text
    }
    
    public func setDetailsText(text: String) {
        detailsText.text = text
    }
    
}
