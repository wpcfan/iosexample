//
//  UnderlinePagerOption.swift
//  Example
//
//  Created by 王芃 on 2018/11/18.
//  Copyright © 2018 twigcodes. All rights reserved.
//

struct UnderlinePagerOption: PageMenuOptions {
    
    var isInfinite: Bool = false
    
    var menuItemSize: PageMenuItemSize {
        return .fixed(width: 100, height: 30)
    }
    
    var menuTitleColor: UIColor {
        return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    }
    
    var menuTitleSelectedColor: UIColor {
        return UIColor.primary!
    }
    
    var menuCursor: PageMenuCursor {
        return .underline(barColor: UIColor.primary!, height: 2)
    }
    
    var font: UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    var menuItemMargin: CGFloat {
        return 8
    }
    
    var tabMenuBackgroundColor: UIColor {
        return .white
    }
    
    public init(isInfinite: Bool = false) {
        self.isInfinite = isInfinite
    }
}
