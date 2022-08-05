import UIKit

public extension UINavigationController {
    
    func applyKevinNavigationBarStyle() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .init { traitCollection in
                UIApplication.shared.isLightThemedInterface ?
                Kevin.shared.theme.navigationBarStyle.backgroundColorLightMode :
                Kevin.shared.theme.navigationBarStyle.backgroundColorDarkMode
            }
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Kevin.shared.theme.navigationBarStyle.titleColor]
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Kevin.shared.theme.navigationBarStyle.titleColor]
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            navigationBar.barTintColor = UIApplication.shared.isLightThemedInterface ?
            Kevin.shared.theme.navigationBarStyle.backgroundColorLightMode :
            Kevin.shared.theme.navigationBarStyle.backgroundColorDarkMode
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Kevin.shared.theme.navigationBarStyle.titleColor]
        }
    }
}
