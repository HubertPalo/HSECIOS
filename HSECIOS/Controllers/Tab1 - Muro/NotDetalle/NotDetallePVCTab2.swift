import UIKit

class NotDetallePVCTab2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? NotDetalleVC {
            padre.selectTab(1)
        }
    }
    
}
