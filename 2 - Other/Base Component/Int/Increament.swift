import Foundation

extension Int {
    mutating func increment() -> Int {
        self += 1
        return self
    }
}
