//
//  KevinBankSelectionView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinBankSelectionView : KevinView<KevinBankSelectionState> {
    
    weak var delegate: KevinBankSelectionViewDelegate?
    
    private let loadingIndicator = UIActivityIndicatorView()
    private let countrySelectionContainer = UIView()
    private let countrySelectionIconView = UIImageView()
    private let countrySelectionCountryLabel = UILabel()
    private let bankTableView = UITableView()
    private let continueButton = KevinButton(type: .custom)
    
    private var bankItems: Array<ApiBank> = []
    private var selectedBankId: String!
    
    public override func render(state: KevinBankSelectionState) {
        countrySelectionIconView.image = UIImage(named: "flag\(state.selectedCountry.uppercased())", in: Bundle.module, compatibleWith: nil)
        countrySelectionCountryLabel.text = NSLocalizedString("country_name_\(state.selectedCountry)", bundle: Bundle.module, comment: "")
        self.bankItems = state.bankItems
        self.selectedBankId = state.selectedBankId
        bankTableView.reloadData()
        if state.isCountrySelectionDisabled {
            countrySelectionContainer.gestureRecognizers?.removeAll()
        }
    }
    
    public override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        initLoadingIndicator()
        initCountrySelection()
        initContinueButton()
        initBankSelection()
    }
    
    private func initLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.center(in: self)
        loadingIndicator.startAnimating()
    }
    
    private func initCountrySelection() {
        let countrySelectionLabel = UILabel()
        countrySelectionLabel.text = NSLocalizedString("window_bank_selection_select_country_label", bundle: Bundle.module, comment: "")
        countrySelectionLabel.font = Kevin.shared.theme.smallFont
        countrySelectionLabel.textColor = Kevin.shared.theme.secondaryTextColor
        addSubview(countrySelectionLabel)
        countrySelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        countrySelectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        countrySelectionLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        countrySelectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        countrySelectionContainer.layer.cornerRadius = 10
        countrySelectionContainer.layer.borderWidth = 1
        countrySelectionContainer.layer.borderColor = Kevin.shared.theme.primaryTextColor.cgColor
        addSubview(countrySelectionContainer)
        countrySelectionContainer.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionContainer.topAnchor.constraint(equalTo: countrySelectionLabel.bottomAnchor, constant: 16).isActive = true
        countrySelectionContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        countrySelectionContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        countrySelectionContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        countrySelectionContainer.addSubview(countrySelectionIconView)
        countrySelectionIconView.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionIconView.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        countrySelectionIconView.leftAnchor.constraint(equalTo: countrySelectionContainer.leftAnchor, constant: 16).isActive = true
        countrySelectionIconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        countrySelectionIconView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        countrySelectionCountryLabel.font = Kevin.shared.theme.mediumFont
        countrySelectionCountryLabel.textColor = Kevin.shared.theme.primaryTextColor
        countrySelectionContainer.addSubview(countrySelectionCountryLabel)
        countrySelectionCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionCountryLabel.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        countrySelectionCountryLabel.leftAnchor.constraint(equalTo: countrySelectionIconView.rightAnchor, constant: 16).isActive = true
        countrySelectionCountryLabel.widthAnchor.constraint(equalTo: countrySelectionContainer.widthAnchor, multiplier: 0.5).isActive = true
        countrySelectionCountryLabel.heightAnchor.constraint(equalTo: countrySelectionContainer.heightAnchor).isActive = true
        
        let chevron = UIImageView(image: UIImage(named: "chevronIcon", in: Bundle.module, compatibleWith: nil))
        countrySelectionContainer.addSubview(chevron)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        chevron.rightAnchor.constraint(equalTo: countrySelectionContainer.rightAnchor, constant: -20).isActive = true
        chevron.widthAnchor.constraint(equalToConstant: 12).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onCountrySelectionClicked(_:)))
        countrySelectionContainer.addGestureRecognizer(tapRecognizer)
    }
    
    private func initBankSelection() {
        let bankSelectionLabel = UILabel()
        bankSelectionLabel.text = NSLocalizedString("window_bank_selection_select_bank_label", bundle: Bundle.module, comment: "")
        bankSelectionLabel.font = Kevin.shared.theme.smallFont
        bankSelectionLabel.textColor = Kevin.shared.theme.secondaryTextColor
        addSubview(bankSelectionLabel)
        bankSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        bankSelectionLabel.topAnchor.constraint(equalTo: countrySelectionContainer.bottomAnchor, constant: 16).isActive = true
        bankSelectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        bankSelectionLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bankSelectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        bankTableView.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        bankTableView.rowHeight = 64
        bankTableView.dataSource = self
        bankTableView.estimatedRowHeight = 64
        bankTableView.allowsSelection = false
        bankTableView.separatorStyle = .none
        addSubview(bankTableView)
        
        bankTableView.translatesAutoresizingMaskIntoConstraints = false
        bankTableView.topAnchor.constraint(equalTo: bankSelectionLabel.bottomAnchor, constant: 20).isActive = true
        bankTableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20).isActive = true
        bankTableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    private func initContinueButton() {
        continueButton.clipsToBounds = false
        continueButton.layer.shadowOpacity = Kevin.shared.theme.buttonShadowOpacity
        continueButton.layer.shadowOffset = Kevin.shared.theme.buttonShadowOffset
        continueButton.layer.shadowRadius = Kevin.shared.theme.buttonShadowRadius
        continueButton.layer.cornerRadius = Kevin.shared.theme.buttonCornerRadius
        continueButton.backgroundColor = Kevin.shared.theme.buttonBackgroundColor
        continueButton.titleLabel?.font = Kevin.shared.theme.buttonFont
        continueButton.setTitleColor(Kevin.shared.theme.buttonLabelTextColor, for: .normal)
        continueButton.setTitle(NSLocalizedString("action_continue", bundle: Bundle.module, comment: "").uppercased(), for: .normal)
        addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        continueButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        continueButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.buttonHeight).isActive = true
        
        continueButton.addTarget(self, action: #selector(self.onContinueClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func onCountrySelectionClicked(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.20, delay: 0.0, options: .curveEaseOut, animations: {
            self.countrySelectionContainer.backgroundColor = Kevin.shared.theme.selectedOnPrimaryColor
        }, completion: { [weak self] _ in
            self?.delegate?.openCountrySelection()
            UIView.animate(withDuration: 0.20, delay: 0.0, options: .curveEaseOut, animations: {
                self?.countrySelectionContainer.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
            }, completion: nil)
        })
    }
    
    @objc func onContinueClicked(_ sender: UIButton) {
        delegate?.invokeContinuation(bankId: self.selectedBankId)
    }
}

extension KevinBankSelectionView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BankCell
        if cell == nil {
            cell = BankCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }

        let leftIndex = indexPath.row * 2
        let rightIndex = indexPath.row * 2 + 1
        
        let leftAsset = bankItems[leftIndex]
        cell!.leftAsset.loadImageUsingCache(withUrl: leftAsset.imageUri)
        cell!.leftAsset.tag = leftIndex
        cell!.leftOverlay.isHidden = !(leftAsset.id == self.selectedBankId)
        
        let leftRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBankSelected(_:)))
        cell!.leftAsset.gestureRecognizers?.removeAll()
        cell!.leftAsset.addGestureRecognizer(leftRecognizer)
        
        if rightIndex < bankItems.count {
            let rightAsset = bankItems[rightIndex]
            cell!.rightAsset.loadImageUsingCache(withUrl: rightAsset.imageUri)
            cell!.rightAsset.tag = rightIndex
            cell!.rightOverlay.isHidden = !(rightAsset.id == self.selectedBankId)
            
            let rightRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBankSelected(_:)))
            cell!.rightAsset.gestureRecognizers?.removeAll()
            cell!.rightAsset.addGestureRecognizer(rightRecognizer)
        } else {
            cell!.rightAsset.image = nil
            cell!.rightOverlay.isHidden = true
            cell!.rightAsset.gestureRecognizers?.removeAll()
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceil(CGFloat(bankItems.count) / 2.0))
    }
    
    @objc private func onBankSelected(_ recognizer: UITapGestureRecognizer) {
        self.selectedBankId = self.bankItems[recognizer.view?.tag ?? 0].id
        bankTableView.reloadData()
    }
}
