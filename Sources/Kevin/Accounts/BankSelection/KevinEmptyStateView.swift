import UIKit

final internal class KevinEmptyStateView: UIView {

    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Kevin.shared.theme.emptyStateStyle.iconTintColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = Kevin.shared.theme.emptyStateStyle.cornerRadius
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "error", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = Kevin.shared.theme.emptyStateStyle.iconTintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Kevin.shared.theme.emptyStateStyle.titleFont
        label.textColor = Kevin.shared.theme.emptyStateStyle.titleTextColor
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Kevin.shared.theme.emptyStateStyle.subtitleFont
        label.textColor = Kevin.shared.theme.emptyStateStyle.subtitleTextColor
        return label
    }()
    
    var country: String = "" {
        didSet {
            setupText()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupText()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupText() {
        titleLabel.text = String(format: "window_bank_selection_empty_state_title".localized(for: Kevin.shared.locale.identifier), country)
        subtitleLabel.text = String(format: "window_bank_selection_empty_state_subtitle".localized(for: Kevin.shared.locale.identifier), country)
    }
    
    private func setupLayout() {
        addSubview(imageContainerView)
        imageContainerView.addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageContainerView.heightAnchor.constraint(equalToConstant: 76),
            imageContainerView.widthAnchor.constraint(equalToConstant: 76),
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -40),
            
            iconImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -16),
            iconImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 16),
            iconImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -16),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
