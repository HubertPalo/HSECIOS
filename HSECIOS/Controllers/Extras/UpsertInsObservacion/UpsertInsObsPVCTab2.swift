import UIKit

class UpsertInsObsPVCTab2: UIViewController {
    
    var galeria = GaleriaFVDTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDTVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertInsObsVC {
            padre.selectTab(1)
        }
    }
}


