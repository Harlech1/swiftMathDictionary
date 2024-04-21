//
//  ColorPickerViewController.swift
//  matheng
//
//  Created by Türker Kızılcık on 3.12.2023.
//

import UIKit

class ColorPickerViewController: UIViewController {

    var lastTappedColorView: UIView?

    let colors: [UIColor] = [
        UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0), // Kırmızı tonu
        UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0), // Turuncu tonu
        UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0), // Sarı tonu
        UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0), // Yeşil tonu
        UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0), // Mavi tonu
        UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), // Kobalt mavi tonu
        .myOrange,
        UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0), // Mor tonu
        UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0), // Pembe tonu
        UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0), // Jambonun pembesi
        UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0), // Eflatun tonu
        UIColor(red: 246/255, green: 201/255, blue: 215/255, alpha: 1.0) // Sadness rengi
    ]

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemGroupedBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "color_picker".localized
        
        view.backgroundColor = UIColor.systemGroupedBackground

        view.addSubview(containerView)

        containerView.backgroundColor = UIColor.secondarySystemGroupedBackground

        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = UIBarButtonItem(title: "done".localized, style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }

    @objc func cancelButtonTapped() {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }

    @objc func doneButtonTapped() {
        guard let tappedColorView = lastTappedColorView else { return }

        let color = tappedColorView.backgroundColor

        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: color!, requiringSecureCoding: false)
            UserDefaults.standard.set(colorData, forKey: "color")
            tabBarController?.tabBar.tintColor = color
        } catch {
            print("Hata: \(error)")
        }
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setColorsUI()

        if let colorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    for subview in containerView.subviews {
                        if subview.backgroundColor == savedColor {
                            subview.layer.borderWidth = 5.0
                            subview.layer.borderColor = UIColor.gray.cgColor
                        }
                    }
                }
            } catch {}
        }
    }

    func getOffset() -> CGFloat {
        let x = (view.frame.size.width - 20)-(240.0)
        let y = x/7.0
        return y
    }

    func setColorsUI() {
        var offsetX: CGFloat = getOffset()
        let offsetY: CGFloat = getOffset() + 40

        for (index, color) in colors.enumerated() {
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 20
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped(_:)))
            colorView.isUserInteractionEnabled = true
            colorView.addGestureRecognizer(tapGesture)
            colorView.clipsToBounds = true

            containerView.addSubview(colorView)

            if(index < 6) {
                NSLayoutConstraint.activate([
                    colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: getOffset()),
                    colorView.widthAnchor.constraint(equalToConstant: 40),
                    colorView.heightAnchor.constraint(equalToConstant: 40),
                    colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offsetX),

                ])
            } else {
                NSLayoutConstraint.activate([
                    colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: getOffset() + offsetY),
                    colorView.widthAnchor.constraint(equalToConstant: 40),
                    colorView.heightAnchor.constraint(equalToConstant: 40),
                    colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offsetX-(6*(getOffset()+40))),
                    colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -getOffset()),
                ])
            }
            offsetX += getOffset() + 40
        }
    }

    @objc func colorViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedColorView = sender.view else { return }

        lastTappedColorView = tappedColorView

        let borderWidth: CGFloat = 5.0
        let borderColor: UIColor = .gray

        containerView.subviews.forEach { subview in
            subview.layer.borderWidth = 0
        }

        tappedColorView.layer.borderWidth = borderWidth
        tappedColorView.layer.borderColor = borderColor.cgColor
    }
}

