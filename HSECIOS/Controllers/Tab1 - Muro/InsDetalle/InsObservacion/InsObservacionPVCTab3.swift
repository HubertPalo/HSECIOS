import UIKit

class InsObservacionPVCTab3: UIViewController {
    
    var planes: [ObsPlanAccion] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(2)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let padre = self.parent?.parent as! InsObservacionVC
        let hijo = self.childViewControllers[0] as! PlanAccionVC
        hijo.loadData(codigo: padre.codigo)
        /*Helper.getData(Routes.forObsPlanAccion(padre.codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
            self.planes = Dict.toArrayObsPlanAccion(dict)
            
        })*/
    }
}
