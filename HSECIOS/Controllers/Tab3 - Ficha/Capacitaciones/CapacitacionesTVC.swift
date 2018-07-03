import UIKit

class CapacitacionesTVC: UITableViewController {
    
    var capacitaciones: [Capacitacion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capacitaciones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! CapacitacionesTVCell
        let unit = capacitaciones[indexPath.row]
        celda.tema.text = unit.Tema
        celda.estado.text = unit.Estado
        celda.nota.text = unit.Nota
        print("\(unit.Tema) - \(unit.Estado) - \(unit.Nota)")
        return celda
    }
}

class CapacitacionesTVCell: UITableViewCell {
    @IBOutlet weak var tema: UILabel!
    @IBOutlet weak var nota: UILabel!
    @IBOutlet weak var estado: UILabel!
}
