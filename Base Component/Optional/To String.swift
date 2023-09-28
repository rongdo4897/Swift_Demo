import Foundation

extension Optional where Wrapped == Int {
    func toString() -> String? {
        guard let value = self else {
            return nil
        }

        return String(value)
    }
}

extension Optional where Wrapped == Int64 {
    func toString() -> String? {
        guard let value = self else {
            return nil
        }

        return String(value)
    }
}
