//
//  KevinCountrySelectionView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinCountrySelectionView : KevinModalView<KevinCountrySelectionState> {
    
    weak var delegate: KevinCountrySelectionViewDelegate?
    
    private let loadingIndicator = UIActivityIndicatorView()
    private let titleLabel = UILabel()
    private let countryTableView = UITableView()
    
    private var countryItems: Array<String> = []
    private var selectedCountry: String!
    
    override func render(state: KevinCountrySelectionState) {
        self.countryItems = state.supportedCountries
        self.selectedCountry = state.selectedCountry
        countryTableView.reloadData()
        if !state.isLoading {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitleLabel()
        initCountrySelection()
        initLoadingIndicator()
    }
    
    private func initLoadingIndicator() {
        containerView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.center(in: self.containerView)
        loadingIndicator.startAnimating()
    }
    
    private func initTitleLabel() {
        titleLabel.text = NSLocalizedString("window_country_selection_title", bundle: Bundle.module, comment: "")
        titleLabel.font = Kevin.shared.theme.largeFont
        titleLabel.textColor = Kevin.shared.theme.primaryTextColor
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func initCountrySelection() {
        countryTableView.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        countryTableView.rowHeight = 64
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.estimatedRowHeight = 64
        containerView.addSubview(countryTableView)
        
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        countryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        countryTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        countryTableView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
}

extension KevinCountrySelectionView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CountryCell
        if cell == nil {
            cell = CountryCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        cell!.backgroundOverlay.isHidden = !(countryItems[indexPath.row].uppercased() == selectedCountry.uppercased())
        cell!.iconImageView.image = UIImage(named: "flag\(countryItems[indexPath.row].uppercased())", in: Bundle.module, compatibleWith: nil)
        cell!.titleLabel.text = NSLocalizedString("country_name_\(countryItems[indexPath.row].lowercased())", bundle: Bundle.module, comment: "")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryItems.count
    }
}

extension KevinCountrySelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animateDismissView()
        delegate?.onCountrySelected(countryCode: self.countryItems[indexPath.row])
    }
}
