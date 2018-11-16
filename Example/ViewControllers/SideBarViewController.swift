//
//  SideBarViewController.swift
//  Example
//
import URLNavigator
import Layout

class SideBarViewController: BaseViewController {
    private let CELL_REUSE_IDENTIFIER = "sidebarCell"
    private let navigator = container.resolve(NavigatorType.self)!
    @objc var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: CELL_REUSE_IDENTIFIER)
        }
    }
}

extension SideBarViewController: UITableViewDataSource {
    // Section Header Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    // rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    // dequeue cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER,   for: indexPath as IndexPath)
        cell.textLabel?.text = "Article \(indexPath.row)"
        return cell
    }
}

extension SideBarViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "SideBarViewController.xml")
    }
}
