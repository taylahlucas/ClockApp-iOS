//
//  LocalNotificationManager.swift
//  ClockApp
//
//  Created by Taylah Lucas on 9/10/19.
//  Copyright © 2019 Taylah Lucas. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification {
    let id: String
    let title: String
    let dateTime: DateComponents
}

class LocalNotificationManager {
    var notifications: [Notification] = [Notification]()
    
    // Debug what notificiations have been scheduled
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    // Prompts the user to give permission to send notifications
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    // Starts notification permissions and scheduling
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }

    // Iterates over the notifications property to schedule local notifications
    private func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateTime, repeats: true)
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                
                print("Notification scheduled! -- ID = \(notification.id) dateTime + \(notification.dateTime)")
                
                self.listScheduledNotifications()
            }
        }
    }
}
