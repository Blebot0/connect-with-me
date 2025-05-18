//
//  SocialLinkRow.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import SwiftUI

struct SocialLinkRow: View {
    let platform: String
    @Binding var links: [String: String]

    var body: some View {
        TextField(platform, text: Binding(
            get: { links[platform, default: ""] },
            set: { links[platform] = $0 }
        ))
            .keyboardType(.URL)
            .autocapitalization(.none)
    }
}
