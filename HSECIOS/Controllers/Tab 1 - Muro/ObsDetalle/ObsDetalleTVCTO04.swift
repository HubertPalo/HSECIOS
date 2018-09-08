import UIKit

class ObsDetalleTVCTO04: UITableViewController {
    // Interaccion de Seguridad
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
        celda.texto.textAlignment = .center
        switch section {
        case 0:
            celda.texto.text = "Detalle observación"
        case 1:
            celda.texto.text = "Líder de equipo de inspección"
        case 2:
            celda.texto.text = "Personas que atendieron"
        case 3:
            celda.texto.text = "Metodología de gestión de riesgos aplicada antes del inicio de la tarea o actividad"
        case 4:
            celda.texto.text = "Actividad de alto riesgo identificada"
        case 5:
            celda.texto.text = "Clasificación de la observación"
        case 6:
            celda.texto.text = "Comportamiento de riesgo/Condiciones inseguras identificadas"
        default:
            break
        }
        return celda.contentView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return Globals.UOTab2Involucrados.count > 0 ? 1 : 0
        case 2:
            return Globals.UOTab2Involucrados.count > 1 ? Globals.UOTab2Involucrados.count - 1 : 0
        case 3:
            return 1 + Globals.UOTab2Metodologia.count
        case 4:
            return 1 + Globals.UOTab2ActividadAltoRiesgo.count + Globals.UOTab2ActividadAltoRiesgoExt.count
        case 5:
            return 1 + Globals.UOTab2Clasificacion.count
        case 6:
            return 1 + Globals.UOTab2ComportamientoCondicion.count + Globals.UOTab2ComportamientoCondicionExt.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto
            switch indexPath.row {
            case 0:
                celda.texto1.text = "Actividad o Tarea Observada"
                celda.texto2.text = Globals.UOTab2ObsDetalle.Observacion ?? ""
            case 1:
                celda.texto1.text = "Empresa"
                celda.texto2.text = Globals.UOTab2ObsDetalle.CodError ?? ""
            case 2:
                celda.texto1.text = "Equipo involucrado"
                celda.texto2.text = Globals.UOTab2ObsDetalle.CodHHA ?? ""
            default:
                break
            }
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda2Texto
            celda.texto1.text = Globals.UOTab2Involucrados[0].Nombres ?? ""
            celda.texto2.text = Globals.UOTab2Involucrados[0].Cargo ?? ""
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda2Texto
            celda.texto1.text = Globals.UOTab2Involucrados[indexPath.row + 1].Nombres ?? ""
            celda.texto2.text = Globals.UOTab2Involucrados[indexPath.row + 1].Cargo ?? ""
            return celda
        case 3:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = "Descripción"
                celda.texto2.text = "Opciones"
                return celda
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto
            celda.texto.text = Utils.searchMaestroStatic("GESTIONRIESGO", Globals.UOTab2Metodologia[indexPath.row - 1])
            return celda
        case 4:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = "Descripción"
                celda.texto2.text = "Opciones"
                return celda
            }
            if indexPath.row > Globals.UOTab2ActividadAltoRiesgo.count {
                let newIndice = indexPath.row - Globals.UOTab2ActividadAltoRiesgo.count - 1
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! Celda2Texto1View
                celda.view.layer.borderColor = UIColor.gray.cgColor
                celda.view.layer.borderWidth = 0.5
                celda.texto1.text = Globals.UOTab2ActividadAltoRiesgoExt[newIndice][0]
                celda.texto2.text = Globals.UOTab2ActividadAltoRiesgoExt[newIndice][1]
                return celda
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto
            celda.texto.text = Utils.searchMaestroDescripcion("HHAR", Globals.UOTab2ActividadAltoRiesgo[indexPath.row - 1])
            return celda
        case 5:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = "Descripción"
                celda.texto2.text = "Opciones"
                return celda
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto
            celda.texto.text = Utils.searchMaestroStatic("CLASIFICACIONOBS", Globals.UOTab2Clasificacion[indexPath.row - 1])
            return celda
        case 6:
            if indexPath.row == 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = "Descripción"
                celda.texto2.text = "Opciones"
                return celda
            }
            if indexPath.row > Globals.UOTab2ComportamientoCondicion.count {
                let newIndice = indexPath.row - Globals.UOTab2ComportamientoCondicion.count - 1
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! Celda2Texto1View
                celda.view.layer.borderColor = UIColor.gray.cgColor
                celda.view.layer.borderWidth = 0.5
                celda.texto1.text = Globals.UOTab2ComportamientoCondicionExt[newIndice][0]
                celda.texto2.text = Globals.UOTab2ComportamientoCondicionExt[newIndice][1]
                return celda
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto
            celda.texto.text = Utils.searchMaestroStatic("CONDICIONCOMPORTAMIENTO", Globals.UOTab2ComportamientoCondicion[indexPath.row - 1])
            return celda
        default:
            return UITableViewCell()
        }
    }
    
}
