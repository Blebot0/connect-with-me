//
//  ContactDetailView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//


import SwiftUI

struct ContactDetailView: View {
    @Binding var contacts: [Contact]
    let index: Int
    @Environment(\.dismiss) var dismiss
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false

    var body: some View {
        if index >= contacts.count {
            Color.clear
                .onAppear { dismiss() }
        } else {
            let contact = contacts[index]

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Name Header
                    Text(contact.name)
                        .font(.system(size: 32, weight: .bold))
                        .padding(.bottom, 8)

                    // Basic Info
                    VStack(alignment: .leading, spacing: 12) {
                        if let phone = contact.phoneNumber, !phone.isEmpty {
                            Label(phone, systemImage: "phone.fill")
                                .font(.body)
                                .foregroundColor(.blue)
                        }

                        Label("Bucket: \(contact.bucket)", systemImage: "folder.fill")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    // Social Links Section
                    if !contact.socialLinks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
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
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }

                    // Hashtags Section
                    if !contact.hashtags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hashtags")
                                .font(.headline)

                            WrapView(items: contact.hashtags) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                            }
                        }
                    }

                    Spacer()

                    // Actions
                    HStack {
                        Button(action: {
                            showingEdit = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(.borderedProminent)

                        Spacer()

                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.top, 24)
                }
                .padding()
            }
            .navigationTitle("Contact Details")
            .navigationBarTitleDisplayMode(.inline)
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
