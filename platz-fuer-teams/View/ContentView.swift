//
//  ContentView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 30.10.21.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var signedIn: Bool = false
    @State private var student: Student = Student(bookings: [])
    @State private var wrongCredentials: Bool = false
    let startColor = Color.init(hue: 100, saturation: 0.73, brightness: 0.93)
    let endColor = Color.init(hue: 218, saturation: 0.84, brightness: 0.7)
    
    var body: some View {
        if !signedIn {
            ZStack {
                LinearGradient(colors: [Color.init(red: 0, green: 0.4, blue: 0.93), Color.init(red: 0, green: 0.6, blue: 1)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                VStack {
                    Text("Platz für Teams").font(.largeTitle)
                    Text("$Logo").font(.largeTitle)
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
                    .background(Color.black)
                    .cornerRadius(8)
                    Image("JKU_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.9)
                        .padding(.top, 50)
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
