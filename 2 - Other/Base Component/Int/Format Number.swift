import Foundation

extension Int {
    func format(locale: String = "en_US") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: locale) as Locale
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
