import Foundation

enum Color: String, CaseIterable {
    case green, yellow, red, black
    var color: String {
        self.rawValue.capitalized
    }
}

protocol Light {
    var color: Color { get }
    func start(trafficLight: TrafficLight) async throws
}

class TrafficLight {
    var current: Light

    init(current: Light) {
        self.current = current
    }

    func start() async throws {
        try await current.start(trafficLight: self)
    }

    func stop() async throws {
        self.current = Black()
    }

    func change(to light: Light) async throws {
        debugPrint("Changing to new light \(light.color)")
        try await light.start(trafficLight: self)
        self.current = light
    }
}

struct Black: Light {
    var color: Color = .black
    func start(trafficLight: TrafficLight) async throws {
        return
    }
}

struct Green: Light {
    let color: Color = .green
    private let clock = ContinuousClock()

    func start(trafficLight: TrafficLight) async throws {
        try await clock.sleep(for: .seconds(10))
        try await trafficLight.change(to: Yellow())
    }
}

struct Yellow: Light {
    let color: Color = .yellow
    private let clock = ContinuousClock()

    func start(trafficLight: TrafficLight) async throws {
        try await clock.sleep(for: .seconds(2))
        try await trafficLight.change(to: Red())
    }
}

struct Red: Light {
    let color: Color = .red
    private let clock = ContinuousClock()

    func start(trafficLight: TrafficLight) async throws {
        try await clock.sleep(for: .seconds(5))
        try await trafficLight.change(to: Green())
    }
}

let trafficLight = TrafficLight(current: Red())
Task {
    do {
        try await trafficLight.start()
    } catch {
        debugPrint(error.localizedDescription)
    }
}
