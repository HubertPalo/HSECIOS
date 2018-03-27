import UIKit

class InsObservacionPVCTab2: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
