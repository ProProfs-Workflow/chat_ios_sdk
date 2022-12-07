//
//  Extensions.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 19/09/22.
//

import SwiftUI

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}



extension Color {

        init(hexString: String) {

           let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int = UInt32()
           Scanner(string: hex).scanHexInt32(&int)
           let a, r, g, b: UInt32
           switch hex.count {
           case 3: // RGB (12-bit)
               (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
           case 8: // ARGB (32-bit)
               (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
           default:
               (a, r, g, b) = (0, 0, 0, 0)
           }
           self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255)
       }

       var toHex: String? {
           return toHex()
       }

       // MARK: - From UIColor to String
       func toHex(alpha: Bool = false) -> String? {
           guard let components = cgColor?.components, components.count >= 3 else {
               return nil
           }

           let r = Float(components[0])
           let g = Float(components[1])
           let b = Float(components[2])
           var a = Float(1.0)

           if components.count >= 4 {
               a = Float(components[3])
           }

           if alpha {
               return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
           } else {
               return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
           }
       }
}



extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}




struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

