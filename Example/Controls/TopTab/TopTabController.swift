//
//  TopTabController.swift
//  Example
//
//  Created by 王芃 on 2018/11/24.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import Layout

protocol TopTabContent: class {
    var pageIndex: Int? { get set }
}

struct TopTabItem {
    var index: Int
    var title: String
    var viewController: UIViewController
}

class TopTabController: UIViewController {
    
    var tabItems: [TopTabItem]
    var tabMenuItemSpacing = 10
    var tabMenuMargin = 10
    var tabMenuHeight = 100 {
        didSet {
            layoutNode?.setState(["tabMenuHeight": tabMenuHeight])
        }
    }
    var tabMenuWidth = 300 {
        didSet {
            layoutNode?.setState(["tabMenuWidth": tabMenuWidth])
        }
    }
    @objc var tabMenuView: UIView?
    @objc var scrollView: UIScrollView? {
        didSet {
            scrollView?.addSubview(pageViewController.view)
        }
    }
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    required init(_ tabItems: [TopTabItem]) {
        self.tabItems = tabItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopTabController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing = (tabItems.count - 1) * tabMenuItemSpacing + 2 * tabMenuMargin
        self.layoutNode = LayoutNode(
            view: UIScrollView.self,
            state: ["tabMenuWidth": tabMenuWidth,
                    "tabMenuHeight": tabMenuHeight],
            expressions: [
                "contentInset.top": "safeAreaInsets.top",
                "contentInset.bottom": "safeAreaInsets.bottom",
                "contentInsetAdjustmentBehavior": "never",
                "outlet": "scrollView",
                "scrollIndicatorInsets.bottom": "safeAreaInsets.bottom",
                "scrollIndicatorInsets.top": "safeAreaInsets.top"
            ],
            children: [
                LayoutNode(
                    view: UIView.self,
                    expressions: [
                        "height": "{tabMenuHeight}",
                        "center.x": "parent.center.x",
                        "outlet": "tabMenuView",
                        "top": "parent.top",
                        "width": "{tabMenuWidth}"
                        ],
                    children: tabItems.map({ (item) -> LayoutNode in
                        LayoutNode(
                            view: TabButton.self,
                            expressions: [
                                "color": "blue",
                                "height": "100%",
                                "left": item.index == 0 ? "parent.left + \(tabMenuItemSpacing)" : "previous.right + \(tabMenuItemSpacing)",
                                "title": item.title,
                                "top": "parent.top",
                                "width": "(parent.width - \(spacing)) / \(tabItems.count)"
                            ]
                        )
                    })
                )
            ]
        )
    }
    
    func layoutDidLoad(_: LayoutNode) {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
        pageViewController.gestureRecognizers.forEach {
            self.view.addGestureRecognizer($0)
        }
        pageViewController.isDoubleSided = true
        assert(tabItems.count > 0)
        pageViewController.setViewControllers([tabItems[0].viewController], direction: .forward, animated: true, completion: nil)
    }
}

extension TopTabController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! TopTabContent).pageIndex! + 1
        if (index >= self.tabItems.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! TopTabContent).pageIndex! - 1
        if (index < 0){
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController? {
        if((self.tabItems.count == 0) || (index >= self.tabItems.count)) {
            return nil
        }
        let vc = tabItems[index].viewController
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        return vc
    }
}

extension TopTabController: UIPageViewControllerDelegate {
    
}

extension TopTabController {
    
    open override class var parameterTypes: [String: RuntimeType] {
        return [
            "topTabItems": RuntimeType([TopTabItem].self)
        ]
    }
    
    open override class func create(with node: LayoutNode) throws -> TopTabController {
        guard let tabItems = try node.value(forExpression: "topTabItems") as? [TopTabItem] else {
            throw LayoutError("topTabItems is required")
        }
        return self.init(tabItems)
    }
}
