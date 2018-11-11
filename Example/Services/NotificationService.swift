//
//  NotificationService.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift

class NotificationService {
    func addTag(_ tag: String) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            JPUSHService.addTags([tag], completion: { (res, tags, seq) in
                if (res == 0) {
                    observer.onNext(tag)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tag not add", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func addTags(_ tags: [String]) -> Observable<[String]> {
        return Observable.create({ (observer) -> Disposable in
            let tagSet = Set(tags)
            #if TARGET_CPU_ARM
            JPUSHService.addTags(tagSet, completion: { (res, tag_set, seq) in
                if (res == 0) {
                    observer.onNext(Array(tag_set!) as! [String])
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tag not add", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func deleteTag(_ tag: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            JPUSHService.deleteTags([tag], completion: { (res, tags, seq) in
                if (res == 0) {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tag not deleted", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func deleteTags(_ tags: [String]) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            let tagSet = Set(tags)
            JPUSHService.deleteTags(tagSet, completion: { (res, tag_set, seq) in
                if (res == 0) {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tags not deleted", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func cleanTags() -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            JPUSHService.cleanTags({ (res, tag_set, seq) in
                if (res == 0) {
                    observer.onNext(())
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tags not cleaned", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func getAllTags() -> Observable<[String]> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            JPUSHService.getAllTags({ (res, tag_set, seq) in
                if (res == 0) {
                    let allTags = Array(tag_set ?? []) as! [String]
                    observer.onNext(allTags)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "tags not cleaned", code: res, userInfo: ["seq": seq]))
                }
            }, seq: 1)
            #endif
            return Disposables.create()
        })
    }
    
    func setMobile(_ mobile: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            #if TARGET_CPU_ARM
            JPUSHService.setMobileNumber(mobile) { err in
                if (err != nil) {
                    printError("mobile not set \(String(describing: err))")
                    observer.onError(err!)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            #endif
            return Disposables.create()
        })
    }
}
