import UIKit

// MARK: - Decorator
/// - Allows to enhance current types without changing the implementation
/// - Alternative to subclasses
/// - Uses a wrapper
/// - Same interface as the wrapped type
/// - Adds features recursively with decorator composition
/// - Can be implemented by extensions rather than wrapping
///
/// Pitfalls
/// - Added unrealted behavior (Do not break SRP)

class UserDefaultsDecorator: UserDefaults {
    private var wrappedValue: UserDefaults = .standard
    convenience init(userDefaults: UserDefaults = .standard) {
        self.init()
        self.wrappedValue = userDefaults
    }

    func set(date: Date?, for key: String) {
        wrappedValue.setValue(date, forKey: key)
    }

    func date(for key: String) -> Date? {
        wrappedValue.value(forKey: key) as? Date
    }
}

let userDefaults = UserDefaultsDecorator()
userDefaults.set(42, forKey: "the answer")
print(userDefaults.string(forKey: "the answer") ?? "?")

userDefaults.set(date: .now, for: "now")
print(userDefaults.date(for: "now")?.formatted())

// MARK: - With extensions
extension UserDefaults {
    func set(date: Date?, for key: String) {
        self.setValue(date, forKey: key)
    }

    func date(for key: String) -> Date? {
        self.value(forKey: key) as? Date
    }
}

let userDefaultsExtension = UserDefaults.standard
userDefaultsExtension.set(date: .now, for: "now2")
print(userDefaults.date(for: "now2")?.formatted())
