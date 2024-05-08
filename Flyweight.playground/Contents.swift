import UIKit

// MARK: - Flyghtweight design pattern
/// Saves memory by sharing common data among common objects
/// We need to identify the inmutable (intrinsic) state from the mutable (extrinsic)
/// The intrinsic state is the one that will be shared

// MARK: - Pitfalls
/// - Make sure there's only one intrinsic state object (use a flyweight factory or singleton)


class SharedSpaceship {
    private let mesh: [Float]
    private let texture: UIImage?

    init(mesh: [Float], imageName: String) {
        self.mesh = mesh
        self.texture = .init(named: imageName)
    }
}

class Spaceship {
    private let position: (x: Int, y: Int, z: Int)
    private var intrisicState: SharedSpaceship

    init(
        sharedData: SharedSpaceship,
        position: (x: Int, y: Int, z: Int) = (0, 0, 0)
    ) {
        self.intrisicState = sharedData
        self.position = position
    }
}

let fleetSize = 1_000
var ships: [Spaceship] = .init()
var vertices = [Float](repeating: .zero, count: 1_000)

let sharedData = SharedSpaceship(mesh: vertices, imageName: "Spaceship")

/// Now the same reference to the intrinsic state is used in the 1,000 instances of the Scpaceship, reducing the memory used by loading the texture 1 time
for _ in 0..<fleetSize {
    let ship = Spaceship(
        sharedData: sharedData,
        position: (
            x: Int.random(in: 1..<1_000),
            y: Int.random(in: 1..<1_000),
            z: Int.random(in: 1..<1_000)
        )
    )
    ships.append(ship)
}
