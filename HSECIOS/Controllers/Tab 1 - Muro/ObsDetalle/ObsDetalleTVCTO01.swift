import UIKit

class ObsDetalleTVCTO01: UITableViewController {
    // Comportamiento
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! Celda2Texto1View
        switch indexPath.row {
        case 0:
            celda.texto1.text = "Comportamiento Sub-estándar observado"
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
            celda.texto1.text = "Acto Sub-estándar"
            celda.texto2.text = Utils.searchMaestroStatic("ACTOSUBESTANDAR", Globals.UOTab2ObsDetalle.CodSubEstandar ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 5:
            celda.texto1.text = "Estado"
            celda.texto2.text = Utils.searchMaestroDescripcion("ESOB", Globals.UOTab2ObsDetalle.CodEstado ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        case 6:
            celda.texto1.text = "Error"
            celda.texto2.text = Utils.searchMaestroDescripcion("EROB", Globals.UOTab2ObsDetalle.CodError ?? "")
            celda.view.layer.borderColor = UIColor.gray.cgColor
            celda.view.layer.borderWidth = 0.5
        default:
            break
        }
        return celda
    }
}
