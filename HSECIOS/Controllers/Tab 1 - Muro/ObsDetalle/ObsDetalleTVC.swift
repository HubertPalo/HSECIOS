import UIKit

class ObsDetalleTVC: UITableViewController {
    
    // var observacion: MuroElement = MuroElement()
    var obsDetalle: ObsDetalle = ObsDetalle()
    var obsSubDetalle: [ObsSubDetalle] = []
    var obsSubDetalleDict: [String:[ObsSubDetalle]] = [:]
    var obsSubDetallePETO: [ObsSubDetalle] = []
    var obsSubDetalleOBSR: [ObsSubDetalle] = []
    var obsSubDetalleOBSC: [ObsSubDetalle] = []
    var obsSubDetalleOBCC: [ObsSubDetalle] = []
    var obsSubDetalleHHA: [ObsSubDetalle] = []
    
    var obsInvolucrados: [Persona] = []
    
    var valuesForObsDetalle = [["Actividad o Tarea Observada", ""], ["Empresa", ""], ["Equipo involucrado", ""]]
    var valuesForDetalleTO01TO02 = [["Comportamiento Sub-estándar observado", ""], ["Acción inmediata (Corrección)", ""], ["Actividad relacionada",""], ["HHA relacionada", ""], ["Acto Sub-estándar", ""], ["Estado", ""], ["Error", ""]]
    var valuesForDetalleTO03TO04 = [["Detalle de los comportamientos/condiciones no seguros:", ""], ["Acciones inmediatas (si es aplicable)", ""]]
    
    var valuesForCeldaComun: [[String]] = []
    var celdaComunParte1Length = 1 // Indice donde empieza la 2da parte
    var valuesForComentarios: [[String]] = []
    var valuesForDetalle: [[String]] = [["Actividad o Tarea Observada", ""], ["Empresa", ""], ["Equipo involucrado", ""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadValues(){
        valuesForCeldaComun = []
        valuesForComentarios = []
        obsSubDetalleDict = [:]
        celdaComunParte1Length = 1
        for i in 0..<obsSubDetalle.count {
            let label = obsSubDetalle[i].CodTipo ?? ""
            if obsSubDetalleDict[label] == nil {
                obsSubDetalleDict[label] = []
            }
            obsSubDetalleDict[label]?.append(obsSubDetalle[i])
        }
        for i in 0..<valuesForDetalle.count {
            valuesForDetalle[i][1] = ""
        }
        
        switch Globals.UOTab1ObsGD.CodTipo ?? "" {
        case "TO03":
            if obsDetalle.Observacion != "" {
                valuesForCeldaComun.append(["Tarea Observada", obsDetalle.Observacion ?? ""])
            }
            if obsDetalle.CodActiRel != "" {
                valuesForCeldaComun.append(["Actividad relacionada", obsDetalle.CodActiRel ?? ""])
            }
            if obsDetalle.Accion != "" {
                valuesForCeldaComun.append(["Código PET", obsDetalle.Accion ?? ""])
            }
            if obsDetalle.CodHHA != "" {
                valuesForCeldaComun.append(["HHA relacionada", obsDetalle.CodHHA ?? ""])
            }
            if obsDetalle.CodEstado != "" {
                valuesForCeldaComun.append(["Estado", obsDetalle.CodEstado ?? ""])
            }
            if obsDetalle.CodError != "" {
                valuesForCeldaComun.append(["Error", obsDetalle.CodError ?? ""])
            }
            let splits = (obsDetalle.CodSubEstandar ?? "").components(separatedBy: ";")
            if splits[0] != "" {
                valuesForComentarios.append(["Se Cumple el PET", String(splits[0])])
            }
            if splits.count > 1 && splits[1] != "" {
                valuesForComentarios.append(["El trabajador requiere feedback", String(splits[1])])
            }
            if splits.count > 2 && splits[2] != "" {
                valuesForComentarios.append(["El procedimiento debe modificarse", String(splits[2])])
            }
            if splits.count > 3 && splits[3] != "" {
                valuesForComentarios.append(["Reconocimientos/Oportunidades", String(splits[3])])
            }
        case "TO04":
            valuesForDetalle[0][1] = obsDetalle.Observacion ?? ""
            valuesForDetalle[1][1] = obsDetalle.CodError ?? ""
            valuesForDetalle[2][1] = obsDetalle.CodHHA ?? ""

            // OBSR
            // HHA
            if true {
                celdaComunParte1Length = 2
                valuesForCeldaComun.append(["Otras actividades de alto riesgo", obsDetalle.CodObservacion ?? ""])
            }
            valuesForCeldaComun.append(["Interacción de seguridad", obsDetalle.CodSubEstandar ?? ""])
            // OBSC
            // OBCC
            if true {
                valuesForCeldaComun.append(["Otro comportamiento / condición", obsDetalle.CodTipo ?? ""])
            }
            valuesForCeldaComun.append(["Detalle de los comportamientos / condiciones no seguros", obsDetalle.CodActiRel ?? ""])
            valuesForCeldaComun.append(["Acciones inmediatas (si es aplicable)", obsDetalle.Accion ?? ""])
        default:
            if obsDetalle.Observacion != "" {
                valuesForCeldaComun.append(["Comportamiento Sub-estándar observado", obsDetalle.Observacion ?? ""])
            }
            if obsDetalle.Accion != "" {
                valuesForCeldaComun.append(["Acción inmediata (Corrección)", obsDetalle.Accion ?? ""])
            }
            if obsDetalle.CodActiRel != "" {
                valuesForCeldaComun.append(["Actividad relacionada", obsDetalle.CodActiRel ?? ""])
            }
            if obsDetalle.CodHHA != "" {
                valuesForCeldaComun.append(["HHA relacionada", obsDetalle.CodHHA ?? ""])
            }
            if obsDetalle.CodSubEstandar != "" {
                valuesForCeldaComun.append(["Acto Sub-estándar", obsDetalle.CodSubEstandar ?? ""])
            }
            if obsDetalle.CodEstado != "" {
                valuesForCeldaComun.append(["Estado", obsDetalle.CodEstado ?? ""])
            }
            if obsDetalle.CodError != "" {
                valuesForCeldaComun.append(["Error", obsDetalle.CodError ?? ""])
            }
        }
        
        self.valuesForObsDetalle[0][1] = obsDetalle.Observacion ?? ""
        self.valuesForObsDetalle[1][1] = obsDetalle.CodError ?? ""
        self.valuesForObsDetalle[2][1] = obsDetalle.CodHHA ?? ""
        
        
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if Globals.UOTab1ObsGD.CodTipo == "TO03" {
            return 5
        } else if Globals.UOTab1ObsGD.CodTipo == "TO04" {
            return 7
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if Globals.UOTab1ObsGD.CodTipo == "TO03" {
            switch section {
            case 0:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerSoloTitulo") as! ObsDetalleTVCellHeaderSoloTitulo
                header.titulo.text = "Detalle observación"
                return header.contentView
            case 1:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerSoloTitulo") as! ObsDetalleTVCellHeaderSoloTitulo
                header.titulo.text = "Personas observadas"
                return header.contentView
            case 2:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
                header.titulo.text = "Aspectos Previos"
                header.tituloIzq.text = "Descripción"
                header.tituloDer.text = "Calificación"
                //header.tituloIzqWidth.constant = Utils.widthDevice * 0.8
                return header.contentView
            case 3:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla40") as! HeaderTituloYTabla40
                header.titulo.text = "Etapas / Desviación"
                header.tituloIzq.text = "Etapa de la tarea (según PET)"
                header.tituloDer.text = "Desviación Observada"
                return header.contentView
            case 4:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla40") as! HeaderTituloYTabla40
                header.titulo.text = "Comentarios"
                header.tituloIzq.text = "Tipo de comentario"
                header.tituloDer.text = "Descripción"
                return header.contentView
            default:
                return nil
            }
        } else if Globals.UOTab1ObsGD.CodTipo == "TO04" {
            switch section {
            case 0:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerSoloTitulo") as! ObsDetalleTVCellHeaderSoloTitulo
                header.titulo.text = "Detalle observación"
                return header.contentView
            case 1:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerSoloTitulo") as! ObsDetalleTVCellHeaderSoloTitulo
                header.titulo.text = "Líder de equipo de inspección"
                return header.contentView
            case 2:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerSoloTitulo") as! ObsDetalleTVCellHeaderSoloTitulo
                header.titulo.text = "Personas que atendieron"
                return header.contentView
            case 3:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
                header.titulo.text = "Metodología de gestión de riesgos aplicada antes del inicio de la tarea o actividad"
                header.tituloIzq.text = "Descripción"
                header.tituloDer.text = "Opciones"
                return header.contentView
            case 4:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
                header.titulo.text = "Actividad de alto riesgo identificada"
                header.tituloIzq.text = "Descripción"
                header.tituloDer.text = "Opciones"
                return header.contentView
            case 5:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
                header.titulo.text = "Clasificación de la observación"
                header.tituloIzq.text = "Descripción"
                header.tituloDer.text = "Opciones"
                return header.contentView
            case 6:
                let header = tableView.dequeueReusableCell(withIdentifier: "headerTituloYTabla80") as! HeaderTituloYTabla80
                header.titulo.text = "Comportamientos de riesgo / Condiciones inseguras identificadas"
                header.tituloIzq.text = "Descripción"
                header.tituloDer.text = "Opciones"
                return header.contentView
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    /*override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return UITableViewAutomaticDimension
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Globals.UOTab1ObsGD.CodTipo == "TO03" {
            switch section {
            case 0:
                return valuesForCeldaComun.count
            case 1:
                return obsInvolucrados.count
            case 2:
                return obsSubDetalleDict["PREA"]?.count ?? 0
            case 3:
                return obsSubDetalleDict["PETO"]?.count ?? 0
            case 4:
                return valuesForComentarios.count
            default:
                return 0
            }
        } else if Globals.UOTab1ObsGD.CodTipo == "TO04" {
            switch section {
            case 0: // Detalle
                return 3
            case 1: // Lider Equipo Inspeccion
                if obsInvolucrados.count > 0 {
                    return 1
                }
                return 0
            case 2: // Equipo Inspeccion
                if obsInvolucrados.count > 1 {
                    return obsInvolucrados.count - 1
                }
                return 0
            case 3: // OBSR
                return obsSubDetalleDict["OBSR"]?.count ?? 0
            case 4: // HHA
                return (obsSubDetalleDict["HHA"]?.count ?? 0) + celdaComunParte1Length
            case 5: // OBSC
                return obsSubDetalleDict["OBSC"]?.count ?? 0
            case 6: // OBCC
                return (obsSubDetalleDict["OBCC"]?.count ?? 0) + valuesForCeldaComun.count - celdaComunParte1Length
            default:
                return 0
            }
        } else {
            return valuesForCeldaComun.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Globals.UOTab1ObsGD.CodTipo == "TO03" {
            switch indexPath.section {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! ObsDetalleTVCellComun
                celda.bordeView.layer.borderColor = UIColor.lightGray.cgColor
                celda.bordeView.layer.borderWidth = 0.25
                celda.valorIzq.text = valuesForCeldaComun[indexPath.row][0]
                celda.valorDer.text = valuesForCeldaComun[indexPath.row][1]
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPersona") as! ObsDetalleTVCellPersona
                let unit = obsInvolucrados[indexPath.row]
                celda.nombreCompleto.text = unit.Nombres
                celda.cargo.text = unit.Cargo
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel80Image20") as! ObsDetalleTVCellLabel80Image20
                let unit = obsSubDetalleDict["PREA"]![indexPath.row]
                celda.textoIzq.text = unit.Descripcion
                celda.imagenDer.image = UIImage(named: "user")
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel40Label60") as! ObsDetalleTVCellLabel40Label60
                let unit = obsSubDetalleDict["PETO"]![indexPath.row]// obsInvolucrados[indexPath.row]
                celda.textoIzq.text = unit.Descripcion
                celda.textoDer.text = unit.Descripcion
                return celda
            case 4:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel40Label60") as! ObsDetalleTVCellLabel40Label60
                celda.textoIzq.text = valuesForComentarios[indexPath.row][0]
                celda.textoDer.text = valuesForComentarios[indexPath.row][1]
                return celda
            default:
                return UITableViewCell()
            }
        } else if Globals.UOTab1ObsGD.CodTipo == "TO04" {
            switch indexPath.section {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaDetalle") as! ObsDetalleTVCellDetalle
                celda.detalleIzq.text = valuesForDetalle[indexPath.row][0]
                celda.detalleDer.text = valuesForDetalle[indexPath.row][1]
                return celda
            case 1:
                if obsInvolucrados.count > 0 {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPersona") as! ObsDetalleTVCellPersona
                    celda.nombreCompleto.text = obsInvolucrados[0].Nombres
                    celda.cargo.text = obsInvolucrados[0].Cargo
                    return celda
                }
                return UITableViewCell()
            case 2:
                if obsInvolucrados.count > 1 {
                    let unit = obsInvolucrados[indexPath.row + 1]
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPersona") as! ObsDetalleTVCellPersona
                    celda.nombreCompleto.text = unit.Nombres
                    celda.cargo.text = unit.Cargo
                    return celda
                }
                return UITableViewCell()
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel80Image20") as! ObsDetalleTVCellLabel80Image20
                let unit = obsSubDetalleDict["OBSR"]?[indexPath.row] ?? ObsSubDetalle()
                celda.textoIzq.text = unit.Descripcion
                celda.imagenDer.image = UIImage(named: "user")
                return celda
            case 4:
                if indexPath.row < (obsSubDetalleDict["HHA"]?.count ?? 0) {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel80Image20") as! ObsDetalleTVCellLabel80Image20
                    let unit = obsSubDetalleDict["HHA"]?[indexPath.row] ?? ObsSubDetalle()
                    celda.textoIzq.text = unit.Descripcion
                    celda.imagenDer.image = UIImage(named: "user")
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! ObsDetalleTVCellComun
                    celda.bordeView.layer.borderColor = UIColor.lightGray.cgColor
                    celda.bordeView.layer.borderWidth = 0.25
                    celda.valorIzq.text = valuesForCeldaComun[indexPath.row - (obsSubDetalleDict["HHA"]?.count ?? 0)][0]
                    celda.valorDer.text = valuesForCeldaComun[indexPath.row - (obsSubDetalleDict["HHA"]?.count ?? 0)][1]
                    return celda
                }
            case 5:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel80Image20") as! ObsDetalleTVCellLabel80Image20
                let unit = obsSubDetalleDict["OBSC"]?[indexPath.row] ?? ObsSubDetalle()
                celda.textoIzq.text = unit.Descripcion
                celda.imagenDer.image = UIImage(named: "user")
                return celda
            case 6:
                if indexPath.row < (obsSubDetalleDict["OBCC"]?.count ?? 0) {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaLabel80Image20") as! ObsDetalleTVCellLabel80Image20
                    let unit = obsSubDetalleDict["OBCC"]?[indexPath.row] ?? ObsSubDetalle()
                    celda.textoIzq.text = unit.Descripcion
                    celda.imagenDer.image = UIImage(named: "user")
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! ObsDetalleTVCellComun
                    celda.bordeView.layer.borderColor = UIColor.lightGray.cgColor
                    celda.bordeView.layer.borderWidth = 0.25
                    celda.valorIzq.text = valuesForCeldaComun[indexPath.row - (obsSubDetalleDict["OBCC"]?.count ?? 0) + celdaComunParte1Length][0]
                    celda.valorDer.text = valuesForCeldaComun[indexPath.row - (obsSubDetalleDict["OBCC"]?.count ?? 0) + celdaComunParte1Length][1]
                    return celda
                }
            default:
                return UITableViewCell()
            }
        } else {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! ObsDetalleTVCellComun
            celda.bordeView.layer.borderColor = UIColor.gray.cgColor
            celda.bordeView.layer.borderWidth = 0.25
            celda.valorIzq.text = valuesForCeldaComun[indexPath.row][0]
            celda.valorDer.text = valuesForCeldaComun[indexPath.row][1]
            return celda
        }
    }
    
}

class ObsDetalleTVCellDetalle: UITableViewCell {
    @IBOutlet weak var detalleIzq: UILabel!
    @IBOutlet weak var detalleDer: UILabel!
}

class ObsDetalleTVCellPersona: UITableViewCell {
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var cargo: UILabel!
}

class ObsDetalleTVCellLabel40Label60: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class ObsDetalleTVCellLabel80Image20: UITableViewCell {
    
    @IBOutlet weak var textoIzq: UILabel!
    
    @IBOutlet weak var imagenDer: UIImageView!
}

class ObsDetalleTVCellComun: UITableViewCell {
    @IBOutlet weak var valorIzq: UILabel!
    @IBOutlet weak var valorDer: UILabel!
    @IBOutlet weak var bordeView: UIView!
}

class ObsDetalleTVCellHeaderSoloTitulo: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    
}

class HeaderTituloYTabla80: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tituloIzq: UILabel!
    @IBOutlet weak var tituloDer: UILabel!
}

class HeaderTituloYTabla40: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tituloIzq: UILabel!
    @IBOutlet weak var tituloDer: UILabel!
}
