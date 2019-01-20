import Foundation
import RxSwift

public enum HttpMethod: String {
	case options = "OPTIONS"
	case get     = "GET"
	case head    = "HEAD"
	case post    = "POST"
	case put     = "PUT"
	case patch   = "PATCH"
	case delete  = "DELETE"
	case trace   = "TRACE"
	case connect = "CONNECT"
}

public protocol HttpClientType : class {
	/**
	Creates streaming observable for request
	- parameter request: URL request
	- parameter dataCacheProvider: Cache provider, that will be used to cache downloaded data
	- returns: Created observable that emits stream events
	*/
	func request(_ request: URLRequest, dataCacheProvider: DataCacheProviderType?) -> Observable<StreamTaskEvents>
	/**
	Creates StreamDataTask
	- parameter taskUid: String, that may be used as unique identifier of the task
	- parameter request: URL request
	- parameter dataCacheProvider: Cache provider, that will be used to cache downloaded data
	- returns: Created data task
	*/
	func createStreamDataTask(taskUid: String, request: URLRequest, dataCacheProvider: DataCacheProviderType?) -> StreamDataTaskType
	
    /// Cache provider for GET URL requests
	var urlRequestCacheProvider: UrlRequestCacheProviderType? { get }
}
