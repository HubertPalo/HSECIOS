import UIKit

class MuroNewObsPVCTab2: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? MuroNewObsVC {
            padre.selectTab(1)
        }
        
    }
        
    
        override func viewDidLoad() {
        super.viewDidLoad()
        }
    }

