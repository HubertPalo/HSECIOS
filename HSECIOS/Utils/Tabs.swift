import UIKit

class Tabs {
    static let sb = UIStoryboard.init(name: "Main", bundle: nil)
    
    static var forObsDetalle: [UIViewController] = []
    static var flagsObsDetalle: [Bool] = []
    static var indexObsDetalle: Int = 0
    
    static var forInsDetalle: [UIViewController] = []
    static var flagsInsDetalle: [Bool] = []
    static var indexInsDetalle: Int = 0
    
    static var forInsObservacion: [UIViewController] = []
    static var flagsInsObservacion: [Bool] = []
    static var indexInsObservacion: Int = 0
    
    static var forNotDetalle: [UIViewController] = []
    static var flagsNotDetalle: [Bool] = []
    static var indexNotDetalle: Int = 0
    
    static var forTest: [UIViewController] = []
    
    static var forNewObs: [UIViewController] = []
    static var flagsNewObs: [Bool] = []
    
    
    
    static func initTabs() {
        forObsDetalle = [
            sb.instantiateViewController(withIdentifier: "tabObsDetalle1"),
            sb.instantiateViewController(withIdentifier: "tabObsDetalle2"),
            sb.instantiateViewController(withIdentifier: "tabObsDetalle3"),
            sb.instantiateViewController(withIdentifier: "tabObsDetalle4"),
            sb.instantiateViewController(withIdentifier: "tabObsDetalle5")
        ]
        forInsDetalle = [
            sb.instantiateViewController(withIdentifier: "tabInsDetalle1"),
            sb.instantiateViewController(withIdentifier: "tabInsDetalle2"),
            sb.instantiateViewController(withIdentifier: "tabInsDetalle3"),
            sb.instantiateViewController(withIdentifier: "tabInsDetalle4")
        ]
        forInsObservacion = [
            sb.instantiateViewController(withIdentifier: "tabInsObservacion1"),
            sb.instantiateViewController(withIdentifier: "tabInsObservacion2"),
            sb.instantiateViewController(withIdentifier: "tabInsObservacion3")
        ]
        forNotDetalle = [
            sb.instantiateViewController(withIdentifier: "tabNotDetalle1"),
            sb.instantiateViewController(withIdentifier: "tabNotDetalle2"),
            sb.instantiateViewController(withIdentifier: "tabNotDetalle3")
        ]
        forNewObs = [
            sb.instantiateViewController(withIdentifier: "tabMuroNewObs1"),
            sb.instantiateViewController(withIdentifier: "tabMuroNewObs2"),
            sb.instantiateViewController(withIdentifier: "tabMuroNewObs3"),
            sb.instantiateViewController(withIdentifier: "tabMuroNewObs4")
        ]
        
        flagsObsDetalle = [Bool].init(repeating: true, count: forObsDetalle.count)
        flagsInsDetalle = [Bool].init(repeating: true, count: forInsDetalle.count)
        flagsInsObservacion = [Bool].init(repeating: true, count: forInsObservacion.count)
        flagsNotDetalle = [Bool].init(repeating: true, count: forNotDetalle.count)
        flagsNewObs = [Bool].init(repeating: true, count: forNewObs.count)
    }
    
    static func getNextVCFor(_ viewcontroller: UIViewController, forward: Bool) -> UIViewController? {
        var index = indexFor(viewcontroller)
        let flags = flagsFor(viewcontroller)
        let views = viewsFor(viewcontroller)
        let length = flags.count
        
        if forward {
            index += 1
            while index != length && !flags[index] {
                index += 1
            }
            print("\(index) - \(views.count)")
            if index == length {
                return nil
            } else {
                return views[index]
            }
        } else {
            index -= 1
            while index != -1 && !flags[index] {
                index -= 1
            }
            if index == -1 {
                return nil
            } else {
                return views[index]
            }
        }
    }
    
    static func indexFor(_ viewcontroller: UIViewController) -> Int {
        if viewcontroller is ObsDetallePVCTab1 || viewcontroller is InsDetallePVCTab1 || viewcontroller is MuroNewObsPVCTab1 || viewcontroller is InsObservacionPVCTab1 || viewcontroller is NotDetallePVCTab1 {
            return 0
        }
        if viewcontroller is ObsDetallePVCTab2 || viewcontroller is InsDetallePVCTab2 || viewcontroller is MuroNewObsPVCTab2 || viewcontroller is InsObservacionPVCTab2 || viewcontroller is NotDetallePVCTab2 {
            return 1
        }
        if viewcontroller is ObsDetallePVCTab3 || viewcontroller is InsDetallePVCTab3 || viewcontroller is MuroNewObsPVCTab3 || viewcontroller is InsObservacionPVCTab3 || viewcontroller is NotDetallePVCTab3 {
            return 2
        }
        if viewcontroller is ObsDetallePVCTab4 || viewcontroller is InsDetallePVCTab4 || viewcontroller is MuroNewObsPVCTab4{
            return 3
        }
        if viewcontroller is ObsDetallePVCTab5 {
            return 4
        }
        return -1
    }
    
    static func flagsFor(_ viewcontroller: UIViewController) -> [Bool] {
        if viewcontroller is ObsDetallePVCTab1 || viewcontroller is ObsDetallePVCTab2 || viewcontroller is ObsDetallePVCTab3 || viewcontroller is ObsDetallePVCTab4 || viewcontroller is ObsDetallePVCTab5 {
            return flagsObsDetalle
        }
        
        if viewcontroller is InsDetallePVCTab1 || viewcontroller is InsDetallePVCTab2 || viewcontroller is InsDetallePVCTab3 || viewcontroller is InsDetallePVCTab4 {
            return flagsInsDetalle
        }
        
        if viewcontroller is InsObservacionPVCTab1 || viewcontroller is InsObservacionPVCTab2 || viewcontroller is InsObservacionPVCTab3 {
            return flagsInsObservacion
        }
        
        if viewcontroller is NotDetallePVCTab1 || viewcontroller is NotDetallePVCTab2 || viewcontroller is NotDetallePVCTab3 {
            return flagsNotDetalle
        }
        
        if viewcontroller is MuroNewObsPVCTab1 || viewcontroller is MuroNewObsPVCTab2 || viewcontroller is MuroNewObsPVCTab3 || viewcontroller is MuroNewObsPVCTab4 {
            return flagsNewObs
        }
        
        
        
        return []
    }
    
    static func viewsFor(_ viewcontroller: UIViewController) -> [UIViewController] {
        if viewcontroller is ObsDetallePVCTab1 || viewcontroller is ObsDetallePVCTab2 || viewcontroller is ObsDetallePVCTab3 || viewcontroller is ObsDetallePVCTab4 || viewcontroller is ObsDetallePVCTab5 {
            return forObsDetalle
        }
        
        if viewcontroller is InsDetallePVCTab1 || viewcontroller is InsDetallePVCTab2 || viewcontroller is InsDetallePVCTab3 || viewcontroller is InsDetallePVCTab4 {
            return forInsDetalle
        }
        
        if viewcontroller is InsObservacionPVCTab1 || viewcontroller is InsObservacionPVCTab2 || viewcontroller is InsObservacionPVCTab3 {
            return forInsObservacion
        }
        
        if viewcontroller is NotDetallePVCTab1 || viewcontroller is NotDetallePVCTab2 || viewcontroller is NotDetallePVCTab3 {
            return forNotDetalle
        }
        
        if viewcontroller is MuroNewObsPVCTab1 || viewcontroller is MuroNewObsPVCTab2 || viewcontroller is MuroNewObsPVCTab3 || viewcontroller is MuroNewObsPVCTab4 {
            return forNewObs
        }
        
        return []
    }
    
    static func updateTabs(_ tabs: UISegmentedControl, flags: [Bool]) {
        for i in 0..<flags.count {
            tabs.setEnabled(flags[i], forSegmentAt: i)
            /*if flags[i] {
                //tabs.setTitle("\(i)", forSegmentAt: i)
            } else {
                //tabs.setTitle("", forSegmentAt: i)
                tabs.setWidth(0, forSegmentAt: i)
            }*/
        }
    }
    
    static func selectTabIndex(_ tabs: UISegmentedControl, _ scroll: UIScrollView, _ index: Int, updateSlider: @escaping (_ direction: UIPageViewControllerNavigationDirection)-> Void ){
        let oldSegmentIndex = tabs.selectedSegmentIndex
        tabs.selectedSegmentIndex = index
        
        var direction = UIPageViewControllerNavigationDirection.forward
        let newSegmentIndex = tabs.selectedSegmentIndex
        if newSegmentIndex < oldSegmentIndex {
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        focusScroll(tabs, scroll)
        updateSlider(direction)
    }
    
    static func focusScroll(_ tabs: UISegmentedControl, _ scroll: UIScrollView) {
        let height = tabs.frame.height
        let width = tabs.frame.width
        let singleTabWidth = width/CGFloat(tabs.numberOfSegments)
        let rect = CGRect.init(
            x: singleTabWidth*CGFloat(tabs.selectedSegmentIndex),
            y: CGFloat(0),
            width: singleTabWidth,
            height: height)
        scroll.scrollRectToVisible(rect, animated: true)
    }
}

