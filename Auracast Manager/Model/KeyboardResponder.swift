//
//  KeyboardResponder.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/3.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published private(set) var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { $0.keyboardHeight },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .subscribe(on: RunLoop.main)
        .assign(to: \.currentHeight, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

