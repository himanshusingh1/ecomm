//
//  main.swift
//  project_gen
//
//  Created by Himanshu Singh on 22/10/23.
//

import Foundation

struct Config: Codable {
    let appicon: String
    let googlePlist: String
    let appName: String
    let bundleID: String
    let storeURL: String
    let primaryColor: String
    let navbarColor: String
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
        case googlePlist = "google_plist"
        case navbarColor = "navigation_bar_color"
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

FileManager.default.changeCurrentDirectoryPath("/Users/himanshusingh/Documents/ShopifyStore")
let originalpath = FileManager.default.currentDirectoryPath
//MARK: - get config json
let data = try Data(contentsOf: URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/config.json"))
let config = try JSONDecoder().decode(Config.self, from: data)

//MARK: - Set merchant data path
let merchantDataLocation = originalpath + "/merchant_data"
try? FileManager.default.removeItem(atPath: merchantDataLocation)
try FileManager.default.createDirectory(atPath: merchantDataLocation, withIntermediateDirectories: true)

//MARK: - Download tab and splash images
func downloadImageAndSaveAs(name: String,from: String, path: String) {
    guard let url = URL(string: from) else { return }
    let data = try! Data(contentsOf: url)
    try? FileManager.default.createDirectory(atPath: merchantDataLocation + path, withIntermediateDirectories: true)
    let location = merchantDataLocation + path + "/" + name + ".png"
    print(FileManager.default.createFile(atPath: location, contents: data))
}

let tabbarimagespath = "/tab_images"
downloadImageAndSaveAs(name: "home_selected", from: config.tabBar.home.selectedImage, path: tabbarimagespath)
downloadImageAndSaveAs(name: "home_un_selected", from: config.tabBar.home.unselectedImage, path: tabbarimagespath)

downloadImageAndSaveAs(name: "all_selected", from: config.tabBar.all.selectedImage, path: tabbarimagespath)
downloadImageAndSaveAs(name: "all_un_selected", from: config.tabBar.all.unselectedImage, path: tabbarimagespath)

downloadImageAndSaveAs(name: "cart_selected", from: config.tabBar.cart.selectedImage, path: tabbarimagespath)
downloadImageAndSaveAs(name: "cart_un_selected", from: config.tabBar.cart.unselectedImage, path: tabbarimagespath)

downloadImageAndSaveAs(name: "account_selected", from: config.tabBar.account.selectedImage, path: tabbarimagespath)
downloadImageAndSaveAs(name: "account_un_selected", from: config.tabBar.account.unselectedImage, path: tabbarimagespath)

let splashpath = "/splash"
downloadImageAndSaveAs(name: "splash_image", from: config.splashScreen, path: splashpath)

FileManager.default.createFile(atPath: merchantDataLocation + "/config.json", contents: data)

//MARK: - Set InfoPlist Data
class InfoPlistConfiguration {
    enum UpdateInfoPlistKeyTypes: String, CaseIterable {
        case launchScreen = "UILaunchStoryboardName"
        case appName = "CFBundleDisplayName"
        case bundleIdenitfier = "CFBundleIdentifier"
        case webViewURL = "BaseWebviewURL"
    }
    func updateInfoPlist(for path: String, with merchant: Config) {
        guard let infoDictionary = NSMutableDictionary(contentsOfFile: path) else {
            print("Error reading Info.plist file.")
            exit(1)
        }
        UpdateInfoPlistKeyTypes.allCases.forEach { plistType in
            switch plistType {
            case .appName:
                infoDictionary[plistType.rawValue] = merchant.appName
            case .bundleIdenitfier:
                infoDictionary[plistType.rawValue] = merchant.bundleID
            case .webViewURL:
                infoDictionary[plistType.rawValue] = merchant.storeURL
            case .launchScreen:
                infoDictionary[plistType.rawValue] = "Splash.storyboard"
            }
        }
        if infoDictionary.write(toFile: path, atomically: true) {
            print(merchant)
        } else {
            print("Error writing Info.plist.")
        }
    }
}
let infopath = originalpath + "/App/Info.plist"
InfoPlistConfiguration().updateInfoPlist(for: infopath, with: config)

func downloadFirebaseConfigFile() {
    let location = originalpath + "/App/" + "GoogleService-Info.plist"
    try? FileManager.default.removeItem(atPath: location)
    guard let url = URL(string: config.googlePlist) else { return }
    let data = try! Data(contentsOf: url)
    try? FileManager.default.createDirectory(atPath: originalpath + "/App", withIntermediateDirectories: true)
    print(FileManager.default.createFile(atPath: location, contents: data))
}

downloadFirebaseConfigFile()


//MARK: - Set App icon
let contentjson = """
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
try? FileManager.default.createDirectory(atPath: merchantDataLocation + "/Branding.xcassets", withIntermediateDirectories: true)
FileManager.default.createFile(atPath: merchantDataLocation + "/Branding.xcassets/Content.json", contents: contentjson.data(using: .utf8))
try? FileManager.default.createDirectory(atPath: merchantDataLocation + "/Branding.xcassets" + "/AppIcon.appiconset", withIntermediateDirectories: true)

let content = """
{
  "images" : [
    {
      "filename" : "appstore.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
FileManager.default.createFile(atPath: merchantDataLocation + "/Branding.xcassets/AppIcon.appiconset/Contents.json", contents: content.data(using: .utf8))
downloadImageAndSaveAs(name: "appstore", from: config.appicon, path: "/Branding.xcassets/AppIcon.appiconset/")

//MARK: - project generator
func generateproject() {
    let projectYML = """
name: Ecommerce
targets:
  MobileAppSourceCodeV1:
    postBuildScripts:
          - script: |
             cd ${SRCROOT}
             echo "POST BUILT SCRIPT"
             ${PODS_ROOT}/FirebaseCrashlytics/run
    type: application
    platform: iOS
   
    deploymentTarget: "15.0"
    sources:
      - App
      - merchant_data
      - \(config.themeID)
settings:
  base:
    PRODUCT_NAME: Ecommerce
    LAUNCH_SCREEN_STORYBOARD_NAME: Splash.storyboard
    CODE_SIGN_ENTITLEMENTS: 'MobileAppSourceCodeV1.entitlements'
    DEVELOPMENT_TEAM: R3B2KWC3DK
"""
    try? FileManager.default.removeItem(atPath: "./project.yml")
    FileManager.default.createFile(atPath: "./project.yml", contents: projectYML.data(using: .utf8))
}

generateproject()
