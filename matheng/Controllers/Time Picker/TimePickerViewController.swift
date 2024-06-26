//
//  TimePickerViewController.swift
//  matheng
//
//  Created by Türker Kızılcık on 7.12.2023.
//

import UIKit

class TimePickerViewController: UIViewController {
    
    let selectedTimeKey = "selectedTime"
    let settingsOptions = ["Allow Notifications"]

    lazy var timePicker = initTimePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "time_picker".localized
        
        view.backgroundColor = UIColor.systemGroupedBackground

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        let defaultDate = calendar.date(from: dateComponents)

        timePicker.date = defaultDate!

        if let savedTime = UserDefaults.standard.object(forKey: selectedTimeKey) as? Date {
            timePicker.date = savedTime
        } else {
            let selectedTime = defaultDate
            UserDefaults.standard.set(selectedTime, forKey: selectedTimeKey)
        }
        
        setNavigationItems()
        setUpConstraints()
        scheduleDailyNotificationFromUserDefaults()
    }

    @objc func doneButtonTapped() {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }

    private func scheduleDailyNotificationFromUserDefaults() {
        let content = UNMutableNotificationContent()
        content.title = "Hatırlatıcı"
        content.body = "Günlük 3 kelimeniz oluşturuldu kontrol etmeyi unutmayın."
        content.badge = 0
        content.sound = UNNotificationSound.default
        
        let userDefaults = UserDefaults.standard

        if let savedDate = userDefaults.object(forKey: selectedTimeKey) as? Date {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: savedDate)

            var triggerComponents = DateComponents()
            triggerComponents.hour = dateComponents.hour
            triggerComponents.minute = dateComponents.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Bildirim oluşturulamadı: \(error.localizedDescription)")
                } else {
                    print("Bildirim başarıyla oluşturuldu")
                }
            }
        } else {
            print("UserDefaults'tan kaydedilen tarih bulunamadı.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let savedColorData = UserDefaults.standard.data(forKey: "color") {
            do {
                if let savedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: savedColorData) {
                    tabBarController?.tabBar.tintColor = savedColor
                    timePicker.layer.borderColor = savedColor.cgColor
                    timePicker.layer.borderWidth = 1.0
                }
            } catch {
                timePicker.layer.borderColor = UIColor.myOrange.cgColor
                tabBarController?.tabBar.tintColor = .myOrange
            }
        }
    }

    @objc func timeChanged(sender: UIDatePicker) {
        let selectedTime = sender.date
        print(selectedTime)
        UserDefaults.standard.set(selectedTime, forKey: selectedTimeKey)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: selectedTime)

        print("Seçilen Zaman: \(formattedTime)")
        scheduleDailyNotificationFromUserDefaults()
    }
}
