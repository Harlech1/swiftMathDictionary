//
//  MemorizeThreeWordViewController.swift
//  matheng
//
//  Created by Nikolay Melzack on 12.10.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController{

    var wordArray = [String]()
    var idArray = [UUID]()

    var selectedWord = ""
    var selectedWordID: UUID?

    var selectedIndex = 0

    let turkishWords: [String] = Constant.Words.turkishWords

    lazy var tableView = initTableView()

    lazy var noFavoritesView = initNoFavoritesView()
    lazy var noFavoritesTitleLabel = initNoFavoritesTitleLabel()
    lazy var noFavoritesSubtitleLabel = initNoFavoritesSubtitleLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "favorites".localized

        addSubviews()
        setupConstraints()

        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }

        setNoFavoritesView()

        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        tableView.reloadData()
    }

    @objc func getData() {
        wordArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity:  false)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let word = result.value(forKey: "word") as? String {
                        self.wordArray.append(word)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("error")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDictionaryWithoutBar" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenWord = selectedWord
            destinationVC.chosenWordID = selectedWordID
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = wordArray[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexInOriginalData = turkishWords.firstIndex(of: wordArray[indexPath.row]) else {
            return
        }
        selectedWord = turkishWords[indexInOriginalData]
        performSegue(withIdentifier: "toDictionaryWithoutBar", sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                wordArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                } catch {
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }
}
