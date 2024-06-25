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
        
        let TIME = TimeInterval(DATETIME)
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
            let DATE: Date = DTFM.date(from: DATETIME) ?? Date()
            
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
}
