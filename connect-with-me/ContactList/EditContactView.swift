//
//  EditContactView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import Foundation
import SwiftUI

struct EditContactView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var contact: Contact

    @State private var name: String
    @State private var phoneNumber: String
    @State private var bucket: String
    @State private var hashtags: [String]
    @State private var socialLinks: [String: String]
    @State private var newTag: String = ""

    init(contact: Binding<Contact>) {
        _contact = contact
        _name = State(initialValue: contact.wrappedValue.name)
        _phoneNumber = State(initialValue: contact.wrappedValue.phoneNumber ?? "")
        _bucket = State(initialValue: contact.wrappedValue.bucket)
        _hashtags = State(initialValue: contact.wrappedValue.hashtags)
        _socialLinks = State(initialValue: contact.wrappedValue.socialLinks)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                }

                Section(header: Text("Bucket")) {
                    TextField("Bucket", text: $bucket)
                }

                Section(header: Text("Social Media")) {
                    SocialLinkRow(platform: "Instagram", links: $socialLinks)
                    SocialLinkRow(platform: "LinkedIn", links: $socialLinks)
                }

                Section(header: Text("Hashtags")) {
                    ForEach(hashtags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                Spacer()
                                Button(action: {
                                    hashtags.removeAll { $0 == tag }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        HStack {
                            TextField("Add hashtag", text: $newTag)
                            Button(action: {
                                let trimmed = newTag.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty && !hashtags.contains(trimmed) {
                                    hashtags.append(trimmed)
                                    newTag = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                }
            }
            .navigationTitle("Edit Contact")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        contact.name = name
                        contact.phoneNumber = phoneNumber.isEmpty ? nil : phoneNumber
                        contact.bucket = bucket
                        contact.hashtags = hashtags
                        contact.socialLinks = socialLinks
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
