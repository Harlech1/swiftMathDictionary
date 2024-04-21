//
//  LanguageViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit

extension LanguageViewController {
    func initTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }

    func addSubviews() {
        view.addSubview(tableView)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: totalHeight),
        ])
    }
}
