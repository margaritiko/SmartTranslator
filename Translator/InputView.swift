//
//  InputView.swift
//  Translator
//
//  Created by Маргарита Коннова on 11/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import UIKit

class InputView: UIView {
    fileprivate let inputPresenter = InputPresenter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        inputPresenter.attachView(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 35;
        self.layer.masksToBounds = true;
        
        self.backgroundColor = inputPresenter.getCurrentBackgroundColor()
    }
}
