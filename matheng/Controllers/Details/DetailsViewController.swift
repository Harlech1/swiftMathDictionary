//
//  DetailsViewController.swift
//  matheng
//
//  Created by Turker Kizilcik on 11.10.2023.
//

import WebKit
import CoreData

class DetailsViewController: UIViewController, WKNavigationDelegate {

    var chosenIndex = 0

    var webView: WKWebView!
    var count = 0
    var chosenWord: String?
    var chosenWordID: UUID?

    let turkishWords = Constant.Words.turkishWords

    let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let labelForTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.scaledFont21Bold
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rectangleView)

        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            switch path.status {
            case .satisfied:
                DispatchQueue.main.async { [self] in
                    self.callUrl(name: self.chosenWord ?? self.turkishWords[self.chosenIndex])
                }
            case .unsatisfied:
                showError(title: "Hata", message: "Ağ bağlantısı yok veya kullanılabilir değil.")
            case .requiresConnection:
                showError(title: "Hata", message: "Bağlantı gerekiyor anca henüz kurulmamış.")
            @unknown default:
                showError(title: "Hata", message: "Bilinmeyen ağ durumu.")
            }
        }

        let queue = DispatchQueue(label: "MonitorDispatchQueue")
        monitor.start(queue: queue)

        view.addSubview(webView)

        rectangleView.addSubview(labelForTitle)
        labelForTitle.text = chosenWord ?? turkishWords[chosenIndex]

        setUpConstraints()
    }

    // MARK: Favorite Checker/Fetcher/Toggler
    private func checkIfFavorited(_ word: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        let predicate = NSPredicate(format: "word == %@ AND favorited == true", word)
        fetchRequest.predicate = predicate

        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("error")
            return false
        }
    }

    private func toggleFavoriteStatus(forWord word: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let wordObject = fetchWord(with: word) else {
            print("Kelime bulunamadı.")
            return
        }
        wordObject.favorited = !wordObject.favorited
        do {
            try context.save()
        } catch {
            print("error")
        }
    }

    private func fetchWord(with word: String) -> Favorites? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "word == %@", word)

        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("error")
            return nil
        }
    }

    @objc func heartButtonClicked() {
        let isFavorited = checkIfFavorited(labelForTitle.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if isFavorited {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart") // Boş kalp simgesi
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.predicate = NSPredicate(format: "word = %@", labelForTitle.text!)

            do {
                let result = try context.fetch(fetchRequest)
                if let objectToDelete = result.first as? NSManagedObject {
                    context.delete(objectToDelete)
                    try context.save()
                }
            } catch {
                print("error")
            }
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            let newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
            newFavorite.setValue(labelForTitle.text!, forKey: "word")
            newFavorite.setValue(UUID(), forKey: "id")
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
        }

        toggleFavoriteStatus(forWord: labelForTitle.text!)
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object:nil)
        self.navigationController?.popViewController(animated: true)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let nsError = error as NSError
        
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            showError(title: "İnternet Bağlantısı Yok", message: "Lütfen internet bağlantınızı kontrol edin.")
        case NSURLErrorTimedOut:
            showError(title: "Zaman Aşımı Hatası", message: "İstek zaman aşımına uğradı. Lütfen tekrar deneyin.")
        case NSURLErrorCannotFindHost:
            showError(title: "Host Bulunamadı", message: "Belirtilen host bulunamadı.")
        case NSURLErrorCannotConnectToHost:
            showError(title: "Host'a Bağlanılamıyor", message: "Belirtilen host ile bağlantı kurulamıyor.")
        case NSURLErrorNetworkConnectionLost:
            showError(title: "Bağlantı Kesildi", message: "İnternet bağlantısı kayboldu.")
        case NSURLErrorCancelled:
            showError(title: "İstek İptal Edildi", message: "İstek iptal edildi.")
        case NSURLErrorBadURL:
            showError(title: "Geçersiz URL", message: "Lütfen geçerli bir URL kullanın.")
        case NSURLErrorSecureConnectionFailed:
            showError(title: "Güvenli Bağlantı Başarısız", message: "Güvenli bağlantı kurulamadı.")
        default:
            showError(title: "Bilinmeyen Hata", message: "Bir hata oluştu.")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.webView.isHidden = false
        }
    }

    private func callUrl(name: String) {
        let originalString = name
        if let encodedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "https://harlech1.github.io/DictionaryOfMaths/\(encodedString).html") {
                let request = URLRequest(url: url)
                webView.navigationDelegate = self
                webView.load(request)
            }
        }
    }

    private func showError(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            rectangleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            rectangleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            rectangleView.heightAnchor.constraint(equalToConstant: 200),

            webView.topAnchor.constraint(equalTo: rectangleView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            labelForTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelForTitle.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor),
            labelForTitle.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -20)
        ])
    }
    // MARK: Override Functions
    override func viewWillAppear(_ animated: Bool) {

        count += 1

        if(count < 2) {
            webView.isHidden = true
        }

        if self.traitCollection.userInterfaceStyle == .dark {
            tabBarController?.tabBar.backgroundColor = UIColor.systemGroupedBackground
            view.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        } else {
            view.backgroundColor = UIColor.white
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: checkIfFavorited(labelForTitle.text ?? "idk") ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(heartButtonClicked))

        if let savedColorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                    tabBarController?.tabBar.tintColor = savedColor
                    navigationItem.rightBarButtonItem?.tintColor = savedColor
                }
            } catch {
                tabBarController?.tabBar.tintColor = .myOrange
            }
        }
    }
}


