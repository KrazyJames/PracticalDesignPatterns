import Foundation

protocol Clonable: NSCopying {
    associatedtype Prototype: NSCopying
    func clone() -> Prototype
}

class Shape: Clonable {
    func clone() -> Shape {
        copy() as! Shape
    }

    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Shape: CustomStringConvertible {
    var description: String {
        "Shape(x: \(x), y: \(y))"
    }
}

extension Shape: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        Shape(x: x, y: y)
    }
}

class Rectangle: Shape {
    var area: Int {
        x * y
    }
}

class Triangle: Shape {
    var area: Int {
        (x * y) / 2
    }
}

let rect = Rectangle.init(x: 0, y: 2)

var shapes = [Shape]()
for i in 1...100 {
    let copy = rect.clone()
    copy.x = i
    shapes.append(copy)
}

print(shapes)


protocol Vehicle {
    var speed: Measurement<UnitSpeed> { get }
    func run()
}

extension Vehicle {
    func run() {
        print("This vehicle runs at \(speed.formatted(.measurement(width: .abbreviated)))")
    }
}

struct Car: Vehicle {
    var speed: Measurement<UnitSpeed>
}

struct Plane: Vehicle {
    var speed: Measurement<UnitSpeed>
    
    func run() {
        print("This plane flies at \(speed.formatted(.measurement(width: .abbreviated)))")
    }
}

let car = Car(speed: .init(value: 200, unit: .kilometersPerHour))
let plane = Plane(speed: .init(value: 600, unit: .kilometersPerHour))

var car2 = car

car2.speed = .init(value: 100, unit: .milesPerHour)

print(plane, car, car2)
let vehicles: [Vehicle] = [car, car2, plane]

vehicles.forEach { vehicle in
    vehicle.run()
}
