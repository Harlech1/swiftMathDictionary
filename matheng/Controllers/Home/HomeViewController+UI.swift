//
//  HomeViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit

extension HomeViewController {
    func initContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func initLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = FontHelper.scaledFont21Bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func initLinkLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.link
        label.font = FontHelper.scaledFont17
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }

    func initQuoteTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.myOrange.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = FontHelper.scaledFont18
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 15

        // Shadow properties
        textView.layer.shadowColor = UIColor.systemGray.cgColor
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowOffset = CGSize(width: 2, height: 2)
        textView.layer.shadowRadius = 4
        return textView
    }

    func initScrollView() -> UIScrollView {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.delegate = self
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }

    func initPageControl() -> UIPageControl {
        let pg = UIPageControl()
        pg.currentPage = 0
        pg.tintColor = .myOrange
        pg.currentPageIndicatorTintColor = .myOrange
        pg.pageIndicatorTintColor = .gray
        pg.translatesAutoresizingMaskIntoConstraints = false
        return pg
    }

    func addSubviews() {
        view.addSubview(scrollViewForPage)
        scrollViewForPage.addSubview(containerViewForQuote)
        scrollViewForPage.addSubview(containerViewForArticle)
        scrollViewForPage.addSubview(containerViewForPageControl)

        containerViewForQuote.addSubview(quoteLabel)
        containerViewForQuote.addSubview(quoteTextView)

        containerViewForArticle.addSubview(articleLabel)
        containerViewForArticle.addSubview(articleLabelToLink)

        containerViewForPageControl.addSubview(threeWordsLabel)
        containerViewForPageControl.addSubview(scrollView)
        containerViewForPageControl.addSubview(pageControl)
    }

    func setUpConstraintsForPageScrollView() {
        NSLayoutConstraint.activate([
            scrollViewForPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewForPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollViewForPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollViewForPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setUpConstraintsForQuote() {
        NSLayoutConstraint.activate([
            // Container View for Quote Constraints
            containerViewForQuote.topAnchor.constraint(equalTo: scrollViewForPage.topAnchor, constant: 0),
            containerViewForQuote.leadingAnchor.constraint(equalTo: scrollViewForPage.frameLayoutGuide.leadingAnchor, constant: 20),
            containerViewForQuote.trailingAnchor.constraint(equalTo: scrollViewForPage.frameLayoutGuide.trailingAnchor, constant: -20),

            // Quote Label Constraints
            quoteLabel.topAnchor.constraint(equalTo: containerViewForQuote.topAnchor, constant: 12),
            quoteLabel.leadingAnchor.constraint(equalTo: containerViewForQuote.leadingAnchor, constant: 8),
            quoteLabel.trailingAnchor.constraint(equalTo: containerViewForQuote.trailingAnchor, constant: -8),

            // Quote Text View Constraints
            quoteTextView.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 12),
            quoteTextView.leadingAnchor.constraint(equalTo: containerViewForQuote.leadingAnchor, constant: 8),
            quoteTextView.trailingAnchor.constraint(equalTo: containerViewForQuote.trailingAnchor, constant: -8),
            quoteTextView.bottomAnchor.constraint(equalTo: containerViewForQuote.bottomAnchor, constant: -8),
        ])
    }

    func setUpConstraintsForArticle() {
        NSLayoutConstraint.activate([
            // Container View for Article Constraints/
            containerViewForArticle.topAnchor.constraint(equalTo: containerViewForQuote.bottomAnchor, constant: 20),
            containerViewForArticle.leadingAnchor.constraint(equalTo: scrollViewForPage.frameLayoutGuide.leadingAnchor, constant: 20),
            containerViewForArticle.trailingAnchor.constraint(equalTo: scrollViewForPage.frameLayoutGuide.trailingAnchor, constant: -20),

            // Article Label Constraints
            articleLabel.topAnchor.constraint(equalTo: containerViewForArticle.topAnchor, constant: 12),
            articleLabel.leadingAnchor.constraint(equalTo: containerViewForArticle.leadingAnchor, constant: 8),
            articleLabel.trailingAnchor.constraint(equalTo: containerViewForArticle.trailingAnchor, constant: -8),

            // Article Label to Link Constraints
            articleLabelToLink.topAnchor.constraint(equalTo: articleLabel.bottomAnchor, constant: 12),
            articleLabelToLink.leadingAnchor.constraint(equalTo: containerViewForArticle.leadingAnchor, constant: 8),
            articleLabelToLink.trailingAnchor.constraint(equalTo: containerViewForArticle.trailingAnchor, constant:   -8),
            articleLabelToLink.bottomAnchor.constraint(equalTo: containerViewForArticle.bottomAnchor, constant: -8),
        ])
    }

    func setUpConstraintsForPageControl() {
        NSLayoutConstraint.activate([
            // Container View for Page Control Constraints
            containerViewForPageControl.topAnchor.constraint(equalTo: containerViewForArticle.bottomAnchor, constant: 20),
            containerViewForPageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerViewForPageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerViewForPageControl.bottomAnchor.constraint(greaterThanOrEqualTo: scrollViewForPage.bottomAnchor, constant: -20),

            // Three Words Label Constraints
            threeWordsLabel.topAnchor.constraint(equalTo: containerViewForPageControl.topAnchor, constant: 12),
            threeWordsLabel.leadingAnchor.constraint(equalTo: containerViewForPageControl.leadingAnchor, constant: 8),
            threeWordsLabel.trailingAnchor.constraint(equalTo: containerViewForPageControl.trailingAnchor, constant: -8),

            // Scroll View Constraints
            scrollView.topAnchor.constraint(equalTo: threeWordsLabel.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -5),

            // Page Control Constraints
            pageControl.leadingAnchor.constraint(equalTo: containerViewForPageControl.leadingAnchor, constant: 8),
            pageControl.trailingAnchor.constraint(equalTo: containerViewForPageControl.trailingAnchor, constant: -8),
            pageControl.bottomAnchor.constraint(equalTo: containerViewForPageControl.bottomAnchor, constant: -10)
        ])
    }

    func setupConstraints() {
        setUpConstraintsForPageScrollView()
        setUpConstraintsForQuote()
        setUpConstraintsForArticle()
        setUpConstraintsForPageControl()
    }
}
