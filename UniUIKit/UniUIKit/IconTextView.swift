//
//  IconTextView.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import UIKit

class IconTextView: UIView {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemRed.withAlphaComponent(0.2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemYellow.withAlphaComponent(0.2)
        
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        
        NSLayoutConstraint.activate([
            // StackView constraints: 상하 8, 좌우 16
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Icon size constraint
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Public Methods
    func configure(icon: UIImage?, text: String) {
        iconImageView.image = icon
        textLabel.text = text
    }
    
    func setIcon(_ icon: UIImage?) {
        iconImageView.image = icon
    }
    
    func setText(_ text: String) {
        textLabel.text = text
    }
}

