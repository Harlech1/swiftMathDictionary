//
//  ArticleViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit

extension ArticleViewController {
    func initArticleTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.secondarySystemGroupedBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }

    func addSubviews() {
        view.addSubview(articleTextView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            articleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            articleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            articleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            articleTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
