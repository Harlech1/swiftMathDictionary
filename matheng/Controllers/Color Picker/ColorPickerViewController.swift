//
//  ColorPickerViewController.swift
//  matheng
//
//  Created by Türker Kızılcık on 3.12.2023.
//

import UIKit

class ColorPickerViewController: UIViewController {

    var lastTappedColorView: UIView?
    
    let colors = Constant.Colors.appThemeColors

    lazy var colorContainerView = initColorContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "color_picker".localized
        
        view.backgroundColor = UIColor.systemGroupedBackground

        addSubviews()
        setupNavigationItems()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setColorsUI()

        if let colorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
                    for subview in colorContainerView.subviews {
                        if subview.backgroundColor == savedColor {
                            subview.layer.borderWidth = 5.0
                            subview.layer.borderColor = UIColor.gray.cgColor
                        }
                    }
                }
            } catch {}
        }
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

            colorContainerView.addSubview(colorView)

            if(index < 6) {
                NSLayoutConstraint.activate([
                    colorView.topAnchor.constraint(equalTo: colorContainerView.topAnchor, constant: getOffset()),
                    colorView.widthAnchor.constraint(equalToConstant: 40),
                    colorView.heightAnchor.constraint(equalToConstant: 40),
                    colorView.leadingAnchor.constraint(equalTo: colorContainerView.leadingAnchor, constant: offsetX),

                ])
            } else {
                NSLayoutConstraint.activate([
                    colorView.topAnchor.constraint(equalTo: colorContainerView.topAnchor, constant: getOffset() + offsetY),
                    colorView.widthAnchor.constraint(equalToConstant: 40),
                    colorView.heightAnchor.constraint(equalToConstant: 40),
                    colorView.leadingAnchor.constraint(equalTo: colorContainerView.leadingAnchor, constant: offsetX-(6*(getOffset()+40))),
                    colorView.bottomAnchor.constraint(equalTo: colorContainerView.bottomAnchor, constant: -getOffset()),
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

        colorContainerView.subviews.forEach { subview in
            subview.layer.borderWidth = 0
        }

        tappedColorView.layer.borderWidth = borderWidth
        tappedColorView.layer.borderColor = borderColor.cgColor
    }
}

