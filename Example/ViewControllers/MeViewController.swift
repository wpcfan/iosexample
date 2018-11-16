//
//  MyViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/4.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import URLNavigator
import Layout

private let images = [
    UIImage(named: "Scan"),
    UIImage(named: "Task"),
]

class MeViewController: BaseViewController {
    
    var leftMenu: UIViewController?
    var leftDrawerTransition: DrawerTransition?
    private let navigator = container.resolve(NavigatorType.self)!
    @objc var layoutNode: LayoutNode? {
        didSet {
            leftMenu = SideBarViewController()
            leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
            leftDrawerTransition?.setPresentCompletion { print("left present...") }
            leftDrawerTransition?.setDismissCompletion { print("left dismiss...") }
            leftDrawerTransition?.edgeType = .left
        }
    }
    
    @objc var collectionView: UICollectionView? {
        didSet {
            collectionView?.registerLayout(
                named: "CollectionCell.xml",
                forCellReuseIdentifier: "standaloneCell"
            )
            collectionView?.registerLayout(
                named: "MeHeaderCell.xml",
                forCellReuseIdentifier: "meHeaderCell"
            )
        }
    }
    
    @objc func navigateToSettings() {
        self.navigator.push("example://me/settings")
    }
}

extension MeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 500
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (indexPath.row % 2 == 0) ? "meHeaderCell" : "standaloneCell"
        let node = collectionView.dequeueReusableCellNode(withIdentifier: identifier, for: indexPath)
        let image = images[indexPath.row % images.count]!
        
        node.setState([
            "row": indexPath.row,
            "image": image,
            "whiteImage": image.withRenderingMode(.alwaysOriginal),
            ])
        
        return node.view as! UICollectionViewCell
    }
}

extension MeViewController: UICollectionViewDelegate {
    
}

extension MeViewController: DrawerTransitionDelegate {
    @objc func toggle()  {
        self.leftDrawerTransition?.presentDrawerViewController(animated: true)
    }
}
