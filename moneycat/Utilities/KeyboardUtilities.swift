//
//  KeyboardUtilities.swift
//  moneycat
//
//  Created by Jonathan Shih on 2024/4/26.
//

import Foundation
import UIKit

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
