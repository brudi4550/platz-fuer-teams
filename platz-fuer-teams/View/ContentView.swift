//
//  ContentView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 30.10.21.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = "Benutzername"
    @State private var password: String = "Passwort"
    @State private var signedIn: Bool = false
    
    var body: some View {
        if !signedIn {
            VStack {
                Image("JKU_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.9)
                Text("Platz für Teams").font(.headline)
                TextField("namePlaceholder", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20.0)
                SecureField("passwordPlaceholder", text: $password)
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
                ListLearningSpaces()
            }
            .navigationTitle("Willkommen zurück")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
