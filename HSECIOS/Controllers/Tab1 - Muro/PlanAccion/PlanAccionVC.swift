import UIKit

class PlanAccionVC: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(codigo: String){
        Helper.getData(Routes.forObsPlanAccion(codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
            let data = Dict.toArrayObsPlanAccion(dict)
            let hijo = self.childViewControllers[0] as! PlanAccionTVC
            hijo.planes = data
            hijo.tableView.reloadData()
        })
    }
}
