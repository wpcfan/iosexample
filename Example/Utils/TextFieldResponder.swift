//
//  TFResponder.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class TextFieldResponder: NSObject, UITextFieldDelegate {
    
    static let shared = TextFieldResponder()
    
    var textFields: [UITextField]?
    
    func addResponders(_ TextFieldArray: [UITextField]) {
        textFields = TextFieldArray
        textFields?.forEach({ $0.returnKeyType = .next //setting return key type for all textFields
            $0.delegate = TextFieldResponder.shared }) //setting delegates for all textFields
        textFields?.last?.returnKeyType = .done  //Last index
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Magic code if textfield is last then resign else becomeFirstResponder to next TextField
        var selectedIndex = 0
        for index in 0..<(textFields?.count ?? 0) {
            if textField == textFields?[index] ?? UITextField() {
                selectedIndex = index
            }
        }
        _ = (textField == textFields?.last) ? textField.resignFirstResponder() : textFields?[selectedIndex + 1].becomeFirstResponder()
        return true
    }
}
