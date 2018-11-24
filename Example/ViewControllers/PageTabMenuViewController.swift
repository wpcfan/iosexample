//
//  PageTabMenuViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/18.
//  Copyright © 2018 twigcodes. All rights reserved.
//

class PageTabMenuViewController: PageMenuController {
    var pageIndex: Int?
    
    
    let titles: [String]
    
    init(titles: [String], options: PageMenuOptions? = nil) {
        self.titles = titles
        super.init(options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        if options.layout == .layoutGuide && options.tabMenuPosition == .bottom {
            self.view.backgroundColor = Color.primary!
        } else {
            self.view.backgroundColor = .white
        }
        
        if self.options.tabMenuPosition == .custom {
            self.view.addSubview(self.tabMenuView)
            self.tabMenuView.translatesAutoresizingMaskIntoConstraints = false
            self.tabMenuView.snp.makeConstraints {
                $0.height.equalTo(self.options.menuItemSize.height)
                $0.left.right.bottom.equalToSuperview()
            }
        }
        
        self.delegate = self
        self.dataSource = self
    }
}

extension PageTabMenuViewController: PageMenuControllerDataSource {
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
//        return self.items.map(ChildViewController())
        let vc1 = UIViewController().then {
            $0.view.backgroundColor = UIColor.green
        }
        let vc2 = UIViewController().then {
            $0.view.backgroundColor = UIColor.red
        }
        return [vc1, vc2]
    }
    
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return self.titles
    }
    
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
}

extension PageTabMenuViewController: PageMenuControllerDelegate {
    func pageMenuController(_ pageMenuController: PageMenuController, didScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
        // The page view controller will begin scrolling to a new page.
        print("didScrollToPageAtIndex index:\(index)")
    }
    
    func pageMenuController(_ pageMenuController: PageMenuController, willScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
        // The page view controller scroll progress between pages.
        print("willScrollToPageAtIndex index:\(index)")
    }
    
    func pageMenuController(_ pageMenuController: PageMenuController, scrollingProgress progress: CGFloat, direction: PageMenuNavigationDirection) {
        // The page view controller did complete scroll to a new page.
        print("scrollingProgress progress: \(progress)")
    }
    
    func pageMenuController(_ pageMenuController: PageMenuController, didSelectMenuItem index: Int, direction: PageMenuNavigationDirection) {
        print("didSelectMenuItem index: \(index)")
    }
}
