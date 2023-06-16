//
//  BankCell.swift
//  kevin.iOS
//
//  Created by Arthur Alehna on 01/09/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import UIKit

internal class BankCell : UITableViewCell {
    
    private let rowWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let leftAsset = UIImageView()
    let rightAsset = UIImageView()
    
    let leftOverlay = UIView()
    let rightOverlay = UIView()
    
    private let containerView = UIView()
    
    private var gridTableStyle: KevinTheme.GridTableStyle {
        return Kevin.shared.theme.gridTableStyle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        
        configureLeftAsset()
        configureRightAsset()
        configureContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func selectLeftItem(_ isSelected: Bool) {
        if isSelected {
            leftOverlay.backgroundColor = gridTableStyle.cellSelectedBackgroundColor
            leftOverlay.layer.borderColor = gridTableStyle.cellSelectedBorderColor.cgColor
            leftOverlay.layer.borderWidth = gridTableStyle.cellSelectedBorderWidth
        } else {
            leftOverlay.backgroundColor = gridTableStyle.cellBackgroundColor
            leftOverlay.layer.borderColor = gridTableStyle.cellBorderColor.cgColor
            leftOverlay.layer.borderWidth = gridTableStyle.cellBorderWidth
        }
    }
    
    func selectRightItem(_ isSelected: Bool) {
        if isSelected {
            rightOverlay.backgroundColor = gridTableStyle.cellSelectedBackgroundColor
            rightOverlay.layer.borderColor = gridTableStyle.cellSelectedBorderColor.cgColor
            rightOverlay.layer.borderWidth = gridTableStyle.cellSelectedBorderWidth
        } else {
            rightOverlay.backgroundColor = gridTableStyle.cellBackgroundColor
            rightOverlay.layer.borderColor = gridTableStyle.cellBorderColor.cgColor
            rightOverlay.layer.borderWidth = gridTableStyle.cellBorderWidth
        }
    }
    
    private func configureContainerView() {
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(leftOverlay)
        containerView.addSubview(rightOverlay)
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: Kevin.shared.theme.insets.left),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Kevin.shared.theme.insets.right),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            leftOverlay.widthAnchor.constraint(
                equalToConstant: (rowWidth - 16 - Kevin.shared.theme.insets.left - Kevin.shared.theme.insets.right) / 2
            ),
            leftOverlay.topAnchor.constraint(equalTo: containerView.topAnchor),
            leftOverlay.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            leftOverlay.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            rightOverlay.widthAnchor.constraint(equalTo: leftOverlay.widthAnchor),
            rightOverlay.topAnchor.constraint(equalTo: containerView.topAnchor),
            rightOverlay.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rightOverlay.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func configureLeftAsset() {
        leftOverlay.backgroundColor = gridTableStyle.cellSelectedBackgroundColor
        leftOverlay.layer.cornerRadius = gridTableStyle.cellCornerRadius
        leftOverlay.layer.borderColor = gridTableStyle.cellBorderColor.cgColor
        leftOverlay.layer.borderWidth = gridTableStyle.cellBorderWidth
        
        leftOverlay.translatesAutoresizingMaskIntoConstraints = false

        leftAsset.contentMode = .scaleAspectFit
        leftAsset.isUserInteractionEnabled = true
        leftAsset.translatesAutoresizingMaskIntoConstraints = false
        leftOverlay.addSubview(leftAsset)
        
        NSLayoutConstraint.activate([
            leftAsset.topAnchor.constraint(equalTo: leftOverlay.topAnchor),
            leftAsset.leftAnchor.constraint(equalTo: leftOverlay.leftAnchor),
            leftAsset.rightAnchor.constraint(equalTo: leftOverlay.rightAnchor),
            leftAsset.bottomAnchor.constraint(equalTo: leftOverlay.bottomAnchor)
        ])
    }
    
    private func configureRightAsset() {
        rightOverlay.backgroundColor = gridTableStyle.cellSelectedBackgroundColor
        rightOverlay.layer.cornerRadius = gridTableStyle.cellCornerRadius
        rightOverlay.layer.borderColor = gridTableStyle.cellBorderColor.cgColor
        rightOverlay.layer.borderWidth = gridTableStyle.cellBorderWidth
        
        rightOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        rightAsset.contentMode = .scaleAspectFit
        rightAsset.isUserInteractionEnabled = true
        rightAsset.translatesAutoresizingMaskIntoConstraints = false
        rightOverlay.addSubview(rightAsset)
        
        NSLayoutConstraint.activate([
            rightAsset.topAnchor.constraint(equalTo: rightOverlay.topAnchor),
            rightAsset.leftAnchor.constraint(equalTo: rightOverlay.leftAnchor),
            rightAsset.rightAnchor.constraint(equalTo: rightOverlay.rightAnchor),
            rightAsset.bottomAnchor.constraint(equalTo: rightOverlay.bottomAnchor)
        ])
    }
}
