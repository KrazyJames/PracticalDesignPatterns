import Foundation

public protocol Subscriber<T>: Identifiable, Hashable {
    associatedtype T
    var id: UUID { get }
    func update(with new: T)
}
