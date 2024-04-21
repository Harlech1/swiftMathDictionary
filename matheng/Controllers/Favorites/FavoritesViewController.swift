//
//  MemorizeThreeWordViewController.swift
//  matheng
//
//  Created by Nikolay Melzack on 12.10.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!

    var wordArray = [String]()
    var idArray = [UUID]()

    var selectedWord = ""
    var selectedWordID: UUID?

    var selectedIndex = 0

    let turkishWords: [String] = Constant.Words.turkishWords

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let upperLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "no_favorites".localized)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 21.0)], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let lowerLabel: UILabel = {
        let label = UILabel()
        label.text = "no_favorites_subtext".localized
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .systemGray
        label.font = FontHelper.scaledFont15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(containerView)
        title = "favorites".localized

        containerView.addSubview(upperLabel)
        containerView.addSubview(lowerLabel)

        tableView.delegate = self
        tableView.dataSource = self

        getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }

        if !tableView.visibleCells.isEmpty {
            containerView.isHidden = true
            upperLabel.isHidden = true
            lowerLabel.isHidden = true
        } else {
            containerView.isHidden = false
            upperLabel.isHidden = false
            lowerLabel.isHidden = false
        }

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            upperLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            upperLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            upperLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),

            lowerLabel.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 3),
            lowerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            lowerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            lowerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])

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
