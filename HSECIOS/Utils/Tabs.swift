import UIKit

class Tabs {
    static let sb = UIStoryboard.init(name: "Main", bundle: nil)
    
    //static var menuVC
    
    
    static var forObsDetalle: [UIViewController] = []
    static var flagsObsDetalle: [Bool] = []
    static var indexObsDetalle: Int = 0
    
    static var forInsDetalle: [UIViewController] = []
    static var flagsInsDetalle: [Bool] = []
    static var indexInsDetalle: Int = 0
    
    static var forInsObservacion: [UIViewController] = []
    static var flagsInsObservacion: [Bool] = []
    static var indexInsObservacion: Int = 0
    
    static var forAddObs: [UIViewController] = []
    static var flagsAddObs: [Bool] = []
    static var indexAddObs: Int = 0
    
    static var forAddIns: [UIViewController] = []
    static var flagsAddIns: [Bool] = []
    static var indexAddIns: Int = 0
    
    static var forAddInsObs: [UIViewController] = []
    static var flagsAddInsObs: [Bool] = []
    static var indexAddInsObs: Int = 0
    
    static func initTabs() {
        forObsDetalle = [
            Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabObsDetalle1"),
            Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabObsDetalle2"),
            Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabObsDetalle3"),
            Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabObsDetalle4"),
            Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabObsDetalle5")
        ]
        forInsDetalle = [
            Utils.insDetalleSB.instantiateViewController(withIdentifier: "tabInsDetalle1"),
            Utils.insDetalleSB.instantiateViewController(withIdentifier: "tabInsDetalle2"),
            Utils.insDetalleSB.instantiateViewController(withIdentifier: "tabInsDetalle3"),
            Utils.insDetalleSB.instantiateViewController(withIdentifier: "tabInsDetalle4")
        ]
        forInsObservacion = [
            Utils.insObsDetalleSB.instantiateViewController(withIdentifier: "tabInsObservacion1"),
            Utils.insObsDetalleSB.instantiateViewController(withIdentifier: "tabInsObservacion2"),
            Utils.insObsDetalleSB.instantiateViewController(withIdentifier: "tabInsObservacion3")
        ]
        forAddObs = [
            Utils.addObservacionSB.instantiateViewController(withIdentifier: "tabAddObs1"),
            Utils.addObservacionSB.instantiateViewController(withIdentifier: "tabAddObs2"),
            Utils.addObservacionSB.instantiateViewController(withIdentifier: "tabAddObs3"),
            Utils.addObservacionSB.instantiateViewController(withIdentifier: "tabAddObs4")
        ]
        forAddIns = [
            Utils.addInspeccionSB.instantiateViewController(withIdentifier: "tabAddIns1"),
            Utils.addInspeccionSB.instantiateViewController(withIdentifier: "tabAddIns2"),
            Utils.addInspeccionSB.instantiateViewController(withIdentifier: "tabAddIns3")
        ]
        forAddInsObs = [
            Utils.addInsObsSB.instantiateViewController(withIdentifier: "tabAddInsObs1"),
            Utils.addInsObsSB.instantiateViewController(withIdentifier: "tabAddInsObs2"),
            Utils.addInsObsSB.instantiateViewController(withIdentifier: "tabAddInsObs3")
        ]
        
        flagsObsDetalle = [Bool].init(repeating: true, count: forObsDetalle.count)
        flagsInsDetalle = [Bool].init(repeating: true, count: forInsDetalle.count)
        flagsInsObservacion = [Bool].init(repeating: true, count: forInsObservacion.count)
        flagsAddObs = [Bool].init(repeating: true, count: forAddObs.count)
        flagsAddIns = [Bool].init(repeating: true, count: forAddIns.count)
        flagsAddInsObs = [Bool].init(repeating: true, count: forAddInsObs.count)
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
        if viewcontroller is ObsDetallePVCTab1 || viewcontroller is InsDetallePVCTab1 || viewcontroller is UpsertObsPVCTab1 || viewcontroller is InsObservacionPVCTab1 || viewcontroller is UpsertInsPVCTab1 || viewcontroller is UpsertInsObsPVCTab1 {
            return 0
        }
        if viewcontroller is ObsDetallePVCTab2 || viewcontroller is InsDetallePVCTab2 || viewcontroller is UpsertObsPVCTab2 || viewcontroller is InsObservacionPVCTab2 || viewcontroller is UpsertInsPVCTab2 || viewcontroller is UpsertInsObsPVCTab2 {
            return 1
        }
        if viewcontroller is ObsDetallePVCTab3 || viewcontroller is InsDetallePVCTab3 || viewcontroller is UpsertObsPVCTab3 || viewcontroller is InsObservacionPVCTab3 || viewcontroller is UpsertInsPVCTab3 || viewcontroller is UpsertInsObsPVCTab3 {
            return 2
        }
        if viewcontroller is ObsDetallePVCTab4 || viewcontroller is InsDetallePVCTab4 || viewcontroller is UpsertObsPVCTab4 {
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
        
        if viewcontroller is UpsertObsPVCTab1 || viewcontroller is UpsertObsPVCTab2 || viewcontroller is UpsertObsPVCTab3 || viewcontroller is UpsertObsPVCTab4 {
            return flagsAddObs
        }
        
        if viewcontroller is UpsertInsPVCTab1 || viewcontroller is UpsertInsPVCTab2 || viewcontroller is UpsertInsPVCTab3 {
            return flagsAddIns
        }
        
        if viewcontroller is UpsertInsObsPVCTab1 || viewcontroller is UpsertInsObsPVCTab2 || viewcontroller is UpsertInsObsPVCTab3 {
            return flagsAddInsObs
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
        
        if viewcontroller is UpsertObsPVCTab1 || viewcontroller is UpsertObsPVCTab2 || viewcontroller is UpsertObsPVCTab3 || viewcontroller is UpsertObsPVCTab4 {
            return forAddObs
        }
        
        if viewcontroller is UpsertInsPVCTab1 || viewcontroller is UpsertInsPVCTab2 || viewcontroller is UpsertInsPVCTab3 {
            return forAddIns
        }
        
        if viewcontroller is UpsertInsObsPVCTab1 || viewcontroller is UpsertInsObsPVCTab2 || viewcontroller is UpsertInsObsPVCTab3 {
            return forAddInsObs
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

