import UIKit

class NotDetalleVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    var oldSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        Tabs.updateTabs(tabs, flags: Tabs.flagsNotDetalle)
        selectTab(Tabs.indexNotDetalle)
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! NotDetallePVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(tabs, tabsScroll)
        slider.setViewControllers([Tabs.forNotDetalle[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! NotDetallePVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(tabs, tabsScroll)
        slider.setViewControllers([Tabs.forNotDetalle[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
}
