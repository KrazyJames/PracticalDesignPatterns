import Foundation

protocol Clonable: NSCopying {
    associatedtype Prototype: NSCopying
    func clone() -> Prototype
}

protocol Vehicle: Clonable {
    var speed: Measurement<UnitSpeed> { get }
    func run()
}

extension Vehicle {
    func run() {
        print("This vehicle runs at \(speed.formatted(.measurement(width: .abbreviated)))")
    }
}

class Car: Vehicle {
    var model: String
    var speed: Measurement<UnitSpeed>

    init(model: String, speed: Measurement<UnitSpeed>) {
        self.model = model
        self.speed = speed
    }

    func clone() -> Car {
        guard let copy = self.copy() as? Car else {
            fatalError("Provide a default value instead")
        }
        return copy
    }

    func copy(with zone: NSZone? = nil) -> Any {
        Car(model: model, speed: speed)
    }
}

class Motorcycle: Vehicle {
    var maker: String
    var speed: Measurement<UnitSpeed>

    init(maker: String, speed: Measurement<UnitSpeed>) {
        self.maker = maker
        self.speed = speed
    }

    func run() {
        print("This motorcycle by \(maker) runs at \(speed.formatted(.measurement(width: .abbreviated)))")
    }

    func clone() -> Motorcycle {
        self.copy() as! Motorcycle
    }

    func copy(with zone: NSZone? = nil) -> Any {
        Motorcycle(maker: maker, speed: speed)
    }
}

let ferrari = Car(
    model: "F40",
    speed: .init(value: 200, unit: .kilometersPerHour)
)
let plane = Motorcycle(maker: "Harley-Davidson", speed: .init(value: 180, unit: .kilometersPerHour))

let lambo = ferrari.clone()

print(ferrari, lambo)

lambo.model = "Revuelto"
lambo.speed = .init(value: 300, unit: .kilometersPerHour)

print(ferrari, lambo)

let vehicles: [any Vehicle] = [ferrari, lambo]

vehicles.forEach { vehicle in
    vehicle.run()
}
