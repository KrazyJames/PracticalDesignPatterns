import Foundation

protocol Device {
  var name: String { get }
  var cpu: String { get }
}

struct Phone: Device {
    let name: String
    let cpu: String
}

struct Watch: Device {
    let name: String
    let cpu: String
}

struct Laptop: Device {
    let name: String
    let cpu: String
}

enum DeviceType: String, CaseIterable {
    case phone
    case watch
    case laptop
}

class DeviceFactory {
    static func makeDevice(of type: DeviceType) -> any Device {
        switch type {
        case .phone:
            Phone(name: "iPhone 15 Pro", cpu: "A17 Pro")
        case .watch:
            Watch(name: "Apple Watch Ultra 2", cpu: "S9 SiP")
        case .laptop:
            Laptop(name: "MacBook Air", cpu: "M3")
        }
    }
}

class Store {
    var stock: [Device]

    init(stock: [Device]) {
        self.stock = stock
    }
}

let stock: [Device] = DeviceType.allCases.map(DeviceFactory.makeDevice)
let appleStore = Store(stock: stock)
