//
//  ListBookings.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 10.11.21.
//

import SwiftUI
import UserNotifications

struct ListBookings: View {
    @Binding var student: Student
    
    var body: some View {
        if student.bookings.isEmpty {
            Text("Du hast noch keine Lernplätze gebucht!")
                .bold()
                .navigationTitle("Gebuchte Lernplätze")
        } else {
            VStack {
                Divider()
                Section {
                    Text("Nach links wischen um Buchungen zu stornieren.")
                        .font(.footnote)
                }
                List {
                    ForEach(student.bookings, id: \.self) { booking in
                        NavigationLink {
                            MapView(place: Place(coordinate: booking.learningSpace.locationCoordinate))
                                .navigationTitle("Ort des Lernplatzes")
                        } label: {
                            HStack {
                                booking.learningSpace.image
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                VStack (alignment: .leading) {
                                    Text("\(booking.learningSpace.name)")
                                    HStack {
                                        Text("\(booking.learningSpace.building)")
                                            .font(.footnote)
                                        Text("ID: \(booking.learningSpace.id)")
                                            .font(.footnote)
                                    }
                                    Text("Von:")
                                        .font(.footnote)
                                    Text("\(getDate(booking.from))")
                                    Text("Bis:")
                                        .font(.footnote)
                                    Text("\(getDate(booking.to))")
                                }
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("Gebuchte Lernplätze")
        }
    }
    
    func getDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_AT")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func delete(at offsets: IndexSet) {
        student.bookings.remove(atOffsets: offsets)
    }
}

struct ListBookings_Previews: PreviewProvider {
    @State static private var student: Student = Student(bookings: [Booking(learningSpace: learningSpaces[0], from: Date.now, to: Date.now)])
    static var previews: some View {
        ListBookings(student: $student)
    }
}
