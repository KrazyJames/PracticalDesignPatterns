import UIKit

/// Adapter design pattern
/// - Easy to implement through *extensions*
/// - No wrapping required
/// - Original implementation remains unchanged

// MARK: - Mistakes
/// No drawbacks
/// - Adapting the wrong type

// MARK: - Benefits

/// Our project's protocol to handle payment gateways
protocol PaymentGateway {
    func receivePayment(amount: Double)
    var totalPayments: Double { get }
}

class Paypal: PaymentGateway {
    var total: Double = .zero

    func receivePayment(amount: Double) {
        total += amount
    }

    var totalPayments: Double {
        print("Total payments received via Paypal: \(total)")
        return total
    }
}

class Stripe: PaymentGateway {
    var total: Double = .zero

    func receivePayment(amount: Double) {
        total += amount
    }

    var totalPayments: Double {
        print("Total payments received via Stripe: \(total)")
        return total
    }
}

let paypal = Paypal()
paypal.receivePayment(amount: 100)

let stripe = Stripe()
stripe.receivePayment(amount: 2.99)

var paymentGateways: [PaymentGateway] = [paypal, stripe]

var total = Double.zero
for gateway in paymentGateways {
    total += gateway.totalPayments
}

/// A third-party class that does not conform to the protocol
class AmazonPayments {
    var payments = 0.0

    func paid(value: Double, currency: String) {
        payments += value
        print("Paid \(currency)\(value) via Amazon Payments")
    }

    func fulfilledTransactions() -> Double {
        payments
    }
}

let amazon = AmazonPayments()
amazon.paid(value: 120, currency: "USD")

/// Create adapter with wrapper
class AmazonPaymentsAdapter: PaymentGateway {
    let amazonPayment: AmazonPayments
    init(amazonPayment: AmazonPayments) {
        self.amazonPayment = amazonPayment
    }

    func receivePayment(amount: Double) {
        amazonPayment.paid(value: amount, currency: "USD")
    }

    var totalPayments: Double {
        let total = amazonPayment.payments
        print("Total payments received via Amazon Payments: \(total)")
        return total
    }
}

let adapter = AmazonPaymentsAdapter(amazonPayment: amazon)

adapter.receivePayment(amount: 74.99)

// paymentGateways.append(adapter)

print(paymentGateways.reduce(into: .zero, { partialResult, next in
    partialResult += next.totalPayments
}))

/// Can create an adapter w/o wrapper
extension AmazonPayments: PaymentGateway {
    func receivePayment(amount: Double) {
        self.paid(value: amount, currency: "USD")
    }

    var totalPayments: Double {
        print("Total payments received via Amazon Payments: \(payments)")
        return payments
    }
}

paymentGateways.append(amazon)
print(paymentGateways.reduce(into: .zero, { partialResult, next in
    partialResult += next.totalPayments
}))
