import Foundation

protocol Item {
    var title: String { get }
    func action() -> String
    func add(_ item: any Item)
}

extension Item {
    func add(_ item: any Item) { }
}

class Leaf: Item {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func action() -> String {
        "[Leaf: \(title)]"
    }
}

class Branch: Item {
    var title: String
    
    private var children: [any Item] = .init()
    
    init(title: String) {
        self.title = title
    }
    
    func add(_ item: Item) {
        children.append(item)
    }
    
    func action() -> String {
        var message = "{ \n Branch: \(title)"
        children.forEach { child in
            message.append("\n \(child.action())")
        }
        return message.appending("\n}")
    }
}

let branch1 = Branch(title: "Main")

let branch2 = Branch(title: "Secondary")

let leaf1 = Leaf(title: "Leaf1")
let leaf2 = Leaf(title: "Leaf2")
let leaf3 = Leaf(title: "Leaf3")

branch1.add(leaf1)
branch1.add(leaf2)

print(branch1.action())
print("--------------------")

branch2.add(leaf3)

print(branch2.action())
print("--------------------")

branch1.add(branch2)

print(branch1.action())
