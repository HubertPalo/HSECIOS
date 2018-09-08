import UIKit

class ConfiguracionVC: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("Configuración", Images.minero)
        self.tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    @IBAction func ClickMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
    @IBAction func clickRecargarMaestro(_ sender: Any) {
        Config.getAllMaestro(true, true)
    }
    
}
