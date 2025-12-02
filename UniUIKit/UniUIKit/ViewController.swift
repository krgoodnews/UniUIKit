//
//  ViewController.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let iconTextView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        // IconTextView 설정
        iconTextView.configure(icon: UIImage(named: "icon_star"), text: "별점 예시")
        
        // 뷰에 추가
        view.addSubview(iconTextView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            iconTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}

