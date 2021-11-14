//
//  ListLearningSpaces.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI

struct ListLearningSpaces: View {
    @Binding var student: Student
    @Binding var allowNotifications: Bool
    @State private var searchText: String = ""
    @State private var minSpaces: Int = 0
    
    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("Minimale Anzahl an Sitzplätzen:")
                    Picker("Anzahl der Sitzplätze", selection: $minSpaces) {
                        ForEach(1 ..< 21) {
                            if $0 == 1 {
                                Text("\($0) Sitzplatz")
                                    .font(.headline)
                            } else {
                                Text("\($0) Sitzplätze")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            List(searchResults) { learningSpace in
                NavigationLink {
                    DetailLearningSpace(learningSpace: learningSpace, student: $student, allowNotifications: $allowNotifications)
                } label: {
                    RowLearningSpace(learningSpace: learningSpace)
                }
            }
            .navigationTitle("Freie Lernplätze")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    var searchResults: [LearningSpace] {
        var currentlyFree = learningSpaces
        currentlyFree = currentlyFree.filter() {
            for booking in student.bookings {
                if $0 == booking.learningSpace && Date.now > booking.from && Date.now < booking.to {
                    return false
                }
            }
            return true;
        }
        if searchText.isEmpty {
            return currentlyFree.filter {
                $0.nrOfSeats >= minSpaces
            }.sorted(by: {$0.building < $1.building})
        } else {
            let nameFiltered = currentlyFree.filter { $0.building.contains(searchText) }
            return nameFiltered.filter {
                $0.nrOfSeats >= minSpaces
            }.sorted(by: {$0.building < $1.building})
        }
    }
}

struct ListLearningSpaces_Previews: PreviewProvider {
    @State private static var student: Student = Student(bookings: [])
    @State private static var allowNotifications = true
    static var previews: some View {
        ListLearningSpaces(student: $student, allowNotifications: $allowNotifications)
    }
}
