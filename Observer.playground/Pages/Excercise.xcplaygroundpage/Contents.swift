import Foundation

struct News: Hashable {
    let title: String
    let content: String
}

class NewsPublisher: Publisher {
    typealias T = News
    typealias Subscriptor = NewsSubscriber

    private var subscribers: Set<Subscriptor> = .init()
    private var new: T?

    func add(subscriptor: Subscriptor) {
        self.subscribers.insert(subscriptor)
    }

    func remove(subscriptor: Subscriptor) {
        self.subscribers.remove(subscriptor)
    }

    func publish(new: T) {
        self.new = new
        subscribers.forEach { subscriber in
            subscriber.update(with: new)
        }
    }
}

class NewsSubscriber: Identifiable, Subscriber {
    typealias T = News

    let id = UUID()
    private var news: T?

    func update(with new: T) {
        debugPrint("New news recieved: \(new.title); \(new.content)")
    }
}

extension NewsSubscriber: Equatable, Hashable {
    static func == (lhs: NewsSubscriber, rhs: NewsSubscriber) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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

let anotherNew = News(
    title: "DeepSeek shakes up AI sector",
    content: "A new open-source artificial intelligence (AI) model developed by Chinese start-up DeepSeek sent waves through the global tech community last month, offering similar performance to other leading models at a fraction of the cost."
)

cnn.remove(subscriptor: customer)
cnn.publish(new: anotherNew)
