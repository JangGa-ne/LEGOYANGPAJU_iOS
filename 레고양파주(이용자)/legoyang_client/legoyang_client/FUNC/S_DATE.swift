//
//  S_DATE.swift
//  Apartment
//
//  Created by 장 제현 on 2021/03/28.
//

import UIKit

// MARK: 날짜 포멧 설정
extension UIViewController {
    
    func setKoreaTimestamp() -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let koreaDate = dateFormatter.string(from: Date())
        let koreaDateTime = dateFormatter.date(from: koreaDate) ?? Date()
        let timestamp = Int(koreaDateTime.timeIntervalSince1970)
        
        return timestamp*1000
    }
    
    func FM_UTC(_ DATETIME: Date) -> Date {
        
        let DTFM = DateFormatter()
        DTFM.timeZone = TimeZone(abbreviation: "UTC")
        DTFM.dateFormat = "yyyy-MM-dd 00:00:00"
        
        return DTFM.date(from: DTFM.string(from: DATETIME)) ?? Date()
    }
    
    func FM_TIMESTAMP(_ DATETIME: Int, _ DATEFORMAT: String) -> String {
        
        var TIME = TimeInterval()
        if "\(DATETIME)".count == 13 { TIME = TimeInterval(DATETIME/1000) } else { TIME = TimeInterval(DATETIME) }
        
        let DTFM = DateFormatter()
        DTFM.locale = Locale(identifier: "ko_kr")
        DTFM.dateFormat = "yyyy-MM-dd HH:mm:ss"
        DTFM.timeZone = TimeZone(identifier: "Asia/Seoul")
        let DATE: Date = Date(timeIntervalSince1970: TIME)

        DTFM.dateFormat = DATEFORMAT
        return DTFM.string(from: DATE)
    }
    
    func FM_CUSTOM(_ DATETIME: String, _ DATEFORMAT: String) -> String {
        
        let DTFM = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return ""
        } else {
            
            DTFM.locale = Locale(identifier: "ko_kr")
            DTFM.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DTFM.timeZone = TimeZone(identifier: "Asia/Seoul")
            let DATE: Date = DTFM.date(from: DATETIME.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "+09:00", with: "")) ?? Date()
            
            DTFM.dateFormat = DATEFORMAT
            return DTFM.string(from: DATE)
        }
    }
    
    // 날짜
    func FM_DATE(_ DATETIME: String) -> String {
        
        let DTFM = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return "-"
        } else {
            
            DTFM.locale = Locale(identifier: "ko_kr")
            DTFM.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DTFM.timeZone = TimeZone(identifier: "Asia/Seoul")
            let DATE: Date = DTFM.date(from: DATETIME) ?? Date()
            
            DTFM.dateFormat = "MM월dd일"
            return DTFM.string(from: DATE)
        }
    }
    
    // 요일
    func FM_DAY(_ DATETIME: String) -> String {
        
        let DTFM = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return "-"
        } else {
            
            DTFM.locale = Locale(identifier: "ko_kr")
            DTFM.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DTFM.timeZone = TimeZone.init(identifier: "Asia/Seoul")
            let DATE: Date = DTFM.date(from: DATETIME)!
            
            DTFM.dateFormat = "E"
            return DTFM.string(from: DATE)
        }
    }
    
    func FM_COLOR(_ DATETIME: String) -> UIColor {
        
        let DTFM = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return .darkGray
        } else {
            
            DTFM.locale = Locale(identifier: "ko_kr")
            DTFM.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DTFM.timeZone = TimeZone(identifier: "Asia/Seoul")
            let DATE: Date = DTFM.date(from: DATETIME)!
            
            DTFM.dateFormat = "E요일"
            if DTFM.string(from: DATE) == "토요일" {
                return .systemBlue
            } else if DTFM.string(from: DATE) == "일요일" {
                return .systemRed
            } else {
                return .darkGray
            }
        }
    }
    
    func FM_TIMER(TIMESTAMP: Int) -> String {
        
        var DATE: String = ""
        
        let DAY = TIMESTAMP / 86400
        let HOUR = TIMESTAMP % 86400 / 3600
        let MINUTE = TIMESTAMP % 86400 % 3600 / 60
        let SECOND = TIMESTAMP % 86400 % 3600 % 60
        
        if DAY >= 10 { DATE = "\(DAY)일" } else if DAY != 0 { DATE = "0\(DAY)일" }
        if HOUR >= 10 { DATE = "\(DATE) \(HOUR)" } else { DATE = "\(DATE) 0\(HOUR)" }
        if MINUTE >= 10 { DATE = "\(DATE):\(MINUTE)" } else { DATE = "\(DATE):0\(MINUTE)" }
        if SECOND >= 10 { DATE = "\(DATE):\(SECOND)" } else { DATE = "\(DATE):0\(SECOND)" }
        
        if (DAY <= 0) && (HOUR <= 0) && (MINUTE <= 0) && (SECOND <= 0) { return "마감" } else { return "\(DATE) 남음" }
    }
    
    func setTimer(timestamp: Int) -> String {
        
        var date: String = ""
        
        let day = timestamp/86400
        let hour = timestamp%86400/3600
        let minute = timestamp%86400%3600/60
        let second = timestamp%86400%3600%60
        
        if day >= 10 { date = "\(day)일" } else if day != 0 { date = "0\(day)일" }
        if hour >= 10 { date = "\(date) \(hour)" } else { date = "\(date) 0\(hour)" }
        if minute >= 10 { date = "\(date):\(minute)" } else { date = "\(date):0\(minute)" }
        if second >= 10 { date = "\(date):\(second)" } else { date = "\(date):0\(second)" }
        
        if (day <= 0) && (hour <= 0) && (minute <= 0) && (second <= 0) { return "마감" } else { return date }
    }
}
