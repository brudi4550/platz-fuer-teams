//
//  ListLearningSpaces.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI

struct ListLearningSpaces: View {
    @Binding var student: Student
    
    var body: some View {
        List(learningSpaces) { learningSpace in
            NavigationLink {
                DetailLearningSpace(learningSpace: learningSpace, student: $student)
            } label: {
                RowLearningSpace(learningSpace: learningSpace)
            }
        }
        .navigationTitle("Freie Lernplätze")
    }
}

struct ListLearningSpaces_Previews: PreviewProvider {
    @State private static var student: Student = Student(bookings: [])
    static var previews: some View {
        ListLearningSpaces(student: $student)
    }
}
