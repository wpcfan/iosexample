//
//  HomePageViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import Pageboy
import Layout
import RxSwift
import RxCocoa

protocol TableViewPage {
    var tableView: UITableView? { get set }
}

class HomePageViewController: PageboyViewController, StackContainable {
    let vc1 = DeviceListViewController()
    let vc2 = SceneListViewController()
    let pageSwitched = PublishSubject<Void>()
    var tableView: UITableView?
    lazy var viewControllers: [UIViewController] = [vc1, vc2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        let index = currentIndex ?? 0
        self.tableView = (viewControllers[index] as! TableViewPage).tableView
        return .scroll(self.tableView!, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}

extension HomePageViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        self.tableView = (viewControllers[index] as! TableViewPage).tableView
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

extension HomePageViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        pageSwitched.onNext(())
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        
    }
}

extension Reactive where Base: HomePageViewController {
    var pageSwitched: Observable<Void> {
        return base.pageSwitched.asObservable()
    }
}
