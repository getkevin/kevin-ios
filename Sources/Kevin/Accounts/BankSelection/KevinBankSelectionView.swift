//
//  KevinBankSelectionView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal enum KevinBankSelectionSections: Int, CaseIterable {
    case countrySelection
    case bankHeader
    case banks
    case empty
}

internal class KevinBankSelectionView : KevinView<KevinBankSelectionState> {
    
    weak var delegate: KevinBankSelectionViewDelegate?
    
    private let loadingIndicator = UIActivityIndicatorView()
    private let tableView = UITableView()
    
    private let agreementLabel = KevinClickableUILabel()
    private let continueButton = KevinButton(type: .custom)

    private var bankItems: Array<ApiBank> = []
    private var selectedBankId: String!
    
    private var state: KevinBankSelectionState?
    
    public override func render(state: KevinBankSelectionState) {
        self.state = state
        bankItems = state.bankItems
        selectedBankId = state.selectedBankId
        
        tableView.reloadData()
        
        let countryName = "country_name_\(state.selectedCountry)".localized(for: Kevin.shared.locale.identifier)
        
        if !state.isLoading {
            showEmptyState(state.bankItems.isEmpty, for: countryName)
            loadingIndicator.stopAnimating()
        } else {
            showEmptyState(false, for: countryName)
            loadingIndicator.startAnimating()
        }
    }
    
    private func showEmptyState(_ show: Bool, for country: String) {
        continueButton.isHidden = show
        agreementLabel.isHidden = show
    }
    
    public override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        initTableView()
        initAgreementLabel()
        initContinueButton()
        initLoadingIndicator()
    }
    
    private func initLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center(in: self)
        loadingIndicator.startAnimating()
    }
    
    private func initTableView() {
        tableView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        tableView.register(CountrySelectionCell.self, forCellReuseIdentifier: "CountrySelectionCell")
        tableView.register(BankCell.self, forCellReuseIdentifier: "BankCell")
        tableView.register(BankHeaderCell.self, forCellReuseIdentifier: "BankHeaderCell")
        tableView.register(EmptyStateCell.self, forCellReuseIdentifier: "EmptyStateCell")
        
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func initAgreementLabel() {        
        agreementLabel.text = "window_bank_selection_terms_and_conditions_text".localized(for: Kevin.shared.locale.identifier)
        agreementLabel.numberOfLines = 0
        agreementLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        agreementLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        agreementLabel.delegate = self
            
        agreementLabel.tapableLinks = [
            KevinClickableUILabelLink(
                text: "window_bank_selection_terms_clickable_text".localized(for: Kevin.shared.locale.identifier),
                url: URL(string: "window_bank_selection_terms_and_conditions_url".localized(for: Kevin.shared.locale.identifier))!
            ),
            KevinClickableUILabelLink(
                text: "window_bank_selection_privacy_clickable_text".localized(for: Kevin.shared.locale.identifier),
                url: URL(string: "window_bank_selection_privacy_policy_url".localized(for: Kevin.shared.locale.identifier))!
            )
        ]
        
        addSubview(agreementLabel)
        
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        agreementLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        agreementLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
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
        continueButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 20).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.width).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        continueButton.addTarget(self, action: #selector(self.onContinueClicked(_:)), for: .touchUpInside)
    }
    
    @objc func onContinueClicked(_ sender: UIButton) {
        delegate?.invokeContinuation(bankId: selectedBankId)
    }
}

extension KevinBankSelectionView : KevinClickableUILabelDelegate {
    func didTap(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension KevinBankSelectionView : UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch KevinBankSelectionSections(rawValue: section) {
        case .countrySelection:
            return 1
        case .bankHeader:
            return bankItems.isEmpty ? 0 : 1
        case .banks:
            return Int(ceil(CGFloat(bankItems.count) / 2.0))
        case .empty:
            let isLoading = state?.isLoading == true
            let isEmpty = state?.bankItems.isEmpty == true
            let shouldShow = !isLoading && isEmpty
            return shouldShow ? 1 : 0
        case .none:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        KevinBankSelectionSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if KevinBankSelectionSections(rawValue: indexPath.section) == .countrySelection
            && state?.isCountrySelectionDisabled == true {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            delegate?.openCountrySelection()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch KevinBankSelectionSections(rawValue: indexPath.section) {
        case .countrySelection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountrySelectionCell") as? CountrySelectionCell
            cell?.setup(with: state?.selectedCountry ?? "")
            return cell!
        case .bankHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BankHeaderCell") as? BankHeaderCell
            return cell!
        case .banks:
            return setupBankCell(tableView, indexPath)
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCell") as? EmptyStateCell
            cell?.setup(with: state?.selectedCountry ?? "", heightToOccupy: tableView.bounds.height) 
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    private func setupBankCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell") as? BankCell
        
        let leftIndex = indexPath.row * 2
        let rightIndex = indexPath.row * 2 + 1
        
        let leftAsset = bankItems[leftIndex]
        cell!.leftAsset.loadImageUsingCache(withUrl: getBankLogo(for: leftAsset))
        cell!.leftAsset.tag = leftIndex
        cell!.selectLeftItem(leftAsset.id == selectedBankId)
        
        let leftRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBankSelected(_:)))
        cell!.leftAsset.gestureRecognizers?.removeAll()
        cell!.leftAsset.addGestureRecognizer(leftRecognizer)
        
        if rightIndex < bankItems.count {
            let rightAsset = bankItems[rightIndex]
            cell!.rightAsset.loadImageUsingCache(withUrl: getBankLogo(for: rightAsset))
            cell!.rightAsset.tag = rightIndex
            cell!.selectRightItem(rightAsset.id == selectedBankId)
            
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
    
    @objc private func onBankSelected(_ recognizer: UITapGestureRecognizer) {
        selectedBankId = bankItems[recognizer.view?.tag ?? 0].id
        tableView.reloadData()
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
