import UIKit

class CapacitacionesCVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var capacitaciones: [Capacitacion] = []
    var capacitacionesTemp: [Capacitacion] = []
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capacitaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! CapacitacionesCVCell
        let unit = capacitaciones[indexPath.row]
        celda.tema.text = unit.Tema
        celda.estado.text = unit.Estado
        celda.nota.text = unit.Nota
        return celda
    }
}

class CapacitacionesCVCell: UITableViewCell {
    @IBOutlet weak var tema: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var nota: UILabel!
}
