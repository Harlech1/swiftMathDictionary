//
//  ArticleViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 22.10.2023.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var chosenIndex = 0
    
    var headers = Constants.headers
    var scripts = Constants.scripts

    let textView : UITextView = {
        let textView : UITextView = UITextView()
        textView.backgroundColor = UIColor.secondarySystemGroupedBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        title = "article".localized
        view.addSubview(textView)

        textView.text = scripts[chosenIndex]

        setUpConstraints()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
