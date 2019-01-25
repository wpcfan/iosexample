//
//  AppData.swift
//  Example
//
//  Created by 王芃 on 2018/10/7.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Foundation

struct AppData: Codable {
    var tourGuidePresented: Bool
    var userId: String
    var houseId: String
    var projectId: String
    init(tourGuidePresented: Bool, userId: String, houseId: String, projectId: String) {
        self.tourGuidePresented = tourGuidePresented
        self.userId = userId
        self.houseId = houseId
        self.projectId = projectId
    }
}
