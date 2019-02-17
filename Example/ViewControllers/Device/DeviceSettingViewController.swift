//
//  DeviceSettingViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/17.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Eureka

class DeviceSettingViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateTimeRow.defaultCellSetup = { cell, row in
            cell.datePicker.locale = Locale(identifier: "zh_CN")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        form
            +++ Section(footer: "")
            <<< PushRow<String>() {
                $0.title = "设备名称"
            }
        
    }
}
