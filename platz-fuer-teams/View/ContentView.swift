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
    
    var body: some View {
        if !signedIn {
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
                    self.signedIn.toggle()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding(.bottom, 100.0)
        } else {
            NavigationView {
                VStack {
                    List {
                        NavigationLink {
                            ListLearningSpaces(student: $student)
                        } label: {
                            Text("Lernplatz buchen")
                        }
                        NavigationLink {
                            Text("test2")
                        } label: {
                            Text("Gebuchte Lernplätze anzeigen")
                        }
                        NavigationLink {
                            Text("test3")
                        } label: {
                            Text("Buchungen löschen")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
