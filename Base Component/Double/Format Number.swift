import Foundation

extension Double {
    func format(locale: String = "en_US", minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 0, minimumIntegerDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.minimumIntegerDigits = minimumIntegerDigits
        formatter.locale = NSLocale(localeIdentifier: locale) as Locale
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
