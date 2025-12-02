//
//  ViewAnchorInfo.swift
//  UniUIKit
//
//  Created by Goodnews on 12/2/25.
//

import Foundation

// MARK: - ViewAnchorInfo
struct ViewAnchorInfo: Codable {
    let viewName: String
    let top: AnchorConstraintInfo?
    let bottom: AnchorConstraintInfo?
    let left: AnchorConstraintInfo?
    let right: AnchorConstraintInfo?
    let centerX: AnchorConstraintInfo?
    let centerY: AnchorConstraintInfo?
    let subviews: [ViewAnchorInfo]
}

// MARK: - AnchorConstraintInfo
struct AnchorConstraintInfo: Codable {
    let constant: Double
    let multiplier: Double
    let relation: String // "=", ">=", "<="
}

