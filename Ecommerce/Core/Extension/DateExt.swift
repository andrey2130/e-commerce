//
//  DateExt.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//
import Foundation

extension Date {

    private static let orderFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    var orderFormatted: String {
        Self.orderFormatter.string(from: self)
    }

    var smartOrderFormatted: String {
        let cal = Calendar.current

        if cal.isDateInToday(self) { return "Today" }
        if cal.isDateInYesterday(self) { return "Yesterday" }

        return Self.orderFormatter.string(from: self)
    }
}

extension String {
    var isoDate: Date? {
        ISO8601DateFormatter.backend.date(from: self)
    }
}

extension ISO8601DateFormatter {

    static let backend: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return f
    }()
}

extension OrderData {

    var createdAtDate: Date? {
        createdAt?.isoDate
    }

    var createdAtFormatted: String {
        createdAtDate?.smartOrderFormatted ?? ""
    }
}
