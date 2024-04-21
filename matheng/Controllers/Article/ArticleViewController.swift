//
//  ArticleViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 22.10.2023.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var chosenIndex = 0
    
    var headers = Constant.Article.headers
    var scripts = Constant.Article.scripts

    lazy var articleTextView = initArticleTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        title = "article".localized

        addSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        articleTextView.text = scripts[chosenIndex]
    }
}
