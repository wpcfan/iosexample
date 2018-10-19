//
//  SplashViewModel.swift
//  Example
//
//  Created by 王芃 on 2018/10/18.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxFlow
import RxSwift

class SplashViewModel: Stepper {
    public func navigateToNextScreen(loggedIn: Bool, needTour: Bool) {
        if (needTour) {
            self.step.accept(AuthStep.tourGuide)
            return
        }
        if (loggedIn) {
            self.step.accept(AuthStep.login)
            return
        }
    }
}
