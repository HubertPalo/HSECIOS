import UIKit

class ObsDetalleVC: UIViewController {
    
    @IBOutlet weak var tabs: UISegmentedControl!
    
    @IBOutlet weak var tabsScroll: UIScrollView!
    
    @IBOutlet weak var barraInf: UIView!
    
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    var oldSegmentIndex = 0
    
    var observacion: MuroElement = MuroElement()
    
    var codigo = ""
    
    var shouldReload = false
    
    // var hijo = ObsDetallePVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tabs.customize(barraInf)
        Utils.setTitleAndImage(self, "Observación", Images.observacion)
        Tabs.updateTabs(tabs, flags: Tabs.flagsObsDetalle)
        selectTab(Tabs.indexObsDetalle)
        // self.hijo = self.childViewControllers[0] as! ObsDetallePVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.shouldReload {
            self.shouldReload = false
            selectTab(Tabs.indexObsDetalle)
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
        let barraInfRect = CGRect.init(
            x: singleTabWidth*CGFloat(tabs.selectedSegmentIndex),
            y: height - 3,
            width: singleTabWidth,
            height: 3)
        barraInf.frame = barraInfRect
        tabsScroll.scrollRectToVisible(barraInfRect, animated: true)
        barraInf.frame = barraInfRect
        // self.tabs.bringSubview(toFront: self.barraInf)
        // self.tabs.bringSubview(toFront: self.tabs.subviews[0])
    }
    
    func selectTab(_ index: Int) {
        tabs.selectedSegmentIndex = index
        focusScroll()
        if self.childViewControllers.count > 0 {
            let slider = self.childViewControllers[0] as! ObsDetallePVC
            var direction = UIPageViewControllerNavigationDirection.forward
            let newSegmentIndex = tabs.selectedSegmentIndex
            if newSegmentIndex < oldSegmentIndex {
                direction = UIPageViewControllerNavigationDirection.reverse
            }
            oldSegmentIndex = newSegmentIndex
            
            slider.setViewControllers([Tabs.forObsDetalle[tabs.selectedSegmentIndex]], direction: direction, animated: true, completion: nil)
        }
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
