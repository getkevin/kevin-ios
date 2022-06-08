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
    private let countrySelectionLabel = UILabel()
    private let bankSelectionLabel = UILabel()
    private let continueButton = KevinButton(type: .custom)
    private let errorView = KevinEmptyStateView()
    
    private var bankItems: Array<ApiBank> = []
    private var selectedBankId: String!
    
    public override func render(state: KevinBankSelectionState) {
        countrySelectionIconView.image = UIImage(named: "flag\(state.selectedCountry.uppercased())", in: Bundle.module, compatibleWith: nil)
        let countryName = "country_name_\(state.selectedCountry)".localized(for: Kevin.shared.locale.identifier)
        countrySelectionCountryLabel.text = countryName
        bankItems = state.bankItems
        selectedBankId = state.selectedBankId
        bankTableView.reloadData()
        
        if state.isCountrySelectionDisabled {
            countrySelectionContainer.gestureRecognizers?.removeAll()
        }
        
        if !state.isLoading {
            setCountryUnsupported(state.bankItems.isEmpty, for: countryName)
            loadingIndicator.stopAnimating()
        } else {
            setCountryUnsupported(false, for: countryName)
            loadingIndicator.startAnimating()
        }
    }
    
    private func setCountryUnsupported(_ unsupported: Bool, for country: String) {
        errorView.country = country
        errorView.isHidden = !unsupported
        continueButton.isHidden = unsupported
        bankTableView.isHidden = unsupported
        bankSelectionLabel.isHidden = unsupported
    }
    
    public override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        initCountrySelection()
        initContinueButton()
        initBankSelection()
        setupErrorView()
        initLoadingIndicator()
    }
    
    private func initLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center(in: self)
        loadingIndicator.startAnimating()
    }
    
    private func initCountrySelection() {
        countrySelectionLabel.text = "window_bank_selection_select_country_label".localized(for: Kevin.shared.locale.identifier).uppercased()
        countrySelectionLabel.font = Kevin.shared.theme.sectionStyle.titleLabelFont
        countrySelectionLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        addSubview(countrySelectionLabel)
        countrySelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Kevin.shared.theme.insets.top).isActive = true
        countrySelectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        countrySelectionLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        countrySelectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        countrySelectionContainer.layer.cornerRadius = Kevin.shared.theme.navigationLinkStyle.cornerRadius
        countrySelectionContainer.layer.borderWidth = Kevin.shared.theme.navigationLinkStyle.borderWidth
        countrySelectionContainer.backgroundColor = Kevin.shared.theme.navigationLinkStyle.backgroundColor
        countrySelectionContainer.layer.borderColor = Kevin.shared.theme.navigationLinkStyle.borderColor.cgColor
        addSubview(countrySelectionContainer)
        countrySelectionContainer.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionContainer.topAnchor.constraint(equalTo: countrySelectionLabel.bottomAnchor, constant: 16).isActive = true
        countrySelectionContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        countrySelectionContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Kevin.shared.theme.insets.right).isActive = true
        countrySelectionContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        countrySelectionContainer.addSubview(countrySelectionIconView)
        countrySelectionIconView.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionIconView.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        countrySelectionIconView.leftAnchor.constraint(equalTo: countrySelectionContainer.leftAnchor, constant: 16).isActive = true
        countrySelectionIconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        countrySelectionIconView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        countrySelectionCountryLabel.font = Kevin.shared.theme.navigationLinkStyle.titleLabelFont
        countrySelectionCountryLabel.textColor = Kevin.shared.theme.generalStyle.primaryTextColor
        countrySelectionContainer.addSubview(countrySelectionCountryLabel)
        countrySelectionCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        countrySelectionCountryLabel.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        countrySelectionCountryLabel.leftAnchor.constraint(equalTo: countrySelectionIconView.rightAnchor, constant: 26).isActive = true
        countrySelectionCountryLabel.widthAnchor.constraint(equalTo: countrySelectionContainer.widthAnchor, multiplier: 0.5).isActive = true
        countrySelectionCountryLabel.heightAnchor.constraint(equalTo: countrySelectionContainer.heightAnchor).isActive = true
        
        let chevron = UIImageView(image: Kevin.shared.theme.navigationLinkStyle.chevronImage)
        countrySelectionContainer.addSubview(chevron)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.centerYAnchor.constraint(equalTo: countrySelectionContainer.centerYAnchor).isActive = true
        chevron.rightAnchor.constraint(equalTo: countrySelectionContainer.rightAnchor, constant: -18).isActive = true
        chevron.widthAnchor.constraint(equalToConstant: 14).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onCountrySelectionClicked(_:)))
        countrySelectionContainer.addGestureRecognizer(tapRecognizer)
    }
    
    private func initBankSelection() {
        bankSelectionLabel.text = "window_bank_selection_select_bank_label".localized(for: Kevin.shared.locale.identifier).uppercased()
        bankSelectionLabel.font = Kevin.shared.theme.sectionStyle.titleLabelFont
        bankSelectionLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        addSubview(bankSelectionLabel)
        bankSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        bankSelectionLabel.topAnchor.constraint(equalTo: countrySelectionContainer.bottomAnchor, constant: 25).isActive = true
        bankSelectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Kevin.shared.theme.insets.left).isActive = true
        bankSelectionLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bankSelectionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        bankTableView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        bankTableView.rowHeight = 76
        bankTableView.dataSource = self
        bankTableView.estimatedRowHeight = 76
        bankTableView.allowsSelection = false
        bankTableView.separatorStyle = .none
        addSubview(bankTableView)
        
        bankTableView.translatesAutoresizingMaskIntoConstraints = false
        bankTableView.topAnchor.constraint(equalTo: bankSelectionLabel.bottomAnchor, constant: 16).isActive = true
        bankTableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20).isActive = true
        bankTableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    private func initContinueButton() {
        continueButton.clipsToBounds = false
        continueButton.layer.shadowOpacity = Kevin.shared.theme.mainButtonStyle.shadowOpacity
        continueButton.layer.shadowOffset = Kevin.shared.theme.mainButtonStyle.shadowOffset
        continueButton.layer.shadowRadius = Kevin.shared.theme.mainButtonStyle.shadowRadius
        continueButton.layer.shadowColor = Kevin.shared.theme.mainButtonStyle.shadowColor.cgColor
        continueButton.layer.cornerRadius = Kevin.shared.theme.mainButtonStyle.cornerRadius
        continueButton.backgroundColor = Kevin.shared.theme.mainButtonStyle.backgroundColor
        continueButton.titleLabel?.font = Kevin.shared.theme.mainButtonStyle.titleLabelFont
        continueButton.setTitleColor(Kevin.shared.theme.mainButtonStyle.titleLabelTextColor, for: .normal)
        continueButton.setTitle("Continue".localized(for: Kevin.shared.locale.identifier).uppercased(), for: .normal)
        addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.width).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        continueButton.addTarget(self, action: #selector(self.onContinueClicked(_:)), for: .touchUpInside)
    }
    
    private func setupErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func onCountrySelectionClicked(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.20, delay: 0.0, options: .curveEaseOut, animations: {
            self.countrySelectionContainer.backgroundColor = Kevin.shared.theme.navigationLinkStyle.selectedBackgroundColor
        }, completion: { [weak self] _ in
            self?.delegate?.openCountrySelection()
            UIView.animate(withDuration: 0.20, delay: 0.0, options: .curveEaseOut, animations: {
                self?.countrySelectionContainer.backgroundColor = Kevin.shared.theme.navigationLinkStyle.backgroundColor
            })
        })
    }
    
    @objc func onContinueClicked(_ sender: UIButton) {
        delegate?.invokeContinuation(bankId: selectedBankId)
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
        cell!.leftAsset.loadImageUsingCache(withUrl: getBankLogo(for: leftAsset))
        cell!.leftAsset.tag = leftIndex
        cell!.selectLeftItem(leftAsset.id == self.selectedBankId)
        
        let leftRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBankSelected(_:)))
        cell!.leftAsset.gestureRecognizers?.removeAll()
        cell!.leftAsset.addGestureRecognizer(leftRecognizer)
        
        if rightIndex < bankItems.count {
            let rightAsset = bankItems[rightIndex]
            cell!.rightAsset.loadImageUsingCache(withUrl: getBankLogo(for: rightAsset))
            cell!.rightAsset.tag = rightIndex
            cell!.selectRightItem(rightAsset.id == self.selectedBankId)
            
            let rightRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBankSelected(_:)))
            cell!.rightAsset.gestureRecognizers?.removeAll()
            cell!.rightOverlay.isHidden = false
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
    
    private func getBankLogo(for bank: ApiBank) -> String {
        var originalUri = bank.imageUri
        
        if
            !UIApplication.shared.isLightThemedInterface &&
            Kevin.shared.theme.gridTableStyle.cellBackgroundColor != UIColor.white
        {
            
            let imageUriParts = originalUri.components(separatedBy: "images/")
            
            if imageUriParts.count > 1 {
                originalUri = "\(imageUriParts.first!)images/white/\(imageUriParts.last!)"
            }
        }
        
        return originalUri
    }
}
