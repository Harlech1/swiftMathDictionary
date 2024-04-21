//
//  DetailsViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit
import WebKit

extension DetailsViewController {
    func initRectangleView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func initTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.scaledFont21Bold
        return label
    }

    func initWebView() -> WKWebView {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            rectangleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            rectangleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            rectangleView.heightAnchor.constraint(equalToConstant: 200),

            webView.topAnchor.constraint(equalTo: rectangleView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            labelForTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelForTitle.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor),
            labelForTitle.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -20)
        ])
    }
}
