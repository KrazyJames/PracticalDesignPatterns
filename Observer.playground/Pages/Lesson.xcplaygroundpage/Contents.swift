import Foundation

class NumberPublisher: Publisher {
    typealias T = Numeric
    typealias Subscriptor = NumberSubscriber
    private var subscribers: Set<Subscriptor> = .init()
    private var number: (any T)?

    func add(subscriptor: Subscriptor) {
        self.subscribers.insert(subscriptor)
    }

    func remove(subscriptor: Subscriptor) {
        subscribers.remove(subscriptor)
    }

    func publish(new: any T) {
        subscribers.forEach { subscriber in
            subscriber.update(with: new)
        }
    }
}

class NumberSubscriber: Subscriber {
    static func == (lhs: NumberSubscriber, rhs: NumberSubscriber) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: UUID {
        .init()
    }

    typealias T = Numeric
    private var number: (any T)?

    func update(with new: any T) {
        self.number = new
        concreteFunction()
    }

    func concreteFunction() {
        debugPrint("Publisher updated: \(String(describing: number))")
    }
}

let myPublisher = NumberPublisher()
let mySubscriber = NumberSubscriber()

myPublisher.add(subscriptor: mySubscriber)
myPublisher.publish(new: 3)
