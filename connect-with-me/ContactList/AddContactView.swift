//
//  AddContactView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import SwiftUI

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var contacts: [Contact]

    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var selectedBucket = ""
    @State private var hashtagInput = ""
    @State private var hashtags: [String] = []
    @State private var socialLinks: [String: String] = [:]

    @State private var availableBuckets: [String] = []
    @State private var newBucketName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Bucket")) {
                    Picker("Select Bucket", selection: $selectedBucket) {
                        ForEach(availableBuckets, id: \.self) { bucket in
                            Text(bucket)
                        }
                    }

                    HStack {
                        TextField("Add new bucket", text: $newBucketName)
                            .textFieldStyle(.roundedBorder)
                        Button(action: {
                            let trimmed = newBucketName.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            if !availableBuckets.contains(trimmed) {
                                availableBuckets.append(trimmed)
                                selectedBucket = trimmed
                                newBucketName = ""

                                // Save updated buckets
                                BucketStorage.shared.saveBuckets(availableBuckets)
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 8)
                }

                Section(header: Text("Social Media")) {
                    SocialLinkRow(platform: "Instagram", links: $socialLinks)
                    SocialLinkRow(platform: "LinkedIn", links: $socialLinks)
                }

                Section(header: Text("Hashtags")) {
                    HStack {
                        TextField("Add hashtag (e.g., Manager)", text: $hashtagInput)
                        Button("Add") {
                            let trimmed = hashtagInput.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty {
                                hashtags.append(trimmed.hasPrefix("#") ? trimmed : "#\(trimmed)")
                                hashtagInput = ""
                            }
                        }
                    }

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(hashtags, id: \.self) { tag in
                                Text(tag)
                                    .padding(6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newContact = Contact(
                            name: name,
                            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                            socialLinks: socialLinks,
                            hashtags: hashtags,
                            bucket: selectedBucket
                        )
                        contacts.append(newContact)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || selectedBucket.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                availableBuckets = BucketStorage.shared.loadBuckets()
                if selectedBucket.isEmpty {
                    selectedBucket = availableBuckets.first ?? ""
                }
            }
        }
    }
}

