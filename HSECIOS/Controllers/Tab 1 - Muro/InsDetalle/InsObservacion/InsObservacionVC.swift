import UIKit

class InsObservacionVC: UIViewController {
    
    var oldSegmentIndex = 0
    
    @IBOutlet weak var tabs: UISegmentedControl!
    
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    @IBOutlet weak var tabsInfBar: UIView!
    
    var shouldReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabs.customize(self.tabsInfBar)
        self.automaticallyAdjustsScrollViewInsets = false
        //Tabs.updateTabs(tabs, flags: Tabs.flagsInsDetalle)
        selectTab(Tabs.indexInsObservacion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.shouldReload {
            self.shouldReload = false
            selectTab(Tabs.indexInsObservacion)
        }
    }
    
    func focusScroll() {
        let height = tabs.frame.height
        let width = tabs.frame.width
        let singleTabWidth = width/CGFloat(tabs.numberOfSegments)
        let rect = CGRect.init(
            x: singleTabWidth*CGFloat(tabs.selectedSegmentIndex),
            y: CGFloat(0),
            width: singleTabWidth,
            height: height)
        tabsScroll.scrollRectToVisible(rect, animated: true)
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        let slider = self.childViewControllers[0] as! InsObservacionPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forInsObservacion[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! InsObservacionPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forInsObservacion[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
}
