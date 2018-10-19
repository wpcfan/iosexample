//
//  AuthFlow.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

//import RxFlow
//import ReactorKit
//
//class AuthFlow: Flow {
//
//    private let rootViewController = UINavigationController()
//
//    var root: Presentable {
//        return self.rootViewController
//    }
//
//    func navigate(to step: Step) -> NextFlowItems {
//
//        guard let step = step as? AuthStep else { return NextFlowItems.none }
//
//        switch step {
//
//        case .splash:
//            return navigateToSplashScreen()
//        case .tourGuide:
//            return navigateToTourScreen()
//        case .login:
//            return navigateToLoginScreen()
//        case .mainScreen:
//            return navigateToMainScreen()
//        default:
//            return NextFlowItems.none
//        }
//    }
//
//    private func navigateToSplashScreen () -> NextFlowItems {
//        let viewController = SplashViewController()
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: stepper))
//    }
//
//    private func navigateToTourScreen () -> NextFlowItems {
//        let viewController = TourViewController()
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
//    }
//
//    private func navigateToLoginScreen() -> NextFlowItem {
//        let viewController = AuthViewController()
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewModel))
//    }
//
//    private func navigateToMainScreen () -> NextFlowItems {
//        let viewController = HomeTabViewController(tabName: "home")
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.none
//    }
//}
