import UIKit

class ContactenosVC: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Contáctenos", Images.minero)
        self.tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    @IBAction func ClickMenu(_ sender: Any) {
        Utils.openMenu()
    }
}
