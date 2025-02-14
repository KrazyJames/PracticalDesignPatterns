import Foundation

public protocol Publisher<T> {
    associatedtype T
    associatedtype Subscriptor
    func add(subscriptor: Subscriptor)
    func remove(subscriptor: Subscriptor)
    func publish(new: T)
}
