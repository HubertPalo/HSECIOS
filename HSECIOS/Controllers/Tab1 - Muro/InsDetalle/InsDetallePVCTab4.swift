import UIKit

class InsDetallePVCTab4: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
    if let padre = self.parent?.parent as? InsDetalleVC {
        padre.selectTab(3)
    }
        let hijo = self.childViewControllers[0] as! ComentariosVC
        hijo.codigo = Utils.selectedObsCode
        hijo.updateDataForCode(code: Utils.selectedObsCode)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

