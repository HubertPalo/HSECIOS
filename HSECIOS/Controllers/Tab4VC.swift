import UIKit

class Tab4VC: UIViewController {
    let id = 3
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (self.parent?.parent as! Handler).segments.selectedSegmentIndex = 3
    }
}
