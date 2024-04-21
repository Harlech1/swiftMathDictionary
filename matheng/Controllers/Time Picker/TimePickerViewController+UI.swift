//
//  TimePickerViewController+UI.swift
//  matheng
//
//  Created by Türker Kızılcık on 21.04.2024.
//

import Foundation
import UIKit

extension TimePickerViewController {
    func initTimePicker() -> UIDatePicker {
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        timePicker.layer.borderColor = UIColor.myOrange.cgColor
        timePicker.layer.borderWidth = 1.0
        timePicker.layer.cornerRadius = 10
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        return timePicker
    }

    func addSubviews() {
        view.addSubview(timePicker)
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            timePicker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    func setNavigationItems() {
        let doneButton = UIBarButtonItem(title: "done".localized, style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
}
