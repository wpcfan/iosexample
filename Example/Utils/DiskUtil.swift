//
//  DiskUtil.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Disk

struct DiskUtil {
    public static func getData() -> AppData? {
        let data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        return data
    }
    public static func saveUser(user: SmartUser?) {
        var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        data?.user = user
        try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
    }
    public static func saveRegId(regId: String?) {
        var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        if (data == nil) {
            data = AppData(JSON: ["regId": regId ?? ""])
        } else {
            data?.regId = regId
        }
        try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
    }
    public static func saveTourStatus(tourPresented: Bool) {
        var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        data?.tourGuidePresented = tourPresented
        try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
    }
    public static func saveTokenInfo(tokenInfo: TokenInfo) {
        var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        data?.token = tokenInfo.token
        data?.user = tokenInfo.user
        data?.splashAd = tokenInfo.splashAd
        try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
    }
    public static func saveHouseInfo(house: House) {
        var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        data?.houseId = house.id
        data?.projectId = house.projectId
        try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
    }
}
