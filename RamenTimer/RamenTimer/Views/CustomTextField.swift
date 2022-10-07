//
//  CustomTextField.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/10/04.
//

import UIKit


class CustomTextfield: UITextField {
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == Selector("copy:") || action == Selector("paste:") {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
