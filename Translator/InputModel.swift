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
    enum TypeOfTranslation {
        case FromRussianToEnglish
        case FromEnglishToRussian
    }
    
    private let colorFromRussianToEnglish = UIColor(red: 220/255, green: 88/255, blue: 96/255, alpha: 255)
    private let colorFromEnglishToRussian = UIColor(red: 47/255, green: 125/255, blue: 225/255, alpha: 255)
    
    private var currentTypeOfTranslation: TypeOfTranslation
    private var backgroundColor: UIColor
    private var textColor: UIColor
    
    private var mainTextField: UITextField?
    
    init(textField: UITextField) {
        currentTypeOfTranslation = TypeOfTranslation.FromEnglishToRussian;
        backgroundColor = colorFromEnglishToRussian;
        textColor = UIColor.white;
        mainTextField = textField;
    }
    
    func getCurrentBackgroundColor() -> UIColor {
        return backgroundColor
    }
}
