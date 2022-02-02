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
        loadingIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        loadingIndicator.startAnimating()
    }
    
    private func initTitleLabel() {
        let dragIndicatorView = UIImageView(image: UIImage(named: "dragIndicatorIcon", in: Bundle.module, compatibleWith: nil))
        containerView.addSubview(dragIndicatorView)
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        dragIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        titleLabel.text = "window_country_selection_title".localized(for: Kevin.shared.locale.identifier)
        titleLabel.font = Kevin.shared.theme.headLineFont
        titleLabel.textColor = Kevin.shared.theme.primaryTextColor
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func initCountrySelection() {
        countryTableView.backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        countryTableView.rowHeight = 62
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.estimatedRowHeight = 62
        countryTableView.separatorStyle = .none
        containerView.addSubview(countryTableView)
        
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        countryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
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
        cell!.titleLabel.text = "country_name_\(countryItems[indexPath.row].lowercased())".localized(for: Kevin.shared.locale.identifier)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryItems.count
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= 0 {
            handleCloseAction()
        }
    }
}

extension KevinCountrySelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animateDismissView()
        delegate?.onCountrySelected(countryCode: self.countryItems[indexPath.row])
    }
}
