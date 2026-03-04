//
//  PrepItem.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import Foundation

struct PrepItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isChecked: Bool
    var isDefault: Bool

    init(
        id: UUID = UUID(),
        title: String,
        isChecked: Bool = false,
        isDefault: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isChecked = isChecked
        self.isDefault = isDefault
    }
}

extension PrepItem {
    static let defaultItems: [PrepItem] = [
        PrepItem(title: "Charger", isDefault: true),
        PrepItem(title: "Bottle", isDefault: true),
        PrepItem(title: "ID Card", isDefault: true),
        PrepItem(title: "Laptop", isDefault: true),
        PrepItem(title: "Notebook", isDefault: true),
    ]
}
