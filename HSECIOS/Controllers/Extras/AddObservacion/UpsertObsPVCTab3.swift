import UIKit

class UpsertObsPVCTab3: UIViewController {
    
    var modo = "ADD"
    var codigo = ""
    
    var galeriaVC = GaleriaFVDVC()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeriaVC = self.childViewControllers[0] as! GaleriaFVDVC
    }
}
