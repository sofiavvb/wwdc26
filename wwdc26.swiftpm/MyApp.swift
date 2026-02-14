import SwiftUI
import CoreText

@main
struct MyApp: App {
    init() {
        registerFont(named: "Jersey10-Regular.ttf")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

func registerFont(named fontName: String) {
  guard let url = Bundle.main.url(forResource: fontName, withExtension: nil),
    CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)
  else {
    print("failed to load font:", fontName)
    return
  }
}
