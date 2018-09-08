import UIKit

/*class PlanAccionTVC: UITableViewController {
    
    var planAccion: PlanAccionDetalle = PlanAccionDetalle()
    var accionesMejora: [AccionMejora] = []
    
    var responsables: [Persona] = []
    var valuesForDetalle: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return valuesForDetalle.count
        case 1:
            return responsables.count
        case 2:
            return 1
        case 3:
            return accionesMejora.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaDetalle") as! PlanAccionTVCellDetalle
            celda.textoIzquierda.text = valuesForDetalle[indexPath.row][0]
            celda.textoDerecha.text = valuesForDetalle[indexPath.row][1]
            return celda
        case 1:
            let unit = responsables[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPersona") as! PlanAccionTVCellPersona
            celda.nombreCompleto.text = unit.Nombres
            celda.cargo.text = unit.Cargo
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaResgistro")
            return celda!
        case 3:
            let unit = accionesMejora[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaAccion") as! PlanAccionTVCellAccion
            celda.descripcion.text = unit.Descripcion
            celda.avance.text = unit.PorcentajeAvance
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "headerLabel100") as! PlanAccionTVHLabel100
            celda.texto100.text = "Detalle Plan Acción"
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "headerLabel100") as! PlanAccionTVHLabel100
            celda.texto100.text = "Responsables"
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "headerLabel100") as! PlanAccionTVHLabel100
            celda.texto100.text = "Levantar Observación"
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "headerLabel60Label20Label20") as! PlanAccionTVHLabel60Label20Label20
            celda.texto60.text = "Descripción"
            celda.texto20a.text = "% Avance"
            celda.texto20b.text = "Editar"
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    
}

class PlanAccionTVCellDetalle: UITableViewCell {
    @IBOutlet weak var textoIzquierda: UILabel!
    @IBOutlet weak var textoDerecha: UILabel!
}

class PlanAccionTVCellPersona: UITableViewCell {
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var cargo: UILabel!
}

class PlanAccionTVCellAccion: UITableViewCell {
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var avance: UILabel!
}

class PlanAccionTVHLabel100: UITableViewCell {
    @IBOutlet weak var texto100: UILabel!
}

class PlanAccionTVHLabel60Label20Label20: UITableViewCell {
    @IBOutlet weak var texto60: UILabel!
    @IBOutlet weak var texto20a: UILabel!
    @IBOutlet weak var texto20b: UILabel!
}*/
