import UIKit

class ObsDetalleTVCTO02: UITableViewController {
    // Condición
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! Celda2Texto1View
        switch indexPath.row {
        case 0:
            celda.texto1.text = "Condición Sub-estándar observada"
            celda.texto2.text = Globals.UOTab2ObsDetalle.Observacion ?? "-"
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 1:
            celda.texto1.text = "Acción inmediata (Corrección)"
            celda.texto2.text = Globals.UOTab2ObsDetalle.Accion ?? "-"
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 2:
            celda.texto1.text = "Actividad relacionada"
            celda.texto2.text = Utils.searchMaestroDescripcion("ACTR", Globals.UOTab2ObsDetalle.CodActiRel ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 3:
            celda.texto1.text = "HHA relacionada"
            celda.texto2.text = Utils.searchMaestroDescripcion("HHAR", Globals.UOTab2ObsDetalle.CodHHA ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 4:
            celda.texto1.text = "Condición Sub-estándar"
            celda.texto2.text = Utils.searchMaestroStatic("CONDICIONSUBESTANDAR", Globals.UOTab2ObsDetalle.CodSubEstandar ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        default:
            break
        }
        return celda
    }
}
