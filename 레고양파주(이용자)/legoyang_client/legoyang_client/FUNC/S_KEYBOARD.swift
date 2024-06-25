//
//  setKeyboard.swift
//  APT
//
//  Created by 장 제현 on 2021/04/19.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    func setKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
/// 키보드 나타남
    @objc func KEYBOARD_SHOW(_ sender: Notification) {
        
        let s = sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        let rect = (s! as AnyObject).cgRectValue

        let keyboardFrameEnd = view!.convert(rect!, to: nil)
        view.frame = CGRect(x: 0, y: 0, width: keyboardFrameEnd.size.width, height: keyboardFrameEnd.origin.y)
        view.layoutIfNeeded()
    }
    
/// 키보드 사라짐
    @objc func KEYBOARD_HIDE(_ sender: Notification) {
        
        let s = sender.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        let rect = (s! as AnyObject).cgRectValue
        
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height + rect!.height)
        view.layoutIfNeeded()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done { textField.resignFirstResponder() }; return true
    }
    
    func hideKeyboardWhenTappedAround(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) { view.endEditing(true) }
    
///화면 다른곳 터치하면 키보드 내려짐
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
