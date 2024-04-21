//
//  WordOfTheDayViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 11.10.2023.
//

import UIKit

class HomeViewController: UIViewController {

    var selectedWords: [String] = ["Placeholder_1","Placeholder_2","Placeholder_3"]
    var selectedIndex = 0
    var labels: [UILabel] = []

    lazy var containerViewForQuote = initContainerView()
    lazy var containerViewForArticle = initContainerView()
    lazy var containerViewForPageControl = initContainerView()

    lazy var quoteLabel = initLabel(text: "quote".localized)
    lazy var articleLabel = initLabel(text: "article_for_day".localized)
    lazy var threeWordsLabel = initLabel(text: "todays_words".localized)

    lazy var articleLabelToLink = initLinkLabel()
    lazy var quoteTextView = initQuoteTextView()

    lazy var scrollView = initScrollView()
    lazy var scrollViewForPage = initScrollView()
    lazy var pageControl = initPageControl()

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

        addSubviews()

        articleLabelToLink.attributedText = underline()
        addTapGesture(to: articleLabelToLink, target: self, action: #selector(labelTappedToArticle))

        pageControl.numberOfPages = selectedWords.count
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)

        setupConstraints()
        scheduleDailyUpdate()
        setScrollView()
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
