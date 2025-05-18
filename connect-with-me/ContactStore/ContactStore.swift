//
//  ContactStore.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import Foundation

class ContactStore {
    static let shared = ContactStore()
    private init() {}

    private let fileName = "contacts.json"

    private var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }

    func save(_ contacts: [Contact]) {
        do {
            let data = try JSONEncoder().encode(contacts)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("❌ Failed to save contacts:", error)
        }
    }

    func load() -> [Contact] {
        do {
            let data = try Data(contentsOf: fileURL)
            let contacts = try JSONDecoder().decode([Contact].self, from: data)
            return contacts
        } catch {
            print("⚠️ No saved contacts or failed to load:", error)
            return []
        }
    }
}
