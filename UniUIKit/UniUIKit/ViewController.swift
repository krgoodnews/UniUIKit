//
//  ViewController.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let iconTextView: IconLabelView = {
        let view = IconLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printAllAnchors(for: iconTextView)
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
    
    /// 뷰와 모든 서브뷰의 Anchor 리스트를 출력하는 함수
    /// - Parameter view: Anchor를 출력할 뷰
    func printAllAnchors(for view: UIView) {
        printAnchors(for: view, indent: 0)
    }
    
    /// 재귀적으로 뷰와 서브뷰의 Anchor를 출력하는 헬퍼 함수
    /// - Parameters:
    ///   - view: Anchor를 출력할 뷰
    ///   - indent: 들여쓰기 레벨
    private func printAnchors(for view: UIView, indent: Int) {
        let indentString = String(repeating: "  ", count: indent)
        let viewName = String(describing: type(of: view))
        
        print("\(indentString)📌 View: \(viewName)")
        
        // 뷰와 관련된 모든 constraint 수집 (자신과 부모 뷰의 constraint)
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints.append(contentsOf: view.constraints)
        if let superview = view.superview {
            allConstraints.append(contentsOf: superview.constraints.filter { constraint in
                constraint.firstItem === view || constraint.secondItem === view
            })
        }
        
        // 해당 뷰의 모든 Anchor 출력 (이름과 attribute 매핑)
        let anchors: [(String, NSLayoutAnchor<NSLayoutXAxisAnchor>?, NSLayoutConstraint.Attribute)] = [
            ("leadingAnchor", view.leadingAnchor, .leading),
            ("trailingAnchor", view.trailingAnchor, .trailing),
            ("leftAnchor", view.leftAnchor, .left),
            ("rightAnchor", view.rightAnchor, .right),
            ("centerXAnchor", view.centerXAnchor, .centerX)
        ]
        
        let yAnchors: [(String, NSLayoutAnchor<NSLayoutYAxisAnchor>?, NSLayoutConstraint.Attribute)] = [
            ("topAnchor", view.topAnchor, .top),
            ("bottomAnchor", view.bottomAnchor, .bottom),
            ("centerYAnchor", view.centerYAnchor, .centerY),
            ("firstBaselineAnchor", view.firstBaselineAnchor, .firstBaseline),
            ("lastBaselineAnchor", view.lastBaselineAnchor, .lastBaseline)
        ]
        
        let dimensionAnchors: [(String, NSLayoutDimension?, NSLayoutConstraint.Attribute)] = [
            ("widthAnchor", view.widthAnchor, .width),
            ("heightAnchor", view.heightAnchor, .height)
        ]
        
        // Anchor의 constant 값을 찾는 헬퍼 함수
        func findConstant(for attribute: NSLayoutConstraint.Attribute, in constraints: [NSLayoutConstraint], view: UIView) -> String {
            for constraint in constraints {
                // firstItem이 해당 뷰이고 firstAttribute가 일치하는 경우
                if constraint.firstItem === view && constraint.firstAttribute == attribute {
                    let constant = constraint.constant
                    let relation = constraint.relation == .equal ? "=" : constraint.relation == .greaterThanOrEqual ? ">=" : "<="
                    let multiplier = constraint.multiplier != 1.0 ? " * \(constraint.multiplier)" : ""
                    return " constant: \(constant)\(multiplier) (\(relation))"
                }
                // secondItem이 해당 뷰이고 secondAttribute가 일치하는 경우
                if constraint.secondItem === view && constraint.secondAttribute == attribute {
                    let constant = constraint.constant
                    let relation = constraint.relation == .equal ? "=" : constraint.relation == .greaterThanOrEqual ? ">=" : "<="
                    let multiplier = constraint.multiplier != 1.0 ? " * \(constraint.multiplier)" : ""
                    return " constant: \(constant)\(multiplier) (\(relation))"
                }
            }
            return " (no constraint)"
        }
        
        print("\(indentString)  X-Axis Anchors:")
        for (name, anchor, attribute) in anchors {
            if let anchor = anchor {
                let constantInfo = findConstant(for: attribute, in: allConstraints, view: view)
                print("\(indentString)    - \(name): \(anchor)\(constantInfo)")
            }
        }
        
        print("\(indentString)  Y-Axis Anchors:")
        for (name, anchor, attribute) in yAnchors {
            if let anchor = anchor {
                let constantInfo = findConstant(for: attribute, in: allConstraints, view: view)
                print("\(indentString)    - \(name): \(anchor)\(constantInfo)")
            }
        }
        
        print("\(indentString)  Dimension Anchors:")
        for (name, anchor, attribute) in dimensionAnchors {
            if let anchor = anchor {
                let constantInfo = findConstant(for: attribute, in: allConstraints, view: view)
                print("\(indentString)    - \(name): \(anchor)\(constantInfo)")
            }
        }
        
        // 서브뷰 재귀적으로 처리
        if !view.subviews.isEmpty {
            print("\(indentString)  Subviews (\(view.subviews.count)):")
            for subview in view.subviews {
                printAnchors(for: subview, indent: indent + 1)
            }
        }
        
        print("") // 빈 줄 추가
    }

}

