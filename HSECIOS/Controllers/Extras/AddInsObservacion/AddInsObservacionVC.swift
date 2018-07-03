import UIKit

class AddInsObservacionVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    var oldSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
