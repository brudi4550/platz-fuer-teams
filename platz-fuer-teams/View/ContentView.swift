//
//  ContentView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 30.10.21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    @State private var signedIn: Bool = false
    @State private var student: Student = Student(bookings: [])
    @State private var wrongCredentials: Bool = false
    @State private var allowNotifications: Bool = false
    
    var body: some View {
        if !signedIn {
            ZStack {
                LinearGradient(colors: [Color.init(red: 0, green: 0.4, blue: 0.93), Color.init(red: 0, green: 0.6, blue: 1)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                VStack {
                    Text("Platz für Teams")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.black)
                    VStack {
                        TextField("Benutzername", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 20.0)
                            .focused($focusedField, equals: .name)
                        SecureField("Passwort", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 20.0)
                            .focused($focusedField, equals: .password)
                    }.toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button(action: focusPreviousField) {
                                Image(systemName: "chevron.up")
                            }
                        }
                        ToolbarItem(placement: .keyboard) {
                            Button(action: focusNextField) {
                                Image(systemName: "chevron.down")
                            }
                        }
                    }
                    Button("LOGIN") {
                        if matches(string: name, regex: "[Kk][0-9]{8}|[Aa][Kk][0-9]{8}") && !password.isEmpty {
                            self.signedIn.toggle()
                        } else {
                            wrongCredentials = true
                        }
                    }.alert("Falscher Benutzername oder Passwort.", isPresented: $wrongCredentials) {
                        Button("OK", role: .cancel) {
                            wrongCredentials = false
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.init(red: 0, green: 0.3, blue: 0.8))
                    .cornerRadius(10)
                    Image("JKU_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.75)
                        .frame(width: 350, height: 175)
                }
                .padding()
            }
        } else {
            NavigationView {
                VStack {
                    List {
                        Section("Allgemein") {
                            NavigationLink {
                                ListLearningSpaces(student: $student)
                            } label: {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                    Text("Lernplatz buchen")
                                }
                            }
                            NavigationLink {
                                ListBookings(student: $student)
                            } label: {
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                    Text("Gebuchte Lernplätze anzeigen")
                                }
                            }
                        }
                        Section ("Sonstiges") {
                            NavigationLink {
                                Text("test")
                            } label: {
                                Text("Hilfe")
                            }
                            NavigationLink {
                                Text("test")
                            } label: {
                                Text("Informationen")
                            }
                        }
                        Group {
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
                                                    content.body = "Deine Buchung des Lernplatzes \(booking.learningSpace.name) im Gebäude \(booking.learningSpace.building) startet in 5 Minuten."
                                                    content.sound = UNNotificationSound.default
                                                    let notificationMoment = booking.from - 5 * 60
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
                    }
                    HStack() {
                        Text("Willkommen zurück, \(name)!")
                            .font(.body)
                    }
                    Divider()
                    Text("Version 1.2.1")
                        .font(.footnote)
                }.navigationTitle("Startseite")
            }
        }
    }
    
    func matches(string: String, regex: String) -> Bool {
            return string.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
        
extension ContentView {
    private enum Field: Int, CaseIterable {
        case name, password
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .name
            }
        }

    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .password
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
