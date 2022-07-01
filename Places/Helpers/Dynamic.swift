//
// Created by Dossymkhan Zhulamanov on 01.07.2022.
//

import UIKit

class Dynamic<T> {
    typealias Listener = (T) -> ()
    private var listeners: [Listener] = []
    init(_ v: T) {
        value = v
    }
    var value: T {
        didSet {
            for l in listeners { l(value) } }
    }
    func bind(listener: @escaping Listener) {
        listeners.append(listener)
        listener(value)
    }
    func addListener(listener: @escaping Listener) {
        listeners.append(listener)
    }
}
