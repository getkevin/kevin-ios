//
//  GalleryCell.swift
//  NoteMe
//
//  Created by Bio:Matic on 09/03/2017.
//  Copyright © 2017 Edgar Žigis. All rights reserved.
//

import Foundation
import UIKit

internal class BankCell : UITableViewCell {
    
    private let rowWidth: CGFloat = UIScreen.main.bounds.size.width
    
    let leftAsset = UIImageView()
    let rightAsset = UIImageView()
    
    let leftOverlay = UIView()
    let rightOverlay = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        configureLeftAsset()
        configureRightAsset()
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
    
    private func configureLeftAsset() {
        leftOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        leftOverlay.layer.cornerRadius = Kevin.shared.theme.gridTableStyle.cellCornerRadius
        leftOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftOverlay)

        leftAsset.contentMode = .scaleAspectFit
        leftAsset.isUserInteractionEnabled = true
        leftAsset.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftAsset)
        leftAsset.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        leftAsset.widthAnchor.constraint(
            equalToConstant: (rowWidth - 16 - Kevin.shared.theme.insets.left - Kevin.shared.theme.insets.right) / 2
        ).isActive = true
        leftAsset.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        leftOverlay.topAnchor.constraint(equalTo: leftAsset.topAnchor).isActive = true
        leftOverlay.leftAnchor.constraint(equalTo: leftAsset.leftAnchor).isActive = true
        leftOverlay.widthAnchor.constraint(equalTo: leftAsset.widthAnchor).isActive = true
        leftOverlay.heightAnchor.constraint(equalTo: leftAsset.heightAnchor).isActive = true
    }
    
    private func configureRightAsset() {
        rightOverlay.backgroundColor = Kevin.shared.theme.gridTableStyle.cellSelectedBackgroundColor
        rightOverlay.layer.cornerRadius = Kevin.shared.theme.gridTableStyle.cellCornerRadius
        rightOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightOverlay)
        
        rightAsset.contentMode = .scaleAspectFit
        rightAsset.isUserInteractionEnabled = true
        rightAsset.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightAsset)
        rightAsset.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Kevin.shared.theme.insets.right).isActive = true
        rightAsset.widthAnchor.constraint(
            equalToConstant: (rowWidth - 16 - Kevin.shared.theme.insets.left - Kevin.shared.theme.insets.right) / 2
        ).isActive = true
        rightAsset.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        rightOverlay.topAnchor.constraint(equalTo: rightAsset.topAnchor).isActive = true
        rightOverlay.leftAnchor.constraint(equalTo: rightAsset.leftAnchor).isActive = true
        rightOverlay.widthAnchor.constraint(equalTo: rightAsset.widthAnchor).isActive = true
        rightOverlay.heightAnchor.constraint(equalTo: rightAsset.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
