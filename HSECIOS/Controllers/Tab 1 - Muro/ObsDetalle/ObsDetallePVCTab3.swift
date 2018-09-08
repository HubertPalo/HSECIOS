import UIKit

class ObsDetallePVCTab3: UIViewController {
    
    // @IBOutlet weak var galeriaBarButton: UIBarButtonItem!
    
    var galeria = GaleriaFVDVC()
    
    override func viewWillAppear(_ animated: Bool) {
        self.galeria.galeria.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDVC
        self.galeria.galeria.descargaDocumentoBarButton = (self.parent?.parent as! ObsDetalleVC).botonTopDer
    }
}
