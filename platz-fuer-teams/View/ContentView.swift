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
    @State private var allowNotifications = false
    @State private var wrongCredentials: Bool = false
    
    var body: some View {
        if !signedIn {
            ZStack {
                LinearGradient(colors: [Color.init(red: 0.2, green: 0.3, blue: 0.8), Color.init(red: 0, green: 0.65, blue: 1)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
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
                    Button {
                        if matches(string: name, regex: "[Aa][Kk][0-9]{8}$|[Kk][0-9]{8}$") && !password.isEmpty {
                            self.signedIn.toggle()
                        } else {
                            wrongCredentials = true
                        }
                    } label: {
                        HStack {
                            Text("LOGIN")
                            Image(systemName: "chevron.forward.circle.fill")
                        }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    }.alert("Falscher Benutzername oder Passwort.", isPresented: $wrongCredentials) {
                        Button("OK", role: .cancel) {
                            wrongCredentials = false
                        }
                    }
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
                                ListLearningSpaces(student: $student, allowNotifications: $allowNotifications)
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
                                SettingsView(student: $student, allowNotifications: $allowNotifications)
                            } label: {
                                HStack {
                                    Image(systemName: "gearshape")
                                    Text("Einstellungen")
                                }
                            }
                            NavigationLink {
                                HelpView()
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("Hilfe")
                                }
                            }
                            NavigationLink {
                                InformationView()
                            } label: {
                                HStack {
                                    Image(systemName: "info.circle")
                                    Text("Informationen")
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
        return string.range(of: regex, options: .regularExpression) != nil
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
