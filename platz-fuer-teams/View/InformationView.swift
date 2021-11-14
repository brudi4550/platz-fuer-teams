//
//  InformationView.swift
//  Platz für Teams
//
//  Created by Alexander Wolf on 14.11.21.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        List {
            HStack {
                Text("Erstellt von")
                Spacer()
                Text("Gruppe 47")
            }
            HStack {
                Text("Programmiersprache")
                Spacer()
                Image(systemName: "swift")
                Text("Swift")
            }
            HStack {
                Text("UI-Framework")
                Spacer()
                Text("SwiftUI")
            }
            HStack {
                Text("Sourcecode")
                Spacer()
                Link("Github", destination: URL(string: "https://github.com/brudi4550/platz-fuer-teams")!)
            }
            HStack {
                Text("App-Version")
                Spacer()
                Text("1.2.1")
            }
        }
        .navigationTitle("Informationen")
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
