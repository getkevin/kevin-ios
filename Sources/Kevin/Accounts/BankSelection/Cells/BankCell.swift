//
//  BankCell.swift
//
//
//  Created by Bio:Matic on 09/03/2017.
//  Copyright © 2017 Edgar Žigis. All rights reserved.
//

import UIKit

internal class BankCell : UITableViewCell {
    
    private let rowWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let leftAsset = UIImageView()
    let rightAsset = UIImageView()
    
    let leftOverlay = UIView()
    let rightOverlay = UIView()
    
    private let containerView = UIView()
    
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
            leftOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        } else {
            leftOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellBackgroundColor
        }
    }
    
    func selectRightItem(_ isSelected: Bool) {
        if isSelected {
            rightOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        } else {
            rightOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellBackgroundColor
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
        leftOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        leftOverlay.layer.cornerRadius = Kevin.shared.theme.gridTableStyle.cellCornerRadius
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
        rightOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        rightOverlay.layer.cornerRadius = Kevin.shared.theme.gridTableStyle.cellCornerRadius
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
