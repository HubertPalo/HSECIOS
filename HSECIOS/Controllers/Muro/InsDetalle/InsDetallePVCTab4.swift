import UIKit

class InsDetallePVCTab4: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
    if let padre = self.parent?.parent as? InsDetalleVC {
        padre.selectTab(3)
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

