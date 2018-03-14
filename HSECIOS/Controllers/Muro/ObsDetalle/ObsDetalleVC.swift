import UIKit

class ObsDetalleVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    var oldSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //tabs.apportionsSegmentWidthsByContent = true
        
        //Tabs.flagsObsDetalle[1] = true
        Tabs.updateTabs(tabs, flags: Tabs.flagsObsDetalle)
        selectTab(Tabs.indexObsDetalle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectTab(Tabs.indexObsDetalle)
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
        let slider = self.childViewControllers[0] as! ObsDetallePVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forObsDetalle[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! ObsDetallePVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forObsDetalle[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
}
