//
//  SettingsView.swift
//  Platz für Teams
//
//  Created by Alexander Wolf on 14.11.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var student: Student
    @Binding var allowNotifications: Bool
    @State var sliderValue: Double = 5.0
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Image(systemName: "envelope.circle")
                    Toggle("Push-Benachrichtigungen erlauben", isOn: $allowNotifications)
                        .onChange(of: allowNotifications) { _allowNotifications in
                            if !_allowNotifications {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            } else {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        for booking in student.bookings {
                                            let content = UNMutableNotificationContent()
                                            content.title = "Platz für Teams"
                                            content.subtitle = "Reservierungserinnerung"
                                            let time = String(format: "%.f", student.notificationTime)
                                            content.body = "Deine Buchung des Lernplatzes \(booking.learningSpace.name) im Gebäude \(booking.learningSpace.building) startet in \(time) Minuten."
                                            content.sound = UNNotificationSound.default
                                            let notificationMoment = booking.from - student.notificationTime * 60
                                            let calenderDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute], from: notificationMoment)
                                            let trigger = UNCalendarNotificationTrigger(dateMatching: calenderDate, repeats: false)

                                            let request = UNNotificationRequest(identifier: booking.learningSpace.UUID, content: content, trigger: trigger)

                                            UNUserNotificationCenter.current().add(request)
                                        }
                                    } else if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                }
                .padding()
                Divider()
                VStack {
                    Text("Wieviele Minunten vor deiner Buchung möchtest du an diese erinnert werden?")
                        .padding()
                    Text("\(sliderValue, specifier: "%.f") Minuten")
                        .bold()
                }
                .padding()
                Slider(value: $sliderValue, in: 5...60, step: 1, onEditingChanged: { data in
                    student.notificationTime = sliderValue
                })
                    .accentColor(Color.green)
                    .padding(.horizontal, 40.0)
            }
            Spacer()
        }
        .navigationTitle("Einstellungen")
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static private var student = Student(bookings: [])
    @State static private var allowNotifications = true
    static var previews: some View {
        SettingsView(student: $student, allowNotifications: $allowNotifications)
    }
}
