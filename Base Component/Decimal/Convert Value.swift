import Foundation

extension Decimal {
    var stringValue: String {
        get {
            return NSDecimalNumber(decimal: self).stringValue
        }
    }

    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }

    var intValue: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}
