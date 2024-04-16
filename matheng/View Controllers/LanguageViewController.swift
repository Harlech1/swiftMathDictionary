//
//  LanguageViewController.swift
//  matheng
//
//  Created by Türker Kızılcık on 17.12.2023.
//

import UIKit

class LanguageViewController: UIViewController {

    let deviceLanguageCode = Locale.current.languageCode
    let languages = ["Türkçe", "English" ]
    let languagesDetail = ["Turkish", "Default"]
    let languagesTR = ["Türkçe", "English"]
    let languagesDetailTR = ["Varsayılan", "İngilizce"]
    var totalHeight : CGFloat = 0.0
    var tableView : UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "language".localized

        view.backgroundColor = UIColor.systemGroupedBackground

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 15
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalHeight = 0.0

        for i in 0..<languages.count {
            let cellHeight = tableView.rectForRow(at: IndexPath(row: i, section: 0)).size.height
            totalHeight += cellHeight
        }

        setUpConstraints()
        tableView.reloadData()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: totalHeight),
        ])
    }

}


extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let appLanguage = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"

        if(appLanguage == "tr") {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
            cell.detailTextLabel?.textColor = .lightGray
            cell.backgroundColor = UIColor.secondarySystemGroupedBackground
            cell.textLabel?.text = languagesTR[indexPath.row]
            cell.detailTextLabel?.text = languagesDetailTR[indexPath.row]
            if(indexPath.row == 0) {
                cell.accessoryType = .checkmark
            }
            if let savedColorData = UserDefaults.standard.data(forKey: "color") {
                do {
                    if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                        tabBarController?.tabBar.tintColor = savedColor
                    }
                } catch {
                    tabBarController?.tabBar.tintColor = .myOrange
                }
            }

            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellIdentifier")
            cell.detailTextLabel?.textColor = .lightGray
            cell.backgroundColor = UIColor.secondarySystemGroupedBackground
            cell.textLabel?.text = languages[indexPath.row]
            cell.detailTextLabel?.text = languagesDetail[indexPath.row]
            if(indexPath.row == 1) {
                cell.accessoryType = .checkmark
            }
            if let savedColorData = UserDefaults.standard.data(forKey: "color") {
                do {
                    if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                        tabBarController?.tabBar.tintColor = savedColor
                    }
                } catch {
                    tabBarController?.tabBar.tintColor = .myOrange
                }
            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeAppLanguage(to: "tr")
            restartApplication()
        case 1:
            changeAppLanguage(to: "en")
            restartApplication()
        default:
            print("hello")
        }
    }

    func changeAppLanguage(to languageCode: String) {
        UserDefaults.standard.set(languageCode, forKey: "appLanguage")
    }

    private func restartApplication() {
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }



}
