import UIKit

// MARK: - Prototype
/// Helps to create multiple instantces of the same type when this actions is expensive
/// E.G. Loading content from disk into memory multiple times, (O)n
/// Instead of loading all of them, cloning would be less expensive

// MARK: - Challenge
/// - When cloning a reference type, it might be expensive
/// - The clones need to be independent

// MARK: - Implementation

struct NameStruct {
    var firstName: String
    var lastName: String
}

/// As the object and its content properties are value types 
/// we get the prototype behavoir for free
/// since they are being copied
var joe = NameStruct.init(firstName: "Joe", lastName: "Doe")
var maria = joe

print(joe, maria)

maria.firstName = "Maria"
maria.lastName = "Marques"

print(joe, maria)
