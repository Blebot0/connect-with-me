//
//  Contact.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import Foundation

struct Contact: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var phoneNumber: String?
    var socialLinks: [String: String] // e.g., ["Instagram": "url"]
    var hashtags: [String]
    var bucket: String
}
