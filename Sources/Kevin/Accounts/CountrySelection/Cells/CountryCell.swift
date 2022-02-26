//
//  CountryCell.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class CountryCell : UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let backgroundOverlay = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Kevin.shared.theme.listTableStyle.cellBackgroundColor
        
        backgroundOverlay.isHidden = true
        backgroundOverlay.backgroundColor = Kevin.shared.theme.listTableStyle.cellSelectedBackgroundColor
        backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundOverlay)
        backgroundOverlay.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundOverlay.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        backgroundOverlay.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        backgroundOverlay.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.font = Kevin.shared.theme.listTableStyle.titleLabelFont
        titleLabel.textColor = Kevin.shared.theme.generalStyle.primaryTextColor
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        let chevron = UIImageView(image: Kevin.shared.theme.listTableStyle.chevronImage)
        contentView.addSubview(chevron)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        chevron.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        chevron.widthAnchor.constraint(equalToConstant: 14).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
