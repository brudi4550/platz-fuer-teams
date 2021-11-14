//
//  Student.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import Foundation

struct Student {
    var bookings: [Booking]
    var notificationTime: Double = 5.0
    
    mutating func addBooking(booking: Booking) -> () {
        bookings.append(booking)
    }
}
