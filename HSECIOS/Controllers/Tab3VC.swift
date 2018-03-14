import UIKit

class Tab3VC: UIViewController {
    let id = 2
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (self.parent?.parent as! Handler).segments.selectedSegmentIndex = 2
    }
}
