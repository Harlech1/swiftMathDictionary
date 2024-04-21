//
//  FavoritesViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit

extension FavoritesViewController {
    func initTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false 
        return tableView
    }

    func initNoFavoritesView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func initNoFavoritesTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "no_favorites".localized)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 21.0)], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func initNoFavoritesSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "no_favorites_subtext".localized
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .systemGray
        label.font = FontHelper.scaledFont15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(noFavoritesView)
        noFavoritesView.addSubview(noFavoritesTitleLabel)
        noFavoritesView.addSubview(noFavoritesSubtitleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            noFavoritesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noFavoritesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noFavoritesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            noFavoritesTitleLabel.topAnchor.constraint(equalTo: noFavoritesView.topAnchor, constant: 10),
            noFavoritesTitleLabel.leadingAnchor.constraint(equalTo: noFavoritesView.leadingAnchor, constant: 50),
            noFavoritesTitleLabel.trailingAnchor.constraint(equalTo: noFavoritesView.trailingAnchor, constant: -50),

            noFavoritesSubtitleLabel.topAnchor.constraint(equalTo: noFavoritesTitleLabel.bottomAnchor, constant: 3),
            noFavoritesSubtitleLabel.leadingAnchor.constraint(equalTo: noFavoritesView.leadingAnchor, constant: 50),
            noFavoritesSubtitleLabel.trailingAnchor.constraint(equalTo: noFavoritesView.trailingAnchor, constant: -50),
            noFavoritesSubtitleLabel.bottomAnchor.constraint(equalTo: noFavoritesView.bottomAnchor, constant: -10),
        ])
    }

    func setNoFavoritesView() {
        let isVisible = !tableView.visibleCells.isEmpty
        noFavoritesView.isHidden = isVisible
        noFavoritesTitleLabel.isHidden = isVisible
        noFavoritesSubtitleLabel.isHidden = isVisible
    }
}
