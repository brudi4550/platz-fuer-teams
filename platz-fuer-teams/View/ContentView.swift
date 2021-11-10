//
//  ContentView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 30.10.21.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var signedIn: Bool = false
    @State private var student: Student = Student(bookings: [])
    @State private var wrongCredentials: Bool = false
    let startColor = Color.init(hue: 1.4, saturation: 0.8, brightness: 1.0)
    let endColor = Color.init(hue: 49, saturation: 0.8, brightness: 1.0)
    
    var body: some View {
        if !signedIn {
            ZStack {
                LinearGradient(colors: [startColor, endColor], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack {
                    Image("JKU_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.9)
                    Text("Platz für Teams").font(.headline)
                    TextField("Benutzername", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20.0)
                    SecureField("Passwort", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20.0)
                    Button("LOGIN") {
                        if matches(string: name, regex: "[Kk][0-9]{8}|[Aa][Kk][0-9]{8}") {
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
                    .background(Color.accentColor)
                    .cornerRadius(8)
                }
                .padding(.bottom, 100.0)
            }
        } else {
            NavigationView {
                VStack {
                    List {
                        Section("Allgemein") {
                            NavigationLink {
                                ListLearningSpaces(student: $student)
                            } label: {
                                Text("Lernplatz buchen")
                            }
                            NavigationLink {
                                ListBookings(student: $student)
                            } label: {
                                Text("Gebuchte Lernplätze anzeigen")
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
                    }
                    HStack() {
                        Text("Willkommen zurück, \(name)!")
                            .font(.body)
                    }
                    Divider()
                    Text("Version 1.0.4")
                        .font(.footnote)
                }.navigationTitle("Startseite")
            }
        }
    }
    
    func matches(string: String, regex: String) -> Bool {
            return string.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
