import UIKit

class PlanAccionTVC: UITableViewController {
    
    var planes: [ObsPlanAccion] = []
    
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PlanAccionTVCell
        let unit = planes[indexPath.row]
        celda.tarea.text = unit.DesPlanAccion
        celda.responsable.text = unit.Responsables
        celda.area.text = unit.CodAreaHSEC
        celda.estado.text = unit.CodEstadoAccion
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let insObsVC = self.parent?.parent?.parent?.parent as? InsObservacionVC {
            insObsVC.plan = planes[indexPath.row]
            insObsVC.performSegue(withIdentifier: "toPlanDetalle", sender: self)
        }
    }
}

class PlanAccionTVCell: UITableViewCell {
    
    @IBOutlet weak var tarea: UILabel!
    
    @IBOutlet weak var responsable: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
    
}
