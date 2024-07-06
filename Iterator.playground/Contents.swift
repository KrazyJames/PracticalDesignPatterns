import Foundation

// MARK: - Iterator Design Pattern

/// This design pattern allows to traverse complex data storage structures reducing complexity for client code and upgrading security by hidding the under hood implementation.

// MARK: - Implementation
/// - Declare the iterator interface which must have a fetching method and the current position, optionally the previous element or the end of the iteration as a boolean.
/// - Declare the collection interface which describe the method for retrieving the iterators.
/// - Implement concrete iterators for all the collections to be traversed. An iterator must be linked with a single collection instance.
/// - Implement the collection interface to the collections.

// MARK: - Advanteges
/// - SRP
/// - O/CP
/// - You can iterate over the same collection in parallel with multiple iterators with their own states.
/// - You can delay or stop when needed an iteration because the prev point

// MARK: - Pitfalls
/// - Could be an overkill for simple collection tasks
/// - Less efficiency than other specialized collections available

protocol View {
    var title: String { get }
    var children: [any View] { get }
    func makeBody(hierarchy: Int) -> String
    mutating func add(_ view: any View)
}

extension View {
    var children: [any View] { .init() }
    mutating func add(_ view: any View) { }
}

struct Text: View {
    var title: String

    public init(title: String) {
        self.title = title
    }

    func makeBody(hierarchy: Int) -> String {
        "\(String(repeating: "\t", count: hierarchy))[\(title)]"
    }
}

struct Button: View {
    var title: String

    public init(title: String) {
        self.title = title
    }

    func makeBody(hierarchy: Int) -> String {
        "\(String(repeating: "\t", count: hierarchy))[\(title)]"
    }
}

struct Scroll: View {
    var title: String

    var children: [any View] = .init()

    public init(title: String) {
        self.title = title
    }

    mutating func add(_ view: any View) {
        children.append(view)
    }

    func makeBody(hierarchy: Int) -> String {
        var output = "\(String(repeating: "\t", count: hierarchy))\(title): {\n"
        guard !children.isEmpty else {
            return output.appending("\(String(repeating: "\t", count: hierarchy))}")
        }
        children.forEach { child in
            output.append("\(child.makeBody(hierarchy: hierarchy + 1)),\n")
        }
        return output.appending("\(String(repeating: "\t", count: hierarchy))}")
    }
}

extension Scroll: Sequence {
    func makeIterator() -> some IteratorProtocol {
        ViewIterator(self)
    }
}

struct ViewIterator: IteratorProtocol {
    private let collection: View
    private var index = 0

    init(_ collection: View) {
        self.collection = collection
    }

    mutating func next() -> (any View)? {
        defer { index += 1 }
        return index < collection.children.count ? collection.children[index] : nil
    }
}

struct Table: View {
    var title: String

    var children: [any View] = .init()

    public init(title: String) {
        self.title = title
    }

    mutating func add(_ view: any View) {
        children.append(view)
    }

    func makeBody(hierarchy: Int) -> String {
        var output = "\(String(repeating: "\t", count: hierarchy))\(title): {\n"
        guard !children.isEmpty else {
            return output.appending("\(String(repeating: "\t", count: hierarchy))}")
        }
        children.forEach { child in
            output.append("\(child.makeBody(hierarchy: hierarchy + 1)),\n")
        }
        return output.appending("\(String(repeating: "\t", count: hierarchy))}")
    }
}

extension Table: Sequence {
    func makeIterator() -> AnyIterator<View> {
        var index = 0
        return AnyIterator<View> {
            defer { index += 1 }
            return index < self.children.count ? self.children[index] : nil
        }
    }
}

var table = Table(title: "TableView")
var scroll = Scroll(title: "ScrollView")

let text = Text(title: "TextView")
let button = Button(title: "ButtonView")

scroll.add(text)

table.add(scroll)

table.add(button)

print(table.makeBody(hierarchy: 0))

/// Prints:
/// TableView: {
///  ScrollView: {
///     [TextView],
///  },
/// [ButtonView],
/// }

class Renderer {
    static func render<ViewSequence: Sequence>(views: ViewSequence) {
        for view in views {
            print(view)
        }
    }
}

Renderer.render(views: table)
