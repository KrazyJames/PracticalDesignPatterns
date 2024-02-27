import Foundation

class NameClass {
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension NameClass: CustomStringConvertible {
    var description: String {
        "NameClass(firstName: \"\(firstName)\", lastName: \"\(lastName)\")"
    }
}

let jovana = NameClass(firstName: "Jovana", lastName: "Klass")
let steve = jovana

print(jovana, steve)

steve.firstName = "Steve"
steve.lastName = "Volt"
// Reference type does not come with the prototype behavior by default as structs
print(jovana, steve)

// We need to conform to NSCopying to allow custom copy
extension NameClass: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return NameClass(firstName: self.firstName, lastName: self.lastName)
    }

    func clone() -> Self {
        copy(with: nil) as! Self
    }
}

// Reference types are now able to be cloned as structs do when prototyping
let gio = steve.clone()

gio.firstName = "Giovanny"
gio.lastName = "Voltoroso"

print(jovana, steve, gio)
