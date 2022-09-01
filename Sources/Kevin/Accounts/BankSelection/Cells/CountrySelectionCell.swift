//
//  CountrySelectionCell.swift
//  
//
//  Created by Arthur Alehna on 01/09/2022.
//

import UIKit

internal final class CountrySelectionCell: UITableViewCell {
    
    private let countrySelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "window_bank_selection_select_country_label".localized(for: Kevin.shared.locale.identifier).uppercased()
        label.font = Kevin.shared.theme.sectionStyle.titleLabelFont
        label.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let countrySelectionContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Kevin.shared.theme.navigationLinkStyle.cornerRadius
        view.layer.borderWidth = Kevin.shared.theme.navigationLinkStyle.borderWidth
        view.backgroundColor = Kevin.shared.theme.navigationLinkStyle.backgroundColor
        view.layer.borderColor = Kevin.shared.theme.navigationLinkStyle.borderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let countrySelectionIconView = UIImageView()
    private let countrySelectionCountryLabel: UILabel = {
        let label = UILabel()
        label.font = Kevin.shared.theme.navigationLinkStyle.titleLabelFont
        label.textColor = Kevin.shared.theme.generalStyle.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let chevronImage: UIImageView = {
        let chevron = UIImageView(image: Kevin.shared.theme.navigationLinkStyle.chevronImage)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        return chevron
    }()
    private var containerSelectedBakckgroundColor: UIColor {
        Kevin.shared.theme.navigationLinkStyle.selectedBackgroundColor
    }
    private var containerViewBackgroundColor: UIColor {
        Kevin.shared.theme.navigationLinkStyle.backgroundColor
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(countrySelectionLabel)
        addSubview(countrySelectionContainer)
        countrySelectionContainer.addSubview(countrySelectionIconView)
        countrySelectionContainer.addSubview(countrySelectionCountryLabel)
        countrySelectionContainer.addSubview(chevronImage)
        countrySelectionIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countrySelectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Kevin.shared.theme.insets.top),
            countrySelectionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Kevin.shared.theme.insets.left),
            countrySelectionLabel.widthAnchor.constraint(equalTo: widthAnchor),
            countrySelectionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            countrySelectionContainer.topAnchor.constraint(equalTo: countrySelectionLabel.bottomAnchor, constant: 16),
            countrySelectionContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: Kevin.shared.theme.insets.left),
            countrySelectionContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -Kevin.shared.theme.insets.right),
            countrySelectionContainer.heightAnchor.constraint(equalToConstant: 54),
            countrySelectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            countrySelectionIconView.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor),
            countrySelectionIconView.leftAnchor.constraint(equalTo: countrySelectionContainer.leftAnchor, constant: 16),
            countrySelectionIconView.widthAnchor.constraint(equalToConstant: 32),
            countrySelectionIconView.heightAnchor.constraint(equalToConstant: 32),
            
            countrySelectionCountryLabel.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor),
            countrySelectionCountryLabel.leftAnchor.constraint(equalTo: countrySelectionIconView.rightAnchor, constant: 26),
            countrySelectionCountryLabel.widthAnchor.constraint(equalTo: countrySelectionContainer.widthAnchor, multiplier: 0.5),
            countrySelectionCountryLabel.heightAnchor.constraint(equalTo: countrySelectionContainer.heightAnchor),
            
            chevronImage.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor),
            chevronImage.rightAnchor.constraint(equalTo: countrySelectionContainer.rightAnchor, constant: -18),
            chevronImage.widthAnchor.constraint(equalToConstant: 14),
            chevronImage.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = highlighted ? containerSelectedBakckgroundColor : containerViewBackgroundColor
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                self?.countrySelectionContainer.backgroundColor = color
            })
        } else {
            countrySelectionContainer.backgroundColor = color
        }
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        let color = selected ? containerSelectedBakckgroundColor : containerViewBackgroundColor
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                self?.countrySelectionContainer.backgroundColor = color
            })
        } else {
            countrySelectionContainer.backgroundColor = color
        }
    }

    func setup(with selectedCountry: String) {
        countrySelectionIconView.image = UIImage(named: "flag\(selectedCountry.uppercased())", in: .current, compatibleWith: nil)
        let countryName = "country_name_\(selectedCountry)".localized(for: Kevin.shared.locale.identifier)
        countrySelectionCountryLabel.text = countryName
    }
}
