//
//  KevinModalView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct KevinModalView<T: View>: UIViewControllerRepresentable {
    
    let view: T
    let canDismissSheet: Bool
    let onDismissalAttempt: (() -> ())?

    func makeUIViewController(context: Context) -> ModalHostingController<T> {
        let controller = ModalHostingController(rootView: view)
        controller.canDismissSheet = canDismissSheet
        controller.onDismissalAttempt = onDismissalAttempt
        return controller
    }

    func updateUIViewController(_ uiViewController: ModalHostingController<T>, context: Context) {
        uiViewController.rootView = view
        uiViewController.canDismissSheet = canDismissSheet
        uiViewController.onDismissalAttempt = onDismissalAttempt
    }
}

class ModalHostingController<Content: View>: UIHostingController<Content>, UIAdaptivePresentationControllerDelegate {
    
    var canDismissSheet = true
    var onDismissalAttempt: (() -> ())?

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        parent?.presentationController?.delegate = self
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        canDismissSheet
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        onDismissalAttempt?()
    }
}

extension View {
   
    func presentation(canDismissSheet: Bool, onDismissalAttempt: (() -> ())? = nil) -> some View {
        KevinModalView(
            view: self,
            canDismissSheet: canDismissSheet,
            onDismissalAttempt: onDismissalAttempt
        ).edgesIgnoringSafeArea(.all)
    }
}
