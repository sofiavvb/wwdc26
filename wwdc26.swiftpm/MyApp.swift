import SwiftUI
import CoreText
import Foundation

@main
struct MyApp: App {
    init() {
        registerFont(named: "Jersey10-Regular.ttf")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                FirstLevelView()
            }
        }
    }
}

func registerFont(named fontName: String) {
  guard let url = Bundle.main.url(forResource: fontName, withExtension: nil),
    CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)
  else {
    print("Failed to load font:", fontName)
    return
  }
}
