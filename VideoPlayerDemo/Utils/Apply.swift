import Foundation

protocol WithApply {}

extension WithApply {
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
}

extension NSObject : WithApply {}
