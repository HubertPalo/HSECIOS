import UIKit

class ObsPlanAccionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(codigo: String){
        Rest.getDataGeneral(Routes.forObsPlanAccion(codigo), false, success: {(resultValue:Any?,data:Data?) in
            let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
            let hijo = self.childViewControllers[0] as! ObsPlanAccionTVC
            hijo.planes = arrayPlanes.Data
            hijo.tableView.reloadData()
        }, error: nil)
    }
}
