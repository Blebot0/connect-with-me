//
//  ContactListView.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import SwiftUI

struct ContactListView: View {
    @State private var contacts: [Contact] = []
    @State private var showingAddContact = false
    @State private var searchText = ""

    // Filter contacts by search text (name, bucket, hashtags)
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        let lowercasedSearch = searchText.lowercased()
        return contacts.filter { contact in
            contact.name.lowercased().contains(lowercasedSearch) ||
            contact.bucket.lowercased().contains(lowercasedSearch) ||
            contact.hashtags.contains(where: { $0.lowercased().contains(lowercasedSearch) })
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Search bar at the top
                TextField("Search contacts", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if filteredContacts.isEmpty {
                    Spacer()
                    Button(action: {
                        showingAddContact = true
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            Text("Add your first contact")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredContacts) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact)) {
                                VStack(alignment: .leading) {
                                    Text(contact.name)
                                        .font(.headline)
                                    Text(contact.bucket)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            // Support deleting contacts
                            let idsToDelete = indexSet.map { filteredContacts[$0].id }
                            contacts.removeAll { idsToDelete.contains($0.id) }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddContact = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddContact) {
            AddContactView(contacts: $contacts)
        }
        .onAppear {
            contacts = ContactStore.shared.load()
        }
        .onChange(of: contacts) {
            ContactStore.shared.save(contacts)
        }
    }
}
