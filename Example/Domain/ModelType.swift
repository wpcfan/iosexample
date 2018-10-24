//
//  ModelType.swift
//  RxTodo
//
//  Created by Suyeol Jeon on 7/1/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxDataSources

protocol ModelType: Then {
}

extension Collection where Self.Iterator.Element: IdentifiableType {
    
    func index(of element: Self.Iterator.Element) -> Self.Index? {
        return self.index { $0.identity == element.identity }
    }
    
}
