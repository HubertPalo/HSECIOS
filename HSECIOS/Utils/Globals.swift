import UIKit

class Globals {
    
    // Seccion Observacion
    static var UOCodigo = ""
    static var UOModo = ""
    
    static var GaleriaModo = ""
    static var GaleriaVCViewContainerIsHidden = false
    static var GaleriaVCGaleriaContainerIsHidden = false
    
    static var UOTab1ObsGD = ObservacionGD()
    static var UOTab1CodUbicacion = ""
    static var UOTab1CodSubUbicacion = ""
    static var UOTab1CodUbiEspecifica = ""
    static var UOTab1Fecha = Date()
    
    static var UOTab2ObsDetalle = ObsDetalle()
    
    static var UOTab3Multimedia = [FotoVideo]()
    static var UOTab3Documentos = [DocumentoGeneral]()
    static var UOTab3Nombres: Set<String> = Set<String>()
    static var UOTab3CorrelativosABorrar: Set<Int> = Set<Int>()
    
    static var UOTab4Planes: [PlanAccionDetalle] = []
    static var UOTab4CorrelativosABorrar: Set<Int> = Set<Int>()
    
    static func UOloadModo(_ modo: String, _ codigo: String) {
        UOModo = modo
        UOCodigo = codigo
        GaleriaModo = modo
        switch modo {
        case "ADD":
            // Tab1
            UOTab1ObsGD.CodTipo = "TO01"
            UOTab1ObsGD.CodObservadoPor = Utils.userData.CodPersona
            UOTab1ObsGD.ObservadoPor = Utils.userData.Nombres
            UOTab1ObsGD.CodUbicacion = ""
            UOTab1CodUbicacion = ""
            UOTab1CodSubUbicacion = ""
            UOTab1CodUbiEspecifica = ""
            UOTab1Fecha = Date()
            (Tabs.forAddObs[0] as! UpsertObsPVCTab1).tableView.reloadData()
            // Tab2
            UOTab2ObsDetalle.CodTipo = UOTab1ObsGD.CodTipo ?? "TO01"
            UOTab2ObsDetalle.Observacion = nil
            UOTab2ObsDetalle.Accion = nil
            UOTab2ObsDetalle.CodActiRel = nil
            UOTab2ObsDetalle.CodHHA = nil
            UOTab2ObsDetalle.CodSubEstandar = nil
            UOTab2ObsDetalle.CodEstado = nil
            UOTab2ObsDetalle.CodError = nil
            (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tableView.reloadData()
            // Tab3
            UOTab3Multimedia = []
            UOTab3Documentos = []
            UOTab3Nombres.removeAll()
            UOTab3CorrelativosABorrar.removeAll()
            GaleriaVCViewContainerIsHidden = true
            GaleriaVCGaleriaContainerIsHidden = false
            (Tabs.forAddObs[2] as! UpsertObsPVCTab3).galeriaVC.galeria.tableView.reloadData()// self.galeria.tableView.reloadData()
        case "PUT":
            Rest.getDataGeneral(Routes.forObservaciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
                UOTab1ObsGD = Dict.dataToUnit(data!)!
                UOTab1Fecha = Utils.str2date(UOTab1ObsGD.Fecha ?? "") ?? Date()
                if UOTab1ObsGD.CodUbicacion != "" {
                    let splits = (UOTab1ObsGD.CodUbicacion ?? "").components(separatedBy: ".")
                    UOTab1CodUbicacion = splits[0]
                    if splits.count > 1 {
                        UOTab1CodSubUbicacion = splits[1]
                    }
                    if splits.count > 2 {
                        UOTab1CodUbiEspecifica = splits[2]
                    }
                } else {
                    UOTab1CodUbicacion = ""
                    UOTab1CodSubUbicacion = ""
                    UOTab1CodUbiEspecifica = ""
                }
                (Tabs.forAddObs[0] as! UpsertObsPVCTab1).tableView.reloadData()
            }, error: nil)
            Rest.getDataGeneral(Routes.forObsDetalle(codigo), true, success: {(resultValue:Any?,data:Data?) in
                UOTab2ObsDetalle = Dict.dataToUnit(data!)!
                (Tabs.forAddObs[1] as! UpsertObsPVCTab2).tableView.reloadData()
            }, error: nil)
            Rest.getDataGeneral(Routes.forMultimedia(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                GaleriaVCGaleriaContainerIsHidden = arrayMultimedia.Count == 0
                GaleriaVCViewContainerIsHidden = arrayMultimedia.Count != 0
                var arrayFotoVideo = [FotoVideo]()
                var arrayDocumentos = [DocumentoGeneral]()
                for multimedia in arrayMultimedia.Data {
                    switch multimedia.TipoArchivo ?? "" {
                    case "TP01":
                        arrayFotoVideo.append(multimedia.toFotoVideo())
                        Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)")
                        break
                    case "TP02":
                        arrayFotoVideo.append(multimedia.toFotoVideo())
                        Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)")
                        break
                    default:
                        arrayDocumentos.append(multimedia.toDocumentoGeneral())
                        break
                    }
                }
                UOTab3Multimedia = arrayFotoVideo
                UOTab3Documentos = arrayDocumentos
                (Tabs.forAddObs[2] as! UpsertObsPVCTab3).galeriaVC.galeria.tableView.reloadData()
                // (Tabs.forAddObs[2] as! UpsertObsPVCTab3).galeriaVC.loadModo("PUT")
            }, error: nil)
            Rest.getDataGeneral(Routes.forObsPlanAccion(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
                UOTab4Planes = arrayPlanes.Data
                (Tabs.forAddObs[3] as! UpsertObsPVCTab4).tableView.reloadData()
            }, error: nil)
            break
        default:
            break
        }
    }
    
    static func UOTab1GetData() -> (success: Bool, data: String) {
        // Establecer valores de Fecha y Ubicacion
        UOTab1ObsGD.Fecha = Utils.date2str(UOTab1Fecha, "YYYY-MM-dd")
        var ubicacion = ""
        if UOTab1CodUbicacion != "" {
            ubicacion.append(UOTab1CodUbicacion)
        }
        if UOTab1CodSubUbicacion != "" {
            ubicacion.append(".\(UOTab1CodSubUbicacion)")
        }
        if UOTab1CodUbiEspecifica != "" {
            ubicacion.append(".\(UOTab1CodUbiEspecifica)")
        }
        UOTab1ObsGD.CodUbicacion = ubicacion
        
        // Limpar de data no necesaria
        let showData = UOTab1ObsGD
        showData.CodObservacion = showData.CodObservacion ?? ""
        showData.Lugar = showData.Lugar ?? ""
        
        // Verificar que estén los datos mínimos
        var nombreVariable = ""
        if UOTab1ObsGD.CodAreaHSEC == nil || UOTab1ObsGD.CodAreaHSEC == "" {
            nombreVariable = "Area HSEC"
        }
        if UOTab1ObsGD.CodNivelRiesgo == nil || UOTab1ObsGD.CodNivelRiesgo == "" {
            nombreVariable = "Nivel de riesgo"
        }
        if UOTab1ObsGD.CodUbicacion == nil || UOTab1ObsGD.CodUbicacion == "" {
            nombreVariable = "Ubicación"
        }
        
        // Enviar los datos, o el nombre de la variable que falta
        if nombreVariable == "" {
            return (true, String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!)
        } else {
            return (false, nombreVariable)
        }
    }
    
    static func UOTab2GetData() -> (success: Bool, data: String) {
        // Limpar de data no necesaria
        let showData = Globals.UOTab2ObsDetalle
        showData.CodObservacion = showData.CodObservacion ?? ""
        
        if showData.CodTipo == "TO01" {
            showData.CodEstado = showData.CodEstado ?? ""
            showData.CodError = showData.CodError ?? ""
        } else { // showData.CodTipo == "TO02"
            showData.CodEstado = ""
            showData.CodError = ""
        }
        
        // Verificar que estén los datos mínimos
        var nombreVariable = ""
        if showData.Observacion == nil || showData.Observacion == "" {
            nombreVariable = "Observación"
        }
        if showData.Accion == nil || showData.Accion == "" {
            nombreVariable = "Acción"
        }
        if showData.CodActiRel == nil || showData.CodActiRel == "" {
            nombreVariable = "Actividad Relacionada"
        }
        if showData.CodHHA == nil || showData.CodHHA == "" {
            nombreVariable = "HHA Relacionada"
        }
        if showData.CodSubEstandar == nil || showData.CodSubEstandar == "" {
            nombreVariable = UOTab1ObsGD.CodTipo == "TO01" ? "Acto SubEstandar" : "Condición SubEstandar"
        }
        if UOTab1ObsGD.CodTipo == "TO01" {
            if showData.CodEstado == nil || showData.CodEstado == "" {
                nombreVariable = "Estado"
            }
            if showData.CodError == nil || showData.CodError == "" {
                nombreVariable = "Error"
            }
        }
        
        // Enviar los datos, o el nombre de la variable que falta
        if nombreVariable == "" {
            return (true, String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!)
        } else {
            return (false, nombreVariable)
        }
    }
    
    static func UOTab3GetData() -> (data: [Data], fileNames: [String], mimeTypes: [String]) {
        var arrayData = [Data]()
        var arrayFileNames = [String]()
        var arrayMimeTypes = [String]()
        for i in 0..<Globals.UOTab3Multimedia.count {
            let unit = Globals.UOTab3Multimedia[i]
            if unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
        for i in 0..<Globals.UOTab3Documentos.count {
            let unit = Globals.UOTab3Documentos[i]
            if unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
        return (arrayData, arrayFileNames, arrayMimeTypes)
    }
    
    static func UOTab4GetData() -> (toAdd: String, toDel: String) {
        var newPlanes = Globals.UOTab4Planes
        for i in 0..<newPlanes.count {
            newPlanes[i].CodAccion = "\(i*(-1))"
            newPlanes[i].NroDocReferencia = newPlanes[i].NroDocReferencia ?? ""
            newPlanes[i].CodReferencia = newPlanes[i].CodReferencia ?? ""
            newPlanes[i].CodResponsable = newPlanes[i].CodResponsables ?? ""
            newPlanes[i].CodTablaRef = newPlanes[i].CodTabla ?? ""
            newPlanes[i].NroAccionOrigen = newPlanes[i].NroAccionOrigen ?? ""
        }
        return (String.init(data: Dict.unitToData(newPlanes)!, encoding: .utf8)!, "")
    }
    // Seccion Observacion
    
    
    static func loadGlobals() {
        Utils.maestroStatic1["REFERENCIAPLAN"] = ["01", "02", "03", "04", "05", "06", "07", "08", "09"]
        Utils.maestroStatic2["REFERENCIAPLAN"] = ["Observaciones", "Inspecciones", "Incidentes", "IPERC", "Auditorias", "Simulacros", "Reuniones", "Comites", "Capacitaciones"]
        Utils.maestroStatic1["ESTADOPLAN"] = ["01", "02", "03", "04", "05"]
        Utils.maestroStatic2["ESTADOPLAN"] = ["Pendiente", "Atendido", "En Proceso", "Observado", "Cerrado"]
        Utils.maestroStatic1["TABLAS"] = ["TCOM", "THIG", "TINC", "TINS", "TIPE", "TOBS", "TREU", "TSIM", "TYOS", "TCAP", "TDETAINSP", "TDIPEAFEC", "TEAU", "TEIN", "THALL", "TINVEAFEC", "TSEC", "TSIM", "TTES", "OTROS"]
        Utils.maestroStatic2["TABLAS"] = ["Comites", "Higiene", "Incidentes", "Inspecciones", "IPERC", "Observaciones", "Reuniones", "Simulacro", "Yo Aseguro", "ActaAsistencia", "DetalleInspeccion", "DiasPerdidosAfectado", "EquipoAuditor", "EquipoInvestigacion", "Hallazgos", "InvestigaAfectado", "SecuenciaEvento", "Simulacro", "TestigoInvolucrado", "Otros"]
        
        Utils.maestroStatic1["TIPOFACILITO"] = ["A", "C"]
        Utils.maestroStatic2["TIPOFACILITO"] = ["Acción", "Condición"]
        Utils.maestroStatic1["ESTADOFACILITO"] = ["A", "O", "P", "S"]
        Utils.maestroStatic2["ESTADOFACILITO"] = ["Atendido", "Observado", "Pendiente", "Espera"]
        
        Utils.maestroStatic1["NIVELRIESGO"] = ["BA", "ME", "AL"]
        Utils.maestroStatic2["NIVELRIESGO"] = ["Baja", "Media", "Alta"]
        Utils.maestroStatic1["ACTOSUBESTANDAR"] = ["0001","0002","0003","0004","0005","0006","0007","0008","0009","0010","0011","0012","0013","0014","0015","0016","0017","0018","0019","0020","0021","0022","0023","0024","0025"]
        Utils.maestroStatic2["ACTOSUBESTANDAR"] = ["Operar equipos sin autorización","Operar  equipo a velocidad inadecuada","No Avisar","No Advertir","No Asegurar","Desactivar Dispositivos de Seguridad","Usar Equipos y Herramientas Defectuosos","Uso inadecuado o no uso de EPP","Cargar Incorrectamente","Ubicación Incorrecta","Levantar Incorrectamente","Posición Inadecuada para el Trabajo o la Tarea","Dar mantenimiento a equipo en operación","Jugar en el trabajo","Usar equipo inadecuadamente","Trabajo bajo la Influencia del Alcohol y/u otras Drogas","Maniobra incorrecta","Uso inapropiado de herramientas","Evaluación de riesgos deficiente por parte del personal","Control inadecuado de energía (bloqueo/etiquetado)","Instrumentos mal interpretados / mal leídos","Hechos de violencia","Exponerse a la línea de fuego","No uso de los 3 puntos de apoyo","Intento por realizar tareas múltiples en forma simultánea"]
        Utils.maestroStatic1["CONDICIONSUBESTANDAR"] = ["0027","0028","0029","0030","0031","0032","0033","0034","0035","0036","0037","0038","0039","0040","0041","0042","0043","0044","0045","0046","0047"]
        Utils.maestroStatic2["CONDICIONSUBESTANDAR"] = ["Protección inadecuada, defectuosa o inexistente","Paredes, techos, etc. inestables","Caminos, pisos, superficies inadecuadas","Equipo de protección personal inadecuado","Herramientas, Equipos, Materiales Defectuosos o sin calibración","Congestión o Acción Restringida","Alarmas, Sirenas, Sistemas de Advertencia Inadecuado  o defectuosos","Peligros de Incendio y Explosión","Limpieza y Orden deficientes","Exceso de Ruido","Exceso de Radiación","Temperaturas Extremas","Peligros ergonómicos","Excesiva o inadecuada iluminación","Ventilación Inadecuada","Condiciones Ambientales Peligrosas","Dispositivos de seguridad inadecuados / defectuosos","Sistemas y Equipos energizados","Productos químicos peligrosos","Altura desprotegida","Derrame"]
    }
}
