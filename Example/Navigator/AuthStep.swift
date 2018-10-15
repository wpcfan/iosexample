//
//  AppStep.swift
//  Example
//
//  Created by 王芃 on 2018/10/14.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import RxFlow

enum AppStep: Step {
    case apiKey
    case apiKeyIsComplete
    
    case movieList
    
    case moviePicked (withMovieId: Int)
    case castPicked (withCastId: Int)
    
    case settings
    case settingsDone
    case about
}
