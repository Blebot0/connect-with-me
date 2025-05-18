//
//  ContactDetailView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//


import SwiftUI

import SwiftUI

struct ContactDetailView: View {
    @Binding var contacts: [Contact]
    let index: Int
    @Environment(\.dismiss) var dismiss
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false

    var body: some View {
        // If contact at index no longer exists (e.g. was deleted), dismiss the view
        if index >= contacts.count {
            Color.clear
                .onAppear {
                    dismiss()
                }
        } else {
            let contact = contacts[index]

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(contact.name)
                        .font(.largeTitle)
                        .bold()

                    if let phone = contact.phoneNumber, !phone.isEmpty {
                        HStack {
                            Image(systemName: "phone")
                            Text(phone)
                        }
                        .font(.body)
                    }

                    HStack {
                        Image(systemName: "folder")
                        Text("Bucket: \(contact.bucket)")
                    }
                    .font(.body)

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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEdit = true
                    }

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .sheet(isPresented: $showingEdit) {
                EditContactView(contact: $contacts[index])
            }
            .alert("Delete Contact?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    contacts.remove(at: index)
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}
