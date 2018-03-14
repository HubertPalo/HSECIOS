import UIKit

class Tab2VC: UIViewController {
    let id = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        (self.parent?.parent as! Handler).segments.selectedSegmentIndex = 1
    }
}
