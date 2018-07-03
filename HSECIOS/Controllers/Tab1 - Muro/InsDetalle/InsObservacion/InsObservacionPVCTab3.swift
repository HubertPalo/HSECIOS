import UIKit

class InsObservacionPVCTab3: UIViewController {
    
    var planes: [PlanAccionDetalle] = []
    var insObs = InsObservacion()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(2)
        }
        let hijo = self.childViewControllers[0] as! ObsPlanAccionVC
        hijo.loadData(codigo: insObs.CodInspeccion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let padre = self.parent?.parent as! InsObservacionVC
        
        /*Helper.getData(Routes.forObsPlanAccion(padre.codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
            self.planes = Dict.toArrayObsPlanAccion(dict)
            
        })*/
    }
}
