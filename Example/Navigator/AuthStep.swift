//
//  AppStep.swift
//  Example
//
//  Created by 王芃 on 2018/10/14.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import RxFlow

enum AuthStep: Step {
    case apiKey
    case apiKeyIsComplete
    
    case login
    case splash
    case splashComplete
    case tourGuide
    case tourGuideComplete
    
    case mainScreen
}
