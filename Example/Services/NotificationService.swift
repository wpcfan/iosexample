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
        print("enter addTag")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
        print("enter addTags")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            let tagSet = Set(tags)
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
        print("enter deleteTag")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
        print("enter deleteTags")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
        print("enter cleanTags")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
        print("enter getAllTags")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
        print("enter setMobile")
        return Observable.create({ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
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
