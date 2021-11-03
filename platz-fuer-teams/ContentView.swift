//
//  ContentView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 30.10.21.
//

import SwiftUI

struct ContentView: View {
    @State var a: String = "Test"
    
    var body: some View {
        NavigationView {
            VStack {
                Image("JKU_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.9)
                Text("Platz für Teams")
                TextField("Hello", text: $a)
                NavigationLink(destination: MainScreen()) {
                    Button("Log in") {}
                    .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
