//
//  ShortcutParser.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//
import UIKit

enum ShortcutKey: String {
    case activity = "com.twigcodes.activity"
    case messages = "com.twigcodes.messages"
}

class ShortcutParser {
    static let shared = ShortcutParser()
    private init() { }
    
    func registerShortcuts() {
        let activityIcon = UIApplicationShortcutIcon(templateImageName: "Scan")
        let activityShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.activity.rawValue,
                                                             localizedTitle: "shortcuts.scan.title".localized,
                                                             localizedSubtitle: nil,
                                                             icon: activityIcon,
                                                             userInfo: nil)
        
        let messageIcon = UIApplicationShortcutIcon(templateImageName: "Task")
        let messageShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.messages.rawValue,
                                                            localizedTitle: "shortcuts.task.title".localized,
                                                            localizedSubtitle: nil,
                                                            icon: messageIcon,
                                                            userInfo: nil)
        
        UIApplication.shared.shortcutItems = [activityShortcutItem, messageShortcutItem]
    }
    
    func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> DeeplinkType? {
        switch shortcut.type {
        case ShortcutKey.activity.rawValue:
            return  .activity
        case ShortcutKey.messages.rawValue:
            return  .messages
        default:
            return nil
        }
    }
}
