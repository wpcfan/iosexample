//
//  HomeUITableViewDataSource.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

class HomeUITableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = (indexPath.row % 2 == 0) ? "templateCell" : "standaloneCell"
        let node = tableView.dequeueReusableCellNode(withIdentifier: identifier, for: indexPath)
//        let image = images[indexPath.row % images.count]!
//
//        node.setState([
//            "row": indexPath.row,
//            "image": image,
//            "whiteImage": image.withRenderingMode(.alwaysOriginal),
//            ])
        
        return node.view as! UITableViewCell
    }
}
