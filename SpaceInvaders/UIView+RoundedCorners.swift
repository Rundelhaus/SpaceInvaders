//
//  UIView+RoundedCorners.swift
//  ScooterQuests
//
//  Created by Admin on 08.03.2021.
//

import UIKit

extension UIView {
  func makeRoundedCorners(masksToBounds: Bool = true) {
    makeRoundedCorners(radius: bounds.height / 2)
  }

  func makeRoundedCorners(radius: CGFloat, masksToBounds: Bool = true) {
    layer.cornerRadius = radius
    layer.masksToBounds = masksToBounds
  }
}
