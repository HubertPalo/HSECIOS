import UIKit

class Tab1VC: UIViewController {
    let id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.parent?.parent != nil {
            (self.parent?.parent as! Handler).segments.selectedSegmentIndex = 0
        }
        
    }
}
