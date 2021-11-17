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
    @State var sliderValue = 0.0
    @State var showErrorText: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Image(systemName: "envelope.circle")
                    Toggle("Push-Benachrichtigungen erlauben", isOn: $allowNotifications)
                        .onChange(of: allowNotifications) { _ in
                            if !allowNotifications {
                                showErrorText = false
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            } else {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        showErrorText = false
                                        updateBookingNotifications(student: student)
                                    } else {
                                        allowNotifications = false
                                        showAlert = true
                                    }
                                }
                            }
                        }
                        .alert("Deine allgemeinen App-Präferenzen verhindern, dass dir Mitteilungen zugesendet werden können. Du kannst dies in den Einstellungen ändern.", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                }
                .padding()
                Divider()
                VStack {
                    Text("Wieviele Minuten vor deiner Buchung möchtest du an diese erinnert werden?")
                        .padding()
                    Text("\(sliderValue, specifier: "%.f") Minuten")
                        .bold()
                }
                .padding()
                Slider(value: $sliderValue, in: 5...60, step: 1, onEditingChanged: { data in
                    student.notificationTime = sliderValue
                    updateBookingNotifications(student: student)
                })
                    .accentColor(Color.green)
                    .padding(.horizontal, 40.0)
                    .onAppear() {
                        sliderValue = student.notificationTime
                    }
            }
            Spacer()
        }
        .navigationTitle("Einstellungen")
    }
    
    func updateBookingNotifications(student: Student) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static private var student = Student(bookings: [])
    @State static private var allowNotifications = true
    static var previews: some View {
        SettingsView(student: $student, allowNotifications: $allowNotifications)
    }
}
