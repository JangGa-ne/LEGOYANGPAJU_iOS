//
//  UIKoreanDeletingTextField.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/27.
//

import UIKit

class UIKoreanDeletingTextField: UITextField {
    
    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        if let inputMethod = textInputMode?.primaryLanguage, inputMethod == "ko" {
            return false
        } else {
            return true
        }
    }
}
