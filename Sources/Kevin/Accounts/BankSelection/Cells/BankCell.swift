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
        contentView.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        configureLeftAsset()
        configureRightAsset()
    }
    
    private func configureLeftAsset() {
        leftOverlay.isHidden = true
        leftOverlay.backgroundColor = Kevin.shared.theme.selectedOnPrimaryColor
        leftOverlay.layer.cornerRadius = 10
        leftOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftOverlay)

        leftAsset.contentMode = .scaleAspectFit
        leftAsset.isUserInteractionEnabled = true
        leftAsset.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftAsset)
        leftAsset.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Kevin.shared.theme.leftInset).isActive = true
        leftAsset.widthAnchor.constraint(
            equalToConstant: (rowWidth - 16 - Kevin.shared.theme.leftInset - Kevin.shared.theme.rightInset) / 2
        ).isActive = true
        leftAsset.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        leftOverlay.topAnchor.constraint(equalTo: leftAsset.topAnchor).isActive = true
        leftOverlay.leftAnchor.constraint(equalTo: leftAsset.leftAnchor).isActive = true
        leftOverlay.widthAnchor.constraint(equalTo: leftAsset.widthAnchor).isActive = true
        leftOverlay.heightAnchor.constraint(equalTo: leftAsset.heightAnchor).isActive = true
    }
    
    private func configureRightAsset() {
        rightOverlay.isHidden = true
        rightOverlay.backgroundColor = Kevin.shared.theme.selectedOnPrimaryColor
        rightOverlay.layer.cornerRadius = 10
        rightOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightOverlay)
        
        rightAsset.contentMode = .scaleAspectFit
        rightAsset.isUserInteractionEnabled = true
        rightAsset.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightAsset)
        rightAsset.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Kevin.shared.theme.rightInset).isActive = true
        rightAsset.widthAnchor.constraint(
            equalToConstant: (rowWidth - 16 - Kevin.shared.theme.leftInset - Kevin.shared.theme.rightInset) / 2
        ).isActive = true
        rightAsset.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        rightOverlay.topAnchor.constraint(equalTo: rightAsset.topAnchor).isActive = true
        rightOverlay.leftAnchor.constraint(equalTo: rightAsset.leftAnchor).isActive = true
        rightOverlay.widthAnchor.constraint(equalTo: rightAsset.widthAnchor).isActive = true
        rightOverlay.heightAnchor.constraint(equalTo: rightAsset.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
