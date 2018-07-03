import UIKit

class InsObservacionPVCTab2: UIViewController {
    
    var insObs = InsObservacion()
    
    var galeria = GaleriaFVDVC()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(1)
        }
        self.galeria.loadGaleria(insObs.CodInspeccion)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDVC
        self.galeria.galeria.modo = "GET"
        
        // hijo.getFilesFor(padre.codigo)
        
    }
}
