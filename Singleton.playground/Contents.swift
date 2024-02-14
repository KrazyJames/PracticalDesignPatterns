import UIKit


// MARK: - Usage

/// Access and manage a single source
///
/// Examples:
/// -UIApplication
/// -Logger
///

// MARK: - Misusage

/// - Using the singleton as a global multipurpose container
/// It breaks the Single Responsability SOLID principle
///
/// - Singletons might introduce hidden dependencies
///
/// - Problems when accessing non-thread-sage singletons concurrently
/// - Performance problems due to sync

// MARK: - Read-only Singleton

/// Marked as final to prevent sub-classes
final class AppSettings {

    /// Public unique instance
    public static let shared = AppSettings()

    /// To add thread safety using the Readers-writer lock
    /// DispatchQueue solves this with a barrier
    private let concurrentQueue = DispatchQueue(label: "ConcurrentQueueBarrier", attributes: .concurrent)

    /// Private property to avoid external access
    private var settings: [String: Any] = [
        "Theme": "Dark",
        "MaxConcurrentDownloads": 4
    ]

    /// Enusres the initializer can only be used within the class
    private init() { }

    // MARK: - Public methods
    // Reading happens in ordinary in-parallel blocks while writing happens in barrier blocks
    public func string(for key: String) -> String? {
        var result: String?
        concurrentQueue.sync {
            result = settings[key] as? String
        }
        return result
    }

    public func int(for key: String) -> Int? {
        var result: Int?
        concurrentQueue.sync {
            result = settings[key] as? Int
        }
        return result
    }

    public func set(value: Any, for key: String) {
        // The barrier ensures that the queue won't start excecuting until previous tasks are completed, becoming it a serial queue
        concurrentQueue.async(flags: .barrier) {
            self.settings[key] = value
        }
    }
}

class AppDelegate {
    func application() -> Bool {
        if let maxConcurrentDownloads = AppSettings.shared.int(for: "MaxConcurrentDownloads") {
            print("MaxConcurrentDownloads: \(maxConcurrentDownloads)")
        }
        return true
    }
}

class ViewController {
    func viewDidLoad() {
        if let theme = AppSettings.shared.string(for: "Theme") {
            print("Theme: \(theme)")
        }
    }
}

AppDelegate().application()
ViewController().viewDidLoad()

// MARK: - Concurrency issues
import XCTest
final class ConcurrentTester: XCTestCase {
    func testConcurrentUsage() {
        let concurrentQueue = DispatchQueue(label: "ConcurrentQueueTest", attributes: .concurrent)
        let expectation = expectation(description: "Using AppSettings.shared from multiple threads shall succeed")
        let callCount = 100
        for i in 1...callCount {
            concurrentQueue.async {
                AppSettings.shared.set(value: i, for: String(i))
            }
        }
        while AppSettings.shared.int(for: String(callCount)) != callCount {
            print("Not there yet")
        }
        expectation.fulfill()
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Expectation failed")
        }
    }
}

ConcurrentTester().testConcurrentUsage()
