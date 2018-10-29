//
//  RegisterViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/8.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import Eureka
import SnapKit
import UIKit

class RegisterViewController: FormViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .textIcon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateTimeRow.defaultCellSetup = { cell, row in
            cell.datePicker.locale = Locale(identifier: "zh_CN")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        form
            +++ Section(footer: "")
            <<< TextRow() {
                $0.title = NSLocalizedString("register.usernamefield.title", comment: "")
                $0.placeholder = NSLocalizedString("register.usernamefield.placeholder", comment: "")
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: NSLocalizedString("register.usernamefield.validation.required", comment: "")) : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        row.section?.footer?.title = row.validationErrors.description
                    }
                }
            }
            <<< PasswordRow() {
                $0.title = NSLocalizedString("register.passwordfield.title", comment: "")
                $0.placeholder = NSLocalizedString("register.passwordfield.placeholder", comment: "")
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: NSLocalizedString("register.passwordfield.validation.required", comment: "")) : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            
            
            +++ Section(header: NSLocalizedString("register.person.section", comment: ""), footer: "")
            <<< DateRow() {
                $0.title = NSLocalizedString("register.birthdayfield.title", comment: "")
                $0.minimumDate = formatter.date(from: "1920-01-01")
                $0.maximumDate = Date()
            }
            
            <<< PushRow<String>() { //1
                $0.title = NSLocalizedString("register.genderfield.title", comment: "") //2
                $0.selectorTitle = NSLocalizedString("register.genderselector.title", comment: "")
                $0.options = [
                    NSLocalizedString("register.genderfield.male", comment: ""),
                    NSLocalizedString("register.genderfield.female", comment: "")]
            }
        
    }
}
