//
//  FontHelper.swift
//  matheng
//
//  Created by Türker Kızılcık on 26.11.2023.
//

import UIKit

struct FontHelper {
    static let scaledFont15: UIFont = {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 15.0))
    }()
    static let scaledFont17: UIFont = {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 17.0))
    }()
    static let scaledFont18: UIFont = {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 18.0))
    }()
    static let scaledFont20Bold: UIFont = {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.boldSystemFont(ofSize: 20.0))
    }()
    static let scaledFont21Bold: UIFont = {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.boldSystemFont(ofSize: 21.0))
    }()
}
