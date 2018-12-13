//
//  InputPresenter.swift
//  Translator
//
//  Created by Маргарита Коннова on 12/12/2018.
//  Copyright © 2018 Margarita Konnova. All rights reserved.
//

import Foundation
import UIKit

class InputPresenter {
    weak fileprivate var inputView: InputView?
    fileprivate let inputModel: Input;
    
    init() {
        inputModel = Input();
    }
    
    func attachView(_ view: InputView){
        inputView = view
    }
    
    func detachView() {
        inputView = nil
    }
    
    func getCurrentBackgroundColor() -> UIColor {
        print(inputModel.getCurrentBackgroundColor())
        return inputModel.getCurrentBackgroundColor()
    }
    
}
