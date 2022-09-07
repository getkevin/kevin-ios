//
//  EmptyStateCell.swift
//  kevin.iOS
//
//  Created by Arthur Alehna on 01/09/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import UIKit

class EmptyStateCell: UITableViewCell {
    
    private let emptyStateView = KevinEmptyStateView()
    private let containerView = UIView()
    private var heightConstaint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emptyStateView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emptyStateView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        heightConstaint = containerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint?.isActive = true
    }
    
    func setup(with selectedCountry: String, heightToOccupy: CGFloat) {
        let countryName = "country_name_\(selectedCountry)".localized(for: Kevin.shared.locale.identifier)
        emptyStateView.country = countryName
        heightConstaint?.constant = heightToOccupy - 200
        layoutIfNeeded()
    }
}
