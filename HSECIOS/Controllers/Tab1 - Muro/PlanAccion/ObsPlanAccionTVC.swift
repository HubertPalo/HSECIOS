import UIKit

class ObsPlanAccionTVC: UITableViewController {
    
    var planes: [PlanAccionDetalle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! ObsPlanAccionTVCell
        let unit = planes[indexPath.row]
        
        celda.tarea.text = unit.DesPlanAccion
        celda.responsable.text = unit.Responsables
        celda.area.text = unit.CodAreaHSEC
        celda.estado.text = unit.CodEstadoAccion
        
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = planes[indexPath.row]
        VCHelper.openPlanAccionDetalle(self, unit)
        /*if let insObsVC = self.parent?.parent?.parent?.parent as? InsObservacionVC {
            
            insObsVC.performSegue(withIdentifier: "toPlanDetalle", sender: self)
        }*/
    }
}

class ObsPlanAccionTVCell: UITableViewCell {
    
    @IBOutlet weak var tarea: UILabel!
    
    @IBOutlet weak var responsable: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
    
}
