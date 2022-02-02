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
    
    private let rowWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let backgroundOverlay = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        
        backgroundOverlay.isHidden = true
        backgroundOverlay.backgroundColor = Kevin.shared.theme.selectedOnPrimaryColor
        backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundOverlay)
        backgroundOverlay.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backgroundOverlay.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        backgroundOverlay.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        backgroundOverlay.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Kevin.shared.theme.leftInset).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.font = Kevin.shared.theme.mediumFont
        titleLabel.textColor = Kevin.shared.theme.primaryTextColor
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Kevin.shared.theme.leftInset).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
