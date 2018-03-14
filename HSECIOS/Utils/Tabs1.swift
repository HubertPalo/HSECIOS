import UIKit

class tabs1 {
    static let sb = UIStoryboard.init(name: "Main", bundle: nil)
    static var tabs: [UIViewController] = []

    static func initTabs() {
        tabs = [
            tabs1.sb.instantiateViewController(withIdentifier: "Tab1"),
            tabs1.sb.instantiateViewController(withIdentifier: "Tab2"),
            tabs1.sb.instantiateViewController(withIdentifier: "Tab3"),
            tabs1.sb.instantiateViewController(withIdentifier: "Tab4")
        ]
    }
    
}
