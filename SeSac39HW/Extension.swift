//
//  Extension.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/25/25.
//

import UIKit


extension String {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(identifier: "KST")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    func toDate() -> Date? {
        let dateFormatter = Self.dateFormatter
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        return date
    }
}
