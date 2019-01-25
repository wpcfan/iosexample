import Foundation
import RxSwift

enum SessionDataEvents {
	case didReceiveResponse(session: URLSessionType, dataTask: URLSessionDataTaskType, response: URLResponse,
		completion: (URLSession.ResponseDisposition) -> Void)
	case didReceiveData(session: URLSessionType, dataTask: URLSessionDataTaskType, data: Data)
	case didCompleteWithError(session: URLSessionType, dataTask: URLSessionTaskType, error: Error?)
	case didBecomeInvalidWithError(session: URLSessionType, error: Error?)
}

protocol NSURLSessionDataEventsObserverType {
	var sessionEvents: Observable<SessionDataEvents> { get }
}

extension NSURLSessionDataEventsObserver : NSURLSessionDataEventsObserverType {
	var sessionEvents: Observable<SessionDataEvents> {
		return sessionEventsSubject
	}
}

final class NSURLSessionDataEventsObserver : NSObject {
	internal let sessionEventsSubject = PublishSubject<SessionDataEvents>()
}

extension NSURLSessionDataEventsObserver : URLSessionDataDelegate {
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
	                completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		sessionEventsSubject.onNext(.didReceiveResponse(session: session, dataTask: dataTask, response: response, completion: completionHandler))
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		sessionEventsSubject.onNext(.didReceiveData(session: session, dataTask: dataTask, data: data))
	}
}
extension NSURLSessionDataEventsObserver : URLSessionDelegate {
	func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
		sessionEventsSubject.onNext(.didBecomeInvalidWithError(session: session, error: error))
	}
    
    /**
        处理自签名 SSL 证书
     */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            print(challenge.protectionSpace.host)
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
        
    }
}
extension NSURLSessionDataEventsObserver : URLSessionTaskDelegate {	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		sessionEventsSubject.onNext(.didCompleteWithError(session: session, dataTask: task, error: error))
	}
}
