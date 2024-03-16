import UIKit

/// Factory Method
/// Creational pattern with loose coupling
/// Creates objects without exposing its type
/// Callers don´t need to know the concrete implementation
///
// MARK: - Benefits
/// - Make changes without affecting the current implementation
/// - Concrete implementation could be replaced

// MARK: - Challenges
/// - Limited to types that share a common protocol or super class

// MARK: - Example

protocol Serializable {
    func serialize()
}

class JSONSerializer: Serializable {
    func serialize() {
        print("JSONSerializer", #function)
    }
}

class PListSerializer: Serializable {
    func serialize() {
        print("PListSerializer", #function)
    }
}

class XMLSerializer: Serializable {
    func serialize() {
        print("XMLSerializer", #function)
    }
}

enum Serializer {
    case json, plist, xml
}

func makeSerializer(_ type: Serializer) -> any Serializable {
    switch type {
    case .json:
        JSONSerializer()
    case .plist:
        PListSerializer()
    case .xml:
        XMLSerializer()
    }
}

let jsonSerializer = makeSerializer(.json)
jsonSerializer.serialize()

// A factory object to make the types could be created to avoid cluttering the global namespace
struct SerializerFactory {
    func makeSerializer(_ type: Serializer) -> any Serializable {
        switch type {
        case .json:
            JSONSerializer()
        case .plist:
            PListSerializer()
        case .xml:
            XMLSerializer()
        }
    }
}
