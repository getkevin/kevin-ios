//
//  KevinLoaderView.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 14/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

class KevinLoaderView: UIView {
    
    private let dimmedView = UIView()
    private let activityIndicatorContainer = UIView()
    private let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLoader()
    }

    func initLoader() {
        addSubview(dimmedView)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dimmedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dimmedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        dimmedView.addSubview(activityIndicatorContainer)
        activityIndicatorContainer.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        activityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor).isActive = true
        activityIndicatorContainer.centerXAnchor.constraint(equalTo: dimmedView.centerXAnchor).isActive = true
        activityIndicatorContainer.widthAnchor.constraint(equalToConstant: 75).isActive = true
        activityIndicatorContainer.heightAnchor.constraint(equalToConstant: 75).isActive = true
        activityIndicatorContainer.layer.cornerRadius = 10

        activityIndicatorContainer.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        
        activityIndicator.startAnimating()
    }
}
