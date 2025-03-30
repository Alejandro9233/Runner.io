import SwiftUI
import Foundation

extension Color {
    init?(hex: String) {
        let r, g, b: Double
        
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        
        // Use the correct method to scan the hex value
        scanner.scanHexInt64(&rgb)
        
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            r = Double((rgb >> 8) & 0xF) / 15.0
            g = Double((rgb >> 4) & 0xF) / 15.0
            b = Double(rgb & 0xF) / 15.0
        case 6: // RGB (24-bit)
            r = Double((rgb >> 16) & 0xFF) / 255.0
            g = Double((rgb >> 8) & 0xFF) / 255.0
            b = Double(rgb & 0xFF) / 255.0
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b)
    }
}
