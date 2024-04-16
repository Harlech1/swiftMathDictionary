//
//  SettingTableViewCell.swift
//  matheng
//
//  Created by Türker Kızılcık on 7.12.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    var switchControl = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        //accessoryView = switchControl
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Kullanıcı bildirimleri kapattıysa UserDefaults içine bu durumu kaydedin
    @objc func switchValueChanged(_ sender: UISwitch) {
        let notificationEnabled = sender.isOn
        UserDefaults.standard.set(notificationEnabled, forKey: "NotificationEnabled")
    }

    // Bildirim göndermek istediğinizde bu tercihi kontrol edin
    func sendNotificationIfAllowed() {
        if let notificationEnabled = UserDefaults.standard.value(forKey: "NotificationEnabled") as? Bool {
            if !notificationEnabled {
                print("Kullanıcı bildirimleri kapattı, yeni bildirim gönderilemiyor.")
            }
        }
    }
     */


}
