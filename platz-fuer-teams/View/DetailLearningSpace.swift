//
//  DetailLearningSpace.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI

struct DetailLearningSpace: View {
    var learningSpace: LearningSpace
    @Binding var student: Student
    @State private var from: Date = Date.now
    @State private var to: Date = Date.now.addingTimeInterval(3600)
    
    var body: some View {
        ScrollView {
            MapView(coordinate: learningSpace.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            CircleImage(image: learningSpace.image)
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                Text(learningSpace.name)
                    .font(.title)

                HStack {
                    Text(learningSpace.building)
                    Spacer()
                    Text("JKU")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("Weitere Informationen")
                    .font(.title2)
                Text("Anzahl an Sitzplätzen: \(learningSpace.nrOfSeats)")
                if !learningSpace.occupied {
                    Text("Lernplatz derzeit frei.")
                } else {
                    Text("Lernplatz derzeit besetzt.")
                }
                DatePicker("Von wann",selection: $from)
                    .labelsHidden()
                DatePicker("Bis wann", selection: $to)
                    .labelsHidden()
                HStack (alignment: .center){
                    Spacer()
                    Button("Buchen") {
                        
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    Spacer()
                }
            }
            .padding()
            .navigationTitle(learningSpace.name)
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
    }
}

struct DetailLearningSpace_Previews: PreviewProvider {
    @State static private var student = Student(bookings: [])
    static var previews: some View {
        DetailLearningSpace(learningSpace: learningSpaces[0], student: $student)
    }
}
