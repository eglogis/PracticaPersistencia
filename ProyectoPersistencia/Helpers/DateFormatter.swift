//
//  DateFormatter.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 8/2/21.
//

import Foundation

enum HelperDateFormatter {
    static var format: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    static func textFrom(date: Date) -> String {
        return format.string(from: date)
    }
}
