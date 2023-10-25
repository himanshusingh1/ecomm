//
//  Theme.swift
//  MobileAppSourceCodeV1
//
//  Created by Himanshu Singh on 22/10/23.
//

import Foundation
import UIKit
struct Config: Codable {
    let appicon: String
    let appName: String
    let bundleID: String
    let storeURL: String
    let primaryColor: String
    let splashScreen: String
    let themeID: String
    let tabBar: TabBar

    enum CodingKeys: String, CodingKey {
        case themeID = "theme_id"
        case appicon = "app_icon"
        case storeURL = "store_url"
        case bundleID = "app_budle_id"
        case appName = "app_name"
        case primaryColor = "primary_color"
        case splashScreen = "splash_screen"
        case tabBar = "tab_bar"
    }
}
struct TabBar: Codable {
    let home, all, cart, account: TabbarItem
}
struct TabbarItem: Codable {
    let selectedImage, unselectedImage: String

    enum CodingKeys: String, CodingKey {
        case selectedImage = "selected_image"
        case unselectedImage = "unselected_image"
    }
}

func readConfig() -> Config {
    let json = Bundle.main.url(forResource: "config", withExtension: "json")!
    let data = try! Data.init(contentsOf: json)
    let item = try! JSONDecoder().decode(Config.self, from: data)
    return item
}
extension UIColor {
    func toHSL() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var l: CGFloat = 0
            var a: CGFloat = 0

            getHue(&h, saturation: &s, brightness: &l, alpha: &a)

            return (h, s, l, a)
        }
    
    static let primaryColor: UIColor = {
        let item = readConfig()
        let color = UIColor.init(hex: item.primaryColor)
        return color
    }()
}
extension UIColor {
    var hue: CGFloat {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return hue
    }
}
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }

        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
extension UIColor {
    static var secondaryColor: CGFloat = {
        return 11
    }()
    convenience init(hue: Int, saturation: Int, lightness: Int, alpha: Int = 100) {
        self.init(hue: CGFloat(hue), saturation: CGFloat(saturation), lightness: CGFloat(lightness), alpha: CGFloat(alpha) / 100.0)
    }
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) {
        let adjustedHue = hue / 360.0
        let adjustedSaturation = saturation / 100.0
        let adjustedLightness = lightness / 100.0
        
        let c = (1 - abs(2 * adjustedLightness - 1)) * adjustedSaturation
        let x = c * (1 - abs((adjustedHue * 6).truncatingRemainder(dividingBy: 2) - 1))
        let m = adjustedLightness - c / 2
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        switch adjustedHue {
        case 0..<1/6:
            red = c
            green = x
        case 1/6..<1/3:
            red = x
            green = c
        case 1/3..<1/2:
            green = c
            blue = x
        case 1/2..<2/3:
            green = x
            blue = c
        case 2/3..<5/6:
            red = x
            blue = c
        default:
            red = c
            blue = x
        }
        
        red += m
        green += m
        blue += m
        self.init(red: red, green: green, blue: blue,alpha: alpha)
    }
}

extension UIColor {
    static let P1: UIColor = {
        return primaryColor
    }()
    static let S1 = UIColor.init(hue: 11, saturation: 98, lightness: 55, alpha: 100)
    
    static let T1 = UIColor.init(hex: "#222222")
    static let T2 = UIColor.init(hex: "#4E4E4E")
    static let T3 = UIColor.init(hex: "#222222")
    static let T4 = UIColor.init(hex: "#8C8C8C")
    static let T5 = UIColor.init(hex: "#858585")
    static let T6 = UIColor.init(hex: "#4E4E4E")
    
    static let O1 = UIColor.init(hex: "#0F7FD0")
    static var O2 = O1.withAlphaComponent(0.2)
    static let O3 = O1.withAlphaComponent(0.1)
    
    static let R1 = UIColor.init(hex: "#459C37")
    
    static let B1 = UIColor.init(hex: "#EFEFEF")
    static let B2 = UIColor.init(hex: "#D1D1D1")
    static let B3 = UIColor.init(hex: "#F7F9F7")
    static let B4 = UIColor.init(hex: "#FAFAFA")
    
    static let AppLightGray = UIColor(hex: "#E8E8E8")
}
extension UIColor {
    
        func toHSLA() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            
            if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                let lightness = (brightness + 1.0 - saturation) / 2.0
                return (hue, saturation, lightness, alpha)
            }
            
            return nil
        }
    

}
