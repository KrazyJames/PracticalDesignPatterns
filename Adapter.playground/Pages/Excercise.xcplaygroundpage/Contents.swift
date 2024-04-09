import Foundation

enum Connection {
    case usba
    case microb
    case usbc
    case ethernet
    case hdmi
}

protocol Dongle {
    var input: Connection { get }
    var output: Connection { get }
}

class EthernetDongle: Dongle {
    var input: Connection {
        .ethernet
    }

    var output: Connection {
        .usbc
    }
}

class VideoDongle: Dongle {
    var input: Connection {
        .hdmi
    }

    var output: Connection {
        .usbc
    }
}

enum Entry {
    case USBC
    case HDMI
    case Internet
}

class ThirdPartyDongle {
    var entry: Entry {
        .HDMI
    }

    var out: Entry {
        .USBC
    }
}

extension Entry {
    var connection: Connection {
        switch self {
        case .USBC:
            return .usbc
        case .HDMI:
            return .hdmi
        case .Internet:
            return .ethernet
        }
    }
}

class ThirdPartyWrapperAdapter: Dongle {
    var thirdPartyDongle: ThirdPartyDongle

    var input: Connection {
        thirdPartyDongle.entry.connection
    }

    var output: Connection {
        thirdPartyDongle.out.connection
    }
}

extension ThirdPartyDongle: Dongle {
    var input: Connection {
        entry.connection
    }

    var output: Connection {
        out.connection
    }
}
