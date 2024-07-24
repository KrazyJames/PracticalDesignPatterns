import Foundation

protocol Publisher<T> {
    associatedtype T
    func add(subscriptor: any Subscriber<T>)
    func publish(new: T)
}

protocol Subscriber<T> {
    associatedtype T
    func update(with new: T)
}

class NumberPublisher: Publisher {
    typealias T = Numeric
    private var subscribers: [any Subscriber<T>] = .init()
    private var number: (any T)?

    func add(subscriptor: any Subscriber<T>) {
        self.subscribers.append(subscriptor)
    }

    func publish(new: any T) {
        subscribers.forEach { subscriber in
            subscriber.update(with: new)
        }
    }
}

class NumberSubscriber: Subscriber {
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

struct News {
    let title: String
    let content: String
}

class NewsPublisher: Publisher {
    typealias T = News
    private var subscribers: [any Subscriber<T>] = .init()
    private var new: (T)?

    func add(subscriptor: any Subscriber<News>) {
        self.subscribers.append(subscriptor)
    }

    func publish(new: News) {
        subscribers.forEach { subscriber in
            subscriber.update(with: new)
        }
    }
}

class NewsSubscriber: Subscriber {
    typealias T = News
    private var news: T?

    func update(with new: News) {
        debugPrint("New news recieved: \(new.title); \(new.content)")
    }
}

let news = News(
    title: "2024 CrowdStrike incident",
    content: "On 19 July 2024, a faulty update to security software produced by CrowdStrike, an American cybersecurity company, caused widespread problems as computers and virtual machines running Microsoft Windows crashed and were unable to properly restart."
)

let cnn = NewsPublisher()
let customer = NewsSubscriber()

cnn.add(subscriptor: customer)
cnn.publish(new: news)
