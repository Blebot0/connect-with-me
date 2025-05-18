//
//  BucketStorage.swift
//  connect-with-me
//
//  Created by Keshav Kapur on 18/05/25.
//

import Foundation

class BucketStorage {
    static let shared = BucketStorage()
    private let key = "SavedBuckets"

    func loadBuckets() -> [String] {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            return saved
        }
        // Default buckets if none saved yet
        return ["Work", "Ex-Work", "School", "Friends", "Other"]
    }

    func saveBuckets(_ buckets: [String]) {
        UserDefaults.standard.set(buckets, forKey: key)
    }
}
