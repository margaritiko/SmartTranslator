//
//  MessagesModel.swift
//  Translator
//
//  Created by Маргарита Коннова on 16/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var notTranslatedText: String
    var translatedText: String
    
    init(notTranslatedText: String, translatedText: String) {
        self.notTranslatedText = notTranslatedText
        self.translatedText = translatedText
    }
}
