import UIKit

// MARK: - Flyghtweight design pattern
/// Saves memory by sharing common data among common objects
/// We need to identify the inmutable (intrinsic) state from the mutable (extrinsic)
/// The intrinsic state is the one that will be shared

// MARK: - Pitfalls
/// - Make sure there's only one intrinsic state object (use a flyweight factory or singleton)

class Spaceship {
    private let mesh: [Float]
    private let texture: UIImage?
    private let position: (x: Int, y: Int, z: Int)

    init(
        mesh: [Float],
        imageName: String,
        position: (x: Int, y: Int, z: Int) = (0, 0, 0)
    ) {
        self.mesh = mesh
        self.texture = .init(named: imageName)
        self.position = position
    }
}

let fleetSize = 1_000
var ships: [Spaceship] = .init()
var vertices = [Float](repeating: .zero, count: 1_000)

/// Loading 1,000 times the image can cause memory issues
for _ in 0..<fleetSize {
    let ship = Spaceship(
        mesh: vertices,
        imageName: "Spaceship",
        position: (
            x: Int.random(in: 1..<1_000),
            y: Int.random(in: 1..<1_000),
            z: Int.random(in: 1..<1_000)
        )
    )
    ships.append(ship)
}
