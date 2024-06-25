//
//  S_MIMETYPE.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/24.
//

import UIKit

internal let DEFAULT_MIME_TYPE = "application/octet-stream"

internal let mimeTypes = [
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "epub": "application/epub+zip",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

internal func MimeType(ext: String?) -> String {
    return mimeTypes[ext?.lowercased() ?? "" ] ?? DEFAULT_MIME_TYPE
}

extension NSURL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension URL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension NSString {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}

extension String {
    public func mimeType() -> String {
        return (self as NSString).mimeType()
    }
}

extension UIViewController {
    
    func detectImageType(from data: Data) -> String {
        var byte: UInt8 = 0
        data.copyBytes(to: &byte, count: 1)
        
        switch byte {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        case 0x49:
            // 첫 4바이트를 검사하여 TIFF의 경우 II나 MM으로 시작함
            if data.count >= 4 {
                let secondByte = data[1]
                let thirdByte = data[2]
                let fourthByte = data[3]
                if secondByte == 0x49 && thirdByte == 0x49 && fourthByte == 0x2A {
                    return "tiff"
                } else if secondByte == 0x4D && thirdByte == 0x4D && fourthByte == 0x2A {
                    return "tiff"
                }
            }
            return "unknown"
        case 0x52:
            // 첫 3바이트를 검사하여 WEBP의 경우 WEBP로 시작함
            if data.count >= 3 {
                let secondByte = data[1]
                let thirdByte = data[2]
                if secondByte == 0x49 && thirdByte == 0x46 {
                    return "webp"
                } else if secondByte == 0x58 && thirdByte == 0x50 {
                    return "xmp"
                }
            }
            return "unknown"
        case 0x00:
            // 첫 4바이트를 검사하여 ICO의 경우 "00 00 01 00"으로 시작함
            if data.count >= 4 {
                let secondByte = data[1]
                let thirdByte = data[2]
                let fourthByte = data[3]
                if secondByte == 0x00 && thirdByte == 0x00 && fourthByte == 0x01 {
                    return "ico"
                }
            }
            return "unknown"
        case 0x25:
            // 첫 4바이트를 검사하여 PDF의 경우 "%PDF"로 시작함
            if data.count >= 4 {
                let secondByte = data[1]
                let thirdByte = data[2]
                let fourthByte = data[3]
                if secondByte == 0x50 && thirdByte == 0x44 && fourthByte == 0x46 {
                    return "pdf"
                }
            }
            return "unknown"
        case 0x46:
            // 첫 4바이트를 검사하여 HEIC의 경우 "ftypheic"로 시작함
            if data.count >= 12 {
                let fileTypeBytes = data.subdata(in: 4..<12)
                if fileTypeBytes == Data("ftypheic".utf8) {
                    return "heic"
                } else if fileTypeBytes == Data("ftypheix".utf8) {
                    return "heix"
                } else if fileTypeBytes == Data("ftyphevc".utf8) {
                    return "hevc"
                } else if fileTypeBytes == Data("ftyphevx".utf8) {
                    return "hevx"
                }
            }
            return "unknown"
        default:
            return "unknown"
        }
    }
}
