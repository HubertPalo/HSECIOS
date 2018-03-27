import UIKit

class MuroNewObsPVCTab3: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? MuroNewObsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

