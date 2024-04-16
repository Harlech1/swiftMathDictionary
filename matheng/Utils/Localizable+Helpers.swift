//
//  Localizable.swift
//  ArabicArt
//
//  Created by Faisal Al Neela on 3/3/21.
//  Copyright © 2021 AppCheif. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return localized(UserDefaults.standard.string(forKey: "appLanguage") ?? "en")
    }

    func localized(_ languageCode: String, table: String? = nil) -> String {
        guard
            let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(self, tableName: table, bundle: Bundle.main, value: "", comment: "")
        }

        return bundle.localizedString(forKey: self, value: nil, table: table)
    }
}

