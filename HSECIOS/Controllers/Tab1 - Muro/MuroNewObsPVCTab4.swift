import UIKit

class MuroNewObsPVCTab4: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? MuroNewObsVC {
            padre.selectTab(3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

