//
//  BankHeaderCell.swift
//  kevin.iOS
//
//  Created by Arthur Alehna on 01/09/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//


import UIKit

final internal class BankHeaderCell: UITableViewCell {
    
    private let bankSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "window_bank_selection_select_bank_label".localized(for: Kevin.shared.locale.identifier).uppercased()
        label.font = Kevin.shared.theme.sectionStyle.titleLabelFont
        label.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        addSubview(bankSelectionLabel)
        
        NSLayoutConstraint.activate([
            bankSelectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            bankSelectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            bankSelectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Kevin.shared.theme.insets.left),
            bankSelectionLabel.widthAnchor.constraint(equalTo: widthAnchor),
            bankSelectionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
