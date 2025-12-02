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
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let jsonData = try? encoder.encode(anchorInfo),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\n=== Codable Object (JSON) ===")
            print(jsonString)
        }
        
        // 디버깅: 실제로 찾은 constraint 정보 출력
        print("\n=== Debug: Found Constraints ===")
        printDebugInfo(for: anchorInfo)
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
        let leadingInfo = findConstraintInfo(for: .leading, in: allConstraints, view: view)
        let trailingInfo = findConstraintInfo(for: .trailing, in: allConstraints, view: view)
        let centerXInfo = findConstraintInfo(for: .centerX, in: allConstraints, view: view)
        let centerYInfo = findConstraintInfo(for: .centerY, in: allConstraints, view: view)
        let widthInfo = findConstraintInfo(for: .width, in: allConstraints, view: view)
        let heightInfo = findConstraintInfo(for: .height, in: allConstraints, view: view)
        
        // 서브뷰 재귀적으로 처리
        let subviews = view.subviews.map { createAnchorInfo(for: $0) }
        
        return ViewAnchorInfo(
            viewName: viewName,
            top: topInfo,
            bottom: bottomInfo,
            left: leftInfo,
            right: rightInfo,
            leading: leadingInfo,
            trailing: trailingInfo,
            centerX: centerXInfo,
            centerY: centerYInfo,
            width: widthInfo,
            height: heightInfo,
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
    
    /// 디버깅을 위한 constraint 정보 출력
    private static func printDebugInfo(for anchorInfo: ViewAnchorInfo) {
        print("View: \(anchorInfo.viewName)")
        if let top = anchorInfo.top { print("  ✅ top: constant=\(top.constant), relation=\(top.relation)") } else { print("  ❌ top: nil") }
        if let bottom = anchorInfo.bottom { print("  ✅ bottom: constant=\(bottom.constant), relation=\(bottom.relation)") } else { print("  ❌ bottom: nil") }
        if let left = anchorInfo.left { print("  ✅ left: constant=\(left.constant), relation=\(left.relation)") } else { print("  ❌ left: nil") }
        if let right = anchorInfo.right { print("  ✅ right: constant=\(right.constant), relation=\(right.relation)") } else { print("  ❌ right: nil") }
        if let leading = anchorInfo.leading { print("  ✅ leading: constant=\(leading.constant), relation=\(leading.relation)") } else { print("  ❌ leading: nil") }
        if let trailing = anchorInfo.trailing { print("  ✅ trailing: constant=\(trailing.constant), relation=\(trailing.relation)") } else { print("  ❌ trailing: nil") }
        if let centerX = anchorInfo.centerX { print("  ✅ centerX: constant=\(centerX.constant), relation=\(centerX.relation)") } else { print("  ❌ centerX: nil") }
        if let centerY = anchorInfo.centerY { print("  ✅ centerY: constant=\(centerY.constant), relation=\(centerY.relation)") } else { print("  ❌ centerY: nil") }
        if let width = anchorInfo.width { print("  ✅ width: constant=\(width.constant), relation=\(width.relation)") } else { print("  ❌ width: nil") }
        if let height = anchorInfo.height { print("  ✅ height: constant=\(height.constant), relation=\(height.relation)") } else { print("  ❌ height: nil") }
        print("")
    }
}

