//
//  ViewController.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Components
    private let iconLabelView: IconLabelView = {
        let view = IconLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewAnchorAnalyzer.printAllAnchors(for: iconLabelView)
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        // IconTextView 설정
        iconLabelView.configure(icon: UIImage(named: "icon_star"), text: "별점 예시")
        
        // 뷰에 추가
        view.addSubview(iconLabelView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            iconLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconLabelView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

