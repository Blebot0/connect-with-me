//
//  ContactDetailView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//


import SwiftUI

struct ContactDetailView: View {
    let contact: Contact

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Name
                Text(contact.name)
                    .font(.largeTitle)
                    .bold()

                // Phone Number
                if let phone = contact.phoneNumber, !phone.isEmpty {
                    HStack {
                        Image(systemName: "phone")
                        Text(phone)
                    }
                    .font(.body)
                }

                // Bucket
                HStack {
                    Image(systemName: "folder")
                    Text("Bucket: \(contact.bucket)")
                }
                .font(.body)

                // Social Links
                if !contact.socialLinks.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Social Links")
                            .font(.headline)

                        ForEach(contact.socialLinks.sorted(by: { $0.key < $1.key }), id: \.key) { platform, link in
                            HStack {
                                Text(platform)
                                    .bold()
                                Spacer()
                                Link(destination: URL(string: link) ?? URL(string: "https://example.com")!) {
                                    Text(link)
                                        .foregroundColor(.blue)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                            }
                        }
                    }
                }

                // Hashtags
                if !contact.hashtags.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hashtags")
                            .font(.headline)
                        WrapView(items: contact.hashtags) { tag in
                            Text(tag)
                                .padding(6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Contact Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
