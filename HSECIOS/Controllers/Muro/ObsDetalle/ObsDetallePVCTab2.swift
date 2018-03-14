import UIKit

class ObsDetallePVCTab2: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
