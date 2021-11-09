//
//  RowLearningSpace.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI

struct RowLearningSpace: View {
    var learningSpace: LearningSpace

    var body: some View {
        HStack {
            learningSpace.image
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            VStack (alignment: .leading) {
                Text("\(learningSpace.name)")
                HStack {
                    Text("\(learningSpace.building)")
                        .font(.footnote)
                    Text("ID: \(learningSpace.id)")
                        .font(.footnote)
                }
            }
            Spacer()
        }
    }
}

struct RowLearningSpace_Previews: PreviewProvider {
    static var previews: some View {
        RowLearningSpace(learningSpace: learningSpaces[0])
    }
}
