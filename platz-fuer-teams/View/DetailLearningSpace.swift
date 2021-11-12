//
//  DetailLearningSpace.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI
import UserNotifications

struct DetailLearningSpace: View {
    var learningSpace: LearningSpace
    @Binding var student: Student
    @State private var from: Date = Date.now
    @State private var to: Date = Date.now.addingTimeInterval(3600)
    @State private var showingSuccessfulAlert: Bool = false
    @State private var showingImpossibleTimeAlert: Bool = false
    @State private var showingOverlapAlert: Bool = false
    
    var body: some View {
        ScrollView {
            MapView(place: Place(coordinate: learningSpace.locationCoordinate))
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
                Group {
                    Text("Weitere Informationen")
                        .font(.title2)
                    Text("Anzahl an Sitzplätzen: \(learningSpace.nrOfSeats)")
                    if !learningSpace.occupied {
                        Text("Lernplatz derzeit frei.")
                    } else {
                        Text("Lernplatz derzeit besetzt.")
                    }
                    Divider()
                    HStack (alignment: .center) {
                        Text("Von:")
                        DatePicker("Von wann",selection: $from)
                            .labelsHidden()
                    }
                    HStack (alignment: .center) {
                        Text("Bis:")
                        DatePicker("Bis wann", selection: $to)
                            .labelsHidden()
                    }
                }
                HStack (alignment: .center) {
                    Spacer()
                    Button("Buchen") {
                        var failed = false
                        for otherBooking in student.bookings {
                            if from < otherBooking.to && otherBooking.from < to {
                                showingOverlapAlert = true
                                failed = true
                            }
                        }
                        if from > to {
                            showingImpossibleTimeAlert = true
                            failed = true
                        }
                        if !failed {
                            let booking = Booking(learningSpace: learningSpace, from: from, to: to)
                            student.addBooking(booking: booking)
                            showingSuccessfulAlert = true
                            let content = UNMutableNotificationContent()
                            content.title = "Platz für Teams"
                            content.subtitle = "Reservierungserinnerung"
                            content.body = "Deine Buchung des Lernplatzes \(learningSpace.name) im Gebäude \(learningSpace.building) startet in 5 Minuten."
                            content.sound = UNNotificationSound.default
                            let notificationMoment = from - 5 * 60
                            let calenderDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: notificationMoment)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: calenderDate, repeats: false)

                            let request = UNNotificationRequest(identifier: learningSpace.UUID, content: content, trigger: trigger)

                            UNUserNotificationCenter.current().add(request)
                        }
                    }.alert("Lernplatz erfolgreich gebucht!", isPresented: $showingSuccessfulAlert) {
                        Button("OK", role: .cancel) {}
                    }.alert("Buchung überschneidet sich mit einer anderen Buchung.", isPresented: $showingOverlapAlert) {
                        Button("OK", role: .cancel) {}
                    }.alert("Startzeitpunkt muss vor Endzeitpunkt liegen.", isPresented: $showingImpossibleTimeAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
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
