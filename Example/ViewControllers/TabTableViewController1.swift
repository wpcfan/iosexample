//
//  TabTableViewController1.swift
//  Example
//
//  Created by 王芃 on 2018/11/23.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import Layout

class TabTableViewController1: BaseViewController, TopTabContent, LayoutLoading {
    var pageIndex: Int?
    
    @objc var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "TabTableViewController1.xml")
    }
}

extension TabTableViewController1: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = tableView.dequeueReusableCellNode(withIdentifier: "cell", for: indexPath)
        
        node.setState([
            "row": indexPath.row
            ])
        
        return node.view as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 500
    }
}
