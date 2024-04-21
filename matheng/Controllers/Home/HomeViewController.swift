//
//  WordOfTheDayViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 11.10.2023.
//

import UIKit

class HomeViewController: UIViewController {

    var selectedWords : [String] = ["Placeholder_1","Placeholder_2","Placeholder_3"]
    var selectedIndex = 0
    var labels: [UILabel] = []

    var containerViewForQuote: UIView!
    var containerViewForArticle: UIView!
    var containerViewForPageControl: UIView!

    var quoteLabel: UILabel!
    var articleLabel: UILabel!
    var threeWordsLabel: UILabel!

    lazy var articleLabelToLink : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.link
        label.font = FontHelper.scaledFont17
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()

    // MARK: TextView + ScrollView + Page Control Views
    lazy var quoteTextView: UITextView = {
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
    }()

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var scrollViewForPage: UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var pageControl: UIPageControl = {
        let pg = UIPageControl()
        pg.currentPage = 0
        pg.tintColor = .myOrange
        pg.currentPageIndicatorTintColor = .myOrange
        pg.pageIndicatorTintColor = .gray
        pg.translatesAutoresizingMaskIntoConstraints = false
        return pg
    }()

    // MARK: Constants
    let quotes = Constant.Quotes.mathematicalQuotes
    let headers = Constant.Article.headers
    let turkishWords = Constant.Words.turkishWords

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "home".localized

        self.tabBarController?.tabBar.items?[0].title = "home".localized
        self.tabBarController?.tabBar.items?[1].title = "favorites".localized
        self.tabBarController?.tabBar.items?[2].title = "dictionary".localized
        self.tabBarController?.tabBar.items?[3].title = "settings".localized

        view.backgroundColor = UIColor.systemGroupedBackground

        view.addSubview(scrollViewForPage)

        setUpContainerViews()
        setUpLabels()

        scrollViewForPage.addSubview(containerViewForQuote)

        containerViewForQuote.addSubview(quoteLabel)
        containerViewForQuote.addSubview(quoteTextView)

        scrollViewForPage.addSubview(containerViewForArticle)

        containerViewForArticle.addSubview(articleLabel)
        containerViewForArticle.addSubview(articleLabelToLink)

        articleLabelToLink.attributedText = underline()
        addTapGesture(to: articleLabelToLink, target: self, action: #selector(labelTappedToArticle))

        scrollViewForPage.addSubview(containerViewForPageControl)
        containerViewForPageControl.addSubview(threeWordsLabel)
        containerViewForPageControl.addSubview(scrollView)
        containerViewForPageControl.addSubview(pageControl)

        pageControl.numberOfPages = selectedWords.count
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)

        scrollView.delegate = self

        setUpConstraintsForPageScrollView()
        setUpConstraintsForQuote()
        setUpConstraintsForArticle()
        setUpConstraintsForPageControl()

        scheduleDailyUpdate()
        setScrollView()
    }

    private func setUpConstraintsForPageScrollView() {
        NSLayoutConstraint.activate([
            scrollViewForPage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewForPage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollViewForPage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollViewForPage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setUpConstraintsForQuote() {
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

    private func setUpConstraintsForArticle() {
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

    private func setUpConstraintsForPageControl() {
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

    // MARK: UI Functions
    private func createContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func setUpContainerViews() {
        containerViewForQuote = createContainerView()
        containerViewForArticle = createContainerView()
        containerViewForPageControl = createContainerView()
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = FontHelper.scaledFont21Bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func setUpLabels() {
        quoteLabel = createLabel(text: "quote".localized)
        articleLabel = createLabel(text: "article_for_day".localized)
        threeWordsLabel = createLabel(text: "todays_words".localized)
    }

    private func setScrollView() {
        var offset: CGFloat = 0.0

        for text in selectedWords {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.clipsToBounds = true
            label.font = FontHelper.scaledFont17
            label.textColor = .systemBlue
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTappedInScrollView))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
            label.translatesAutoresizingMaskIntoConstraints = false

            scrollView.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: scrollView.topAnchor),
                label.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                label.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: offset)
            ])

            offset += view.frame.width
        }
        scrollView.contentSize = CGSize(width: offset, height: scrollView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = currentPage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDictionaryInHome" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenIndex = selectedIndex
        }

        if segue.identifier == "toArticle" {
            let destinationVC = segue.destination as! ArticleViewController
            destinationVC.chosenIndex = selectedIndex
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let savedColorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                    tabBarController?.tabBar.tintColor = savedColor
                    quoteTextView.layer.borderColor = savedColor.cgColor
                    pageControl.tintColor = savedColor
                    pageControl.currentPageIndicatorTintColor = savedColor
                }
            } catch {
                quoteTextView.layer.borderColor = UIColor.myOrange.cgColor
                tabBarController?.tabBar.tintColor = .myOrange
            }
        }
        scheduleDailyUpdateForQuotes()
    }

    override func viewDidAppear(_ animated: Bool) {
        var totalHeight: CGFloat = 100.0
        totalHeight += containerViewForQuote.frame.size.height
        totalHeight += containerViewForArticle.frame.size.height
        totalHeight += containerViewForPageControl.frame.size.height

        scrollViewForPage.contentSize = CGSize(width: scrollViewForPage.frame.size.width, height: totalHeight)
    }

    private func addTapGesture(to view: UIView, target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }

    private func underline() -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: UserDefaults.standard.string(forKey: "wordOfTheDayLabel") ?? "Error, try restarting.")
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        return attributedString
    }

    private func generateRandom3WordsOfTheDay() {
        var uniqueIndices = Set<Int>()
        while uniqueIndices.count < 3 {
            let randomIndex = Int.random(in: 0..<turkishWords.count)
            uniqueIndices.insert(randomIndex)
        }

        selectedWords = uniqueIndices.map { turkishWords [$0] }
    }

    private func scheduleDailyUpdate() {
        let lastUpdateDate = UserDefaults.standard.value(forKey: "lastUpdateDateFor3Words") as? Date

        if let lastUpdateDate = lastUpdateDate, Calendar.current.isDateInToday(lastUpdateDate) {
            selectedWords[0] = UserDefaults.standard.string(forKey: "wordOfTheDayLabelFor3Words1") ?? "nil"
            selectedWords[1] = UserDefaults.standard.string(forKey: "wordOfTheDayLabelFor3Words2") ?? "nil"
            selectedWords[2] = UserDefaults.standard.string(forKey: "wordOfTheDayLabelFor3Words3") ?? "nil"
        } else {
            generateRandom3WordsOfTheDay()

            UserDefaults.standard.set(Date(), forKey: "lastUpdateDateFor3Words")
            
            UserDefaults.standard.set(selectedWords[0], forKey: "wordOfTheDayLabelFor3Words1")
            UserDefaults.standard.set(selectedWords[1], forKey: "wordOfTheDayLabelFor3Words2")
            UserDefaults.standard.set(selectedWords[2], forKey: "wordOfTheDayLabelFor3Words3")
        }
    }

    private func updateArticleOfTheDay() {
        let randomIndex = Int.random(in: 0..<headers.count)
        articleLabelToLink.text = headers[randomIndex]
    }

    private func updateQuoteOfTheDay() {
        let randomIndex = Int.random(in: 0..<quotes.count)
        quoteTextView.text = quotes[randomIndex]
    }

    private func scheduleDailyUpdateForQuotes() {
        let lastUpdateDate = UserDefaults.standard.value(forKey: "lastUpdateDate") as? Date

        if let lastUpdateDate = lastUpdateDate, Calendar.current.isDateInToday(lastUpdateDate) {
            articleLabelToLink.text = UserDefaults.standard.string(forKey: "wordOfTheDayLabel")
            quoteTextView.text = UserDefaults.standard.string(forKey: "quoteOfTheDay")
        } else {
            updateArticleOfTheDay()
            updateQuoteOfTheDay()

            UserDefaults.standard.set(Date(), forKey: "lastUpdateDate")
            UserDefaults.standard.set(articleLabelToLink.text, forKey: "wordOfTheDayLabel")
            UserDefaults.standard.set(quoteTextView.text, forKey: "quoteOfTheDay")
        }
    }

    @objc func labelTappedToArticle() {
        guard let indexInOriginalData = headers.firstIndex(of: articleLabelToLink.text!) else {
            return
        }
        selectedIndex = indexInOriginalData
        performSegue(withIdentifier: "toArticle", sender: nil)
    }

    @objc func labelTappedInScrollView(_ sender: UITapGestureRecognizer) {
        if let tappedLabel = sender.view as? UILabel {
            if let index = turkishWords.firstIndex(of: tappedLabel.text ?? "nil") {
                selectedIndex = index
                performSegue(withIdentifier: "toDictionaryInHome", sender: nil)
            }
        }
    }

    @objc func pageControlDidChange() {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    @objc func goToDictionary() {
        performSegue(withIdentifier: "toDictionaryInHome", sender: nil)
    }
}

extension HomeViewController: UIScrollViewDelegate {}
