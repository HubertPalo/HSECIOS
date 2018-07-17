import UIKit

class EstadGralTVC: UITableViewController {
    
    var estadisticas: [EstadisticaGral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estadisticas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! EstadGralTVCell
        let unit = estadisticas[indexPath.row]
        celda.titulo.text = unit.Descripcion
        celda.estimados.text = "(\(unit.Estimados ?? 0)) Estimados"
        celda.ejecutados.text = "(\(unit.Ejecutados ?? 0)) Ejecutados"
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let padre = self.parent as! EstadGralVC
        padre.estadisticaClicked = estadisticas[indexPath.row]
        padre.performSegue(withIdentifier: "toEstadDetalle", sender: self)
    }
    
}

class EstadGralTVCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var estimados: UILabel!
    @IBOutlet weak var ejecutados: UILabel!
}
