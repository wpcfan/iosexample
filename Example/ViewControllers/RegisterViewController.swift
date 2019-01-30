//
//  RegisterViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/8.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import Eureka
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
                $0.title = "register.usernamefield.title".localized
                $0.placeholder = "register.usernamefield.placeholder".localized
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "register.usernamefield.validation.required".localized) : nil
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
                $0.title = "register.passwordfield.title".localized
                $0.placeholder = "register.passwordfield.placeholder".localized
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "register.passwordfield.validation.required".localized) : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            
            
            +++ Section(header: "register.person.section".localized, footer: "")
            <<< DateRow() {
                $0.title = "register.birthdayfield.title".localized
                $0.minimumDate = formatter.date(from: "1920-01-01")
                $0.maximumDate = Date()
            }
            
            <<< PushRow<String>() { //1
                $0.title = "register.genderfield.title".localized //2
                $0.selectorTitle = "register.genderselector.title".localized
                $0.options = [
                    "register.genderfield.male".localized,
                    "register.genderfield.female".localized]
            }
        
    }
}
