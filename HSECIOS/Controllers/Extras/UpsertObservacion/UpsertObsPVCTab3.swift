import UIKit

class UpsertObsPVCTab3: UIViewController {
    
    var modo = "ADD"
    var codigo = ""
    
    var galeriaTVC = GaleriaFVDTVC()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeriaTVC = self.childViewControllers[0] as! GaleriaFVDTVC
        self.galeriaTVC.descargaDocumentoBarButton = (self.parent?.parent as! UpsertObsVC).botonTopDer
    }
}
