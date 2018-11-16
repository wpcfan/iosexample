//
//  SidebarSectionModel.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxDataSources

enum SideBarSectionModel {
    case menu(title: String, items: [SideBarSectionItem])
}

enum SideBarSectionItem {
    case menuItems(items: [MenuItem])
}

extension SideBarSectionModel: SectionModelType {
    typealias Item = SideBarSectionItem
    
    var items: [SideBarSectionItem] {
        switch  self {
        case .menu(title: _, items: let items):
            return items.map {$0}
        }
    }
    
    init(original: SideBarSectionModel, items: [Item]) {
        switch original {
        case let .menu(title, _):
            self = .menu(title: title, items: items)
        }
    }
}

extension SideBarSectionModel {
    var title: String {
        switch self {
        case .menu(title: let title, items: _):
            return title
        }
    }
}

