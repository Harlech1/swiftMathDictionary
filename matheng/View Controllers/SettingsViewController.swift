//
//  SettingsViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 11.10.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView : UITableView!
    var totalHeight : CGFloat = 0.0
    let settingsData = ["theme".localized, "notifications".localized, "language".localized]
    let images = ["paintpalette.fill","bell.fill","globe"]
    let appLanguage = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGroupedBackground

        title = "settings".localized

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 15
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var languageString = ""

        if(appLanguage == "tr") {
            languageString = "Türkçe"
        } else {
            languageString = "English"
        }
        let cell = UITableViewCell()
        let image = UIImage(systemName: images[indexPath.row])
        cell.backgroundColor = UIColor.secondarySystemGroupedBackground
        cell.textLabel?.text = settingsData[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.tintColor = .myOrange
        cell.imageView?.image = image

        if indexPath.row == 2 {
            let specificCell = UITableViewCell(style: .value1, reuseIdentifier: "specificCellIdentifier")
            specificCell.backgroundColor = UIColor.secondarySystemGroupedBackground
            specificCell.textLabel?.text = settingsData[indexPath.row]
            specificCell.detailTextLabel?.textColor = .lightGray
            specificCell.detailTextLabel?.text = languageString
            specificCell.accessoryType = .disclosureIndicator
            specificCell.imageView?.tintColor = .myOrange
            specificCell.imageView?.image = image
            if let savedColorData = UserDefaults.standard.data(forKey: "color") {
                do {
                    if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                        tabBarController?.tabBar.tintColor = savedColor
                        specificCell.imageView?.tintColor = savedColor
                    }
                } catch {
                    specificCell.imageView?.tintColor = .myOrange
                    tabBarController?.tabBar.tintColor = .myOrange
                }
            }
            return specificCell
        }

        if let savedColorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                    tabBarController?.tabBar.tintColor = savedColor
                    cell.imageView?.tintColor = savedColor
                }
            } catch {
                cell.imageView?.tintColor = .myOrange
                tabBarController?.tabBar.tintColor = .myOrange
            }
        }
        
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toColorPicker", sender: nil)
        case 1:
            performSegue(withIdentifier: "toTimePicker", sender: nil)
        case 2:
            performSegue(withIdentifier: "toLanguage", sender: nil)
        default:
            print("error")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalHeight = 0.0

        for i in 0..<settingsData.count {
            let cellHeight = tableView.rectForRow(at: IndexPath(row: i, section: 0)).size.height
            totalHeight += cellHeight
        }

        setUpConstraints()
        tableView.reloadData()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        UIView.animate(withDuration: 1) {
//            contant = UIScreen.main.bounds.height / 2
//            self.view.layoutIfNeeded()
//        }
//    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: totalHeight),
        ])
    }

    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        tableView.reloadData()
    }

}

