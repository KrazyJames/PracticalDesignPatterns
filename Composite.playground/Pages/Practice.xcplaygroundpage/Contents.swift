import Foundation

protocol View {
    var title: String { get }
    func makeBody(hierarchy: Int) -> String
    mutating func add(_ view: any View)
}

extension View {
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
    
    private var children: [any View] = .init()
    
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

struct Table: View {
    var title: String
    
    private var children: [any View] = .init()
    
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
