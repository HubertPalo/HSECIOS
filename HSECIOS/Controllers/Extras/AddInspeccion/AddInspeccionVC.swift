import UIKit

class AddInspeccionVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    @IBOutlet weak var tabsScroll: UIScrollView!
    var oldSegmentIndex = 0
    
    var data: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Nueva inspección", Images.inspeccion)
        
        self.automaticallyAdjustsScrollViewInsets = false
       
        
        self.tabsScroll.contentSize = self.tabs.bounds.size
        
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        //self.tabsScroll.frame = self.tabs.frame
       
        print("frames: \(self.tabsScroll.frame)")
        print("contentsize: \(self.tabsScroll.contentSize)")
        
        //self.tabsScroll.contentSize = self.tabs.frame.size
        print("frames: \(self.tabsScroll.frame)")
        print("contentsize: \(self.tabsScroll.contentSize)")
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! AddInspeccionPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        // focusScroll()
        slider.setViewControllers([Tabs.forAddIns[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        } else {
            Utils.openMenuTab()
        }
    }
    
    
    @IBAction func clickSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! AddInspeccionPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        Tabs.focusScroll(self.tabs, self.tabsScroll)
        slider.setViewControllers([Tabs.forAddIns[self.tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
}
