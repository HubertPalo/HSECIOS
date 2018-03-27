import UIKit

class MuroNewObsVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    var oldSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //tabs.apportionsSegmentWidthsByContent = true
        
        //Tabs.flagsMuro[1] = true
        //Tabs.flagsMuro[3] = false
        //Tabs.updateTabs(tabs, flags: Tabs.flagsMuro)
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
        let slider = self.childViewControllers[0] as! MuroNewObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forNewObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    @IBAction func clickEnSegment(_ sender: Any) {
        let slider = self.childViewControllers[0] as! MuroNewObsPVC
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        oldSegmentIndex = newSegmentIndex
        focusScroll()
        slider.setViewControllers([Tabs.forNewObs[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
    }
    
    
}
