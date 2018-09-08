import UIKit

class ObsDetalleTVCTO03: UITableViewController {
    // Tarea
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.text = "Detalle observación"
            return header.contentView
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.text = "Personas observadas"
            return header.contentView
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.text = "Aspectos Previos"
            return header.contentView
            /*let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
            header.titulo.text = "Aspectos Previos"
            header.tituloIzq.text = "Descripción"
            header.tituloDer.text = "Calificación"
            //header.tituloIzqWidth.constant = Utils.widthDevice * 0.8
            return header.contentView*/
        case 3:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.text = "Etapas / Desviación"
            // header.tituloIzq.text = "Etapa de la tarea (según PET)"
            // header.tituloDer.text = "Desviación Observada"
            return header.contentView
        case 4:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.text = "Comentarios"
            // header.tituloIzq.text = "Tipo de comentario"
            // header.tituloDer.text = "Descripción"
            return header.contentView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return Globals.UOTab2Involucrados.count
        case 2:
            return 1 + Globals.UOTab2AspectosPrevios.count
        case 3:
            return 1 + Globals.UOTab2EtapaDesviacion.count
        case 4:
            return 1 + Globals.UOTab2Comentarios.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda2Texto1View
            celda.view.layer.borderWidth = 0.5
            celda.view.layer.borderColor = UIColor.gray.cgColor
            switch indexPath.row {
            case 0:
                celda.texto1.text = "Tarea Observada"
                celda.texto2.text = Globals.UOTab2ObsDetalle.Observacion
            case 1:
                celda.texto1.text = "Actividad relacionada"
                celda.texto2.text = Utils.searchMaestroDescripcion("ACTR", Globals.UOTab2ObsDetalle.CodActiRel ?? "")
            case 2:
                celda.texto1.text = "Codigo PET"
                celda.texto2.text = Globals.UOTab2ObsDetalle.Accion
            case 3:
                celda.texto1.text = "HHA relacionada"
                celda.texto2.text = Utils.searchMaestroDescripcion("HHAR", Globals.UOTab2ObsDetalle.CodHHA ?? "")
            case 4:
                celda.texto1.text = "Estado"
                celda.texto2.text = Utils.searchMaestroDescripcion("ESOB", Globals.UOTab2ObsDetalle.CodEstado ?? "")
            case 5:
                celda.texto1.text = "Error"
                celda.texto2.text = Utils.searchMaestroDescripcion("EROB", Globals.UOTab2ObsDetalle.CodError ?? "")
            default:
                break
            }
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda2Texto
            celda.texto1.text = Globals.UOTab2Involucrados[indexPath.row].Nombres ?? "-"
            celda.texto2.text = Globals.UOTab2Involucrados[indexPath.row].Cargo ?? "-"
            return celda
        case 2:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = "Descripción"
                celda.texto2.text = "Calificación"
                return celda
            } else {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! Celda1Texto
                celda.texto.text = Globals.UOTab2AspectosPrevios[indexPath.row - 1]
                return celda
            }
        case 3:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto
                celda.texto1.text = "Etapa de la Tarea (según PET)"
                celda.texto2.text = "Desviación Observada"
                return celda
            } else {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda7") as! Celda2Texto
                celda.texto1.text = Globals.UOTab2EtapaDesviacion[indexPath.row - 1][0]
                celda.texto2.text = Globals.UOTab2EtapaDesviacion[indexPath.row - 1][1]
                return celda
            }
        case 4:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto
                celda.texto1.text = "Tipo de comentario"
                celda.texto2.text = "Descripción"
                return celda
            } else {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda8") as! Celda2Texto
                celda.texto1.text = Globals.UOTab2Comentarios[indexPath.row - 1][0]
                celda.texto2.text = Globals.UOTab2Comentarios[indexPath.row - 1][1]
                return celda
            }
        default:
            return UITableViewCell()
        }
    }
}
