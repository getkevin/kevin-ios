//
//  PaymentConfirmationControllerRepresentable.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import SwiftUI
import Kevin

struct KevinViewControllerRepresentable: UIViewControllerRepresentable {
    
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
