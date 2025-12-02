//
//  ViewAnchorAnalyzer.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import UIKit

// MARK: - ViewAnchorAnalyzer
struct ViewAnchorAnalyzer {
    
    /// 뷰와 모든 서브뷰의 Anchor 리스트를 출력하는 함수
    /// - Parameter view: Anchor를 출력할 뷰
    static func printAllAnchors(for view: UIView) {
        let anchorInfo = getAnchorInfo(for: view)
        printAnchors(for: view, indent: 0)
        
        // Codable Object로 변환하여 출력
        if let jsonData = try? JSONEncoder().encode(anchorInfo),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\n=== Codable Object (JSON) ===")
            print(jsonString)
        }
    }
    
    /// 뷰와 모든 서브뷰의 Anchor 정보를 Codable Object로 반환하는 함수
    /// - Parameter view: Anchor 정보를 가져올 뷰
    /// - Returns: ViewAnchorInfo 객체
    static func getAnchorInfo(for view: UIView) -> ViewAnchorInfo {
        return createAnchorInfo(for: view)
    }
    
    // MARK: - Private Methods
    
    /// 재귀적으로 뷰와 서브뷰의 Anchor 정보를 생성하는 함수
    /// - Parameter view: Anchor 정보를 생성할 뷰
    /// - Returns: ViewAnchorInfo 객체
    private static func createAnchorInfo(for view: UIView) -> ViewAnchorInfo {
        let viewName = String(describing: type(of: view))
        
        // 뷰와 관련된 모든 constraint 수집
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints.append(contentsOf: view.constraints)
        if let superview = view.superview {
            allConstraints.append(contentsOf: superview.constraints.filter { constraint in
                constraint.firstItem === view || constraint.secondItem === view
            })
        }
        
        // 각 Anchor의 constraint 정보 추출
        let topInfo = findConstraintInfo(for: .top, in: allConstraints, view: view)
        let bottomInfo = findConstraintInfo(for: .bottom, in: allConstraints, view: view)
        let leftInfo = findConstraintInfo(for: .left, in: allConstraints, view: view)
        let rightInfo = findConstraintInfo(for: .right, in: allConstraints, view: view)
        let centerXInfo = findConstraintInfo(for: .centerX, in: allConstraints, view: view)
        let centerYInfo = findConstraintInfo(for: .centerY, in: allConstraints, view: view)
        
        // 서브뷰 재귀적으로 처리
        let subviews = view.subviews.map { createAnchorInfo(for: $0) }
        
        return ViewAnchorInfo(
            viewName: viewName,
            top: topInfo,
            bottom: bottomInfo,
            left: leftInfo,
            right: rightInfo,
            centerX: centerXInfo,
            centerY: centerYInfo,
            subviews: subviews
        )
    }
    
    /// Constraint 정보를 찾아서 AnchorConstraintInfo로 변환하는 함수
    /// - Parameters:
    ///   - attribute: 찾을 attribute
    ///   - constraints: 검색할 constraint 배열
    ///   - view: 대상 뷰
    /// - Returns: AnchorConstraintInfo 또는 nil
    private static func findConstraintInfo(for attribute: NSLayoutConstraint.Attribute, in constraints: [NSLayoutConstraint], view: UIView) -> AnchorConstraintInfo? {
        for constraint in constraints {
            // firstItem이 해당 뷰이고 firstAttribute가 일치하는 경우
            if constraint.firstItem === view && constraint.firstAttribute == attribute {
                let relation = constraint.relation == .equal ? "=" : constraint.relation == .greaterThanOrEqual ? ">=" : "<="
                return AnchorConstraintInfo(
                    constant: constraint.constant,
                    multiplier: constraint.multiplier,
                    relation: relation
                )
            }
            // secondItem이 해당 뷰이고 secondAttribute가 일치하는 경우
            if constraint.secondItem === view && constraint.secondAttribute == attribute {
                let relation = constraint.relation == .equal ? "=" : constraint.relation == .greaterThanOrEqual ? ">=" : "<="
                return AnchorConstraintInfo(
                    constant: constraint.constant,
                    multiplier: constraint.multiplier,
                    relation: relation
                )
            }
        }
        return nil
    }
    
    /// 재귀적으로 뷰와 서브뷰의 Anchor를 출력하는 헬퍼 함수
    /// - Parameters:
    ///   - view: Anchor를 출력할 뷰
    ///   - indent: 들여쓰기 레벨
    private static func printAnchors(for view: UIView, indent: Int) {
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

