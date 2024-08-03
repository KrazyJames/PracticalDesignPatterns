import Foundation

class Context {
    private var state: State

    init(state: State) {
        self.state = state
    }

    func transition(to state: State) {
        debugPrint("transitioning to state \(state)")
        self.state = state
        self.state.update(context: self)
    }
}

extension Context: CustomStringConvertible {
    var description: String {
        "\(state)"
    }
}

protocol State {
    func update(context: Context)
    func handle()
}

class ConcreteState: State {
    private(set) weak var context: Context?

    func update(context: Context) {
        debugPrint("new context with state \(context)")
        self.context = context
    }

    func handle() {
        debugPrint(#function)
    }
}

class ConcreteStateB: ConcreteState {
    override func handle() {
        debugPrint("ConcreteB handle")
    }
}

class ConcreteStateA: ConcreteState {
    override func handle() {
        debugPrint("ConcreteA handle")
    }
}

let aState = ConcreteStateA()
let bState = ConcreteStateB()

aState.handle()

let context = Context(state: aState)

context.transition(to: bState)
context.transition(to: aState)
