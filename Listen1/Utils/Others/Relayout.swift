//
//  Relayout.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import UIKit

/// relayout
/// - Parameters:
///   - refer: CGFloat
///   - idiom: UIUserInterfaceIdiom
internal func relayout(_ refer: CGFloat, idiom: UIUserInterfaceIdiom = .phone) -> CGFloat {
    switch idiom {
    case .phone:
        return refer * 375.0 / UIScreen.main.bounds.width
    default:
        return refer
    }
}

