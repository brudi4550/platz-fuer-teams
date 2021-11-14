//
//  HelpView.swift
//  Platz für Teams
//
//  Created by Alexander Wolf on 14.11.21.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack (alignment: .leading){
            Text("Beim aktivieren der Push-Benachrichtigungen wird nur beim ersten Mal ein Popup erscheinen.")
            Divider()
            Text("Diese App verwendet deinen Standort um dir zu helfen schneller deinen Lernplatz zu finden.")
            Spacer()
        }
        .navigationTitle("Hilfe")
        .padding()
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
