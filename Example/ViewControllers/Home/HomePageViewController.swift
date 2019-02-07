//
//  HomePageViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa
import PinLayout

protocol TableViewPage {
    var tableView: UITableView? { get set }
}

class HomePageViewController: UIPageViewController, StackContainable {
    let vc1 = DeviceListViewController()
    let vc2 = SceneListViewController()
    let pageSwitched = PublishSubject<Void>()
    
    lazy var pages: [UIViewController] = {
        return [vc1, vc2]
    }()
    lazy var tableView: UITableView = {
        return (pages[currentIndex] as! TableViewPage).tableView!
    }()
    var currentIndex = 0
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        return .scroll(
            self.tableView,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}

extension HomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil         }
        return pages[nextIndex]
    }
}

extension HomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        guard completed, let viewControllerIndex = pages.index(of: pageViewController.viewControllers!.first!) else {return }
    
        self.currentIndex = viewControllerIndex
        pageSwitched.onNext(())
    }
}

extension Reactive where Base: HomePageViewController {
    var pageSwitched: Observable<Void> {
        return base.pageSwitched.asObservable()
    }
}
