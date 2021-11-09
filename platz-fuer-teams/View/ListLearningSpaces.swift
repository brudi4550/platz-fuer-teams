//
//  ListLearningSpaces.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI

struct ListLearningSpaces: View {
    var body: some View {
        List(learningSpaces) { learningSpace in
            NavigationLink {
                DetailLearningSpace(learningSpace: learningSpace)
            } label: {
                RowLearningSpace(learningSpace: learningSpace)
            }
        }
        .navigationTitle("Lernplätze")
    }
}

struct ListLearningSpaces_Previews: PreviewProvider {
    static var previews: some View {
        ListLearningSpaces()
    }
}
