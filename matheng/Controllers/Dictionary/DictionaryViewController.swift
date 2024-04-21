//
//  ThreeWordsViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 11.10.2023.
//

import UIKit

class DictionaryViewController: UIViewController, UISearchControllerDelegate {

    var turkishWords = Constant.Words.turkishWords

    var selectedIndex = 0

    var filteredData: [String] = []

    var sections: [String: [String]] = [:]
    var stringArray: [String] = []

    lazy var tableView = initTableView()
    lazy var searchController = initSearchController()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "dictionary".localized

        view.backgroundColor = UIColor.systemGroupedBackground

        addSubviews()
        setupConstraints()
        setupNavigationItems()

        filteredData = turkishWords
        filteredData.sort()
        updateSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenIndex = selectedIndex
        }
    }

    private func updateSections() {
        sections.removeAll()

        for word in filteredData {
            guard let firstChar = word.first else {
                continue
            }
            let firstLetter = String(firstChar).uppercased()
            if sections[firstLetter] == nil {
                sections[firstLetter] = [word]
            } else {
                sections[firstLetter]?.append(word)
            }
        }
        tableView.reloadData()
    }

    private func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredData = turkishWords
        } else {
            filteredData = turkishWords.filter { item in
                return item.lowercased().contains(searchText.lowercased())
            }
        }
        updateSections()
    }
}

extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedSectionTitles = sections.keys.sorted()
        return sortedSectionTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedSectionTitles = sections.keys.sorted()
        let sectionTitle = sortedSectionTitles[section]
        return sections[sectionTitle]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sortedSectionTitles = sections.keys.sorted()
        let sectionTitle = sortedSectionTitles[indexPath.section]
        let wordsInSection = sections[sectionTitle] ?? []
        cell.textLabel?.text = wordsInSection[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortedSectionTitles = sections.keys.sorted()
        let sectionTitle = sortedSectionTitles[indexPath.section]
        let wordsInSection = sections[sectionTitle] ?? []

        guard let indexInOriginalData = turkishWords.firstIndex(of: wordsInSection[indexPath.row]) else {
            return
        }
        selectedIndex = indexInOriginalData
        performSegue(withIdentifier: "toDetails", sender: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredData = turkishWords
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(searchText)
    }
}
