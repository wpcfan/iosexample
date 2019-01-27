import Foundation
import RxSwift

public protocol LoadingDataConvertible {
    /// Type of element in event
    associatedtype ElementType
    
    /// Event representation of this instance
    var data: Event<ElementType>? { get }
    var loading: Bool { get }
}

public struct LoadingResult<E>: LoadingDataConvertible {
    public let data: Event<E>?
    public let loading: Bool
    
    public init(_ loading: Bool) {
        self.data = nil
        self.loading = loading
    }
    
    public init(_ data: Event<E>) {
        self.data = data
        self.loading = false
    }
}

extension ObservableType {
    public func monitorLoading() -> Observable<LoadingResult<E>> {
        return self.materialize()
            .map(LoadingResult.init)
            .startWith(LoadingResult(true))
    }
}

extension ObservableType where E: LoadingDataConvertible {
    public func loading() -> Observable<Bool> {
        return self
            .map { $0.loading }
    }
    
    public func data() -> Observable<E.ElementType> {
        return self
            .events()
            .elements()
    }
    
    public func errors() -> Observable<Error> {
        return self
            .events()
            .errors()
    }
    
    // MARK: - Private
    private func events() -> Observable<Event<E.ElementType>> {
        return self
            .filter { !$0.loading }
            .map { $0.data }
            .unwrap()
    }
}
