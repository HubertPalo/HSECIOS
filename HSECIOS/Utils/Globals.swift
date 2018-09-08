import UIKit

class Globals {
    
    // GET Observacion
    // static var GOData = [["Codigo", "-"], ["Area", "-"], ["Nivel de riesgo", "-"], ["Observado Por", "-"], ["Fecha", "-"], ["Hora", "-"], ["Gerencia", "-"], ["Superintendencia", "-"]]
    
    // GET Observacion
    static var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    static var splitExpositor = [String]()
    
    static var isScaning = true
    
    
    // Variables Galeria
    static var GaleriaModo = ""
    static var GaleriaVCViewContainerIsHidden = false
    static var GaleriaVCGaleriaContainerIsHidden = false
    static var GaleriaMultimedia = [FotoVideo]()
    static var GaleriaDocumentos = [DocumentoGeneral]()
    static var GaleriaNombres = Set<String>()
    static var GaleriaCorrelativosABorrar = Set<Int>()
    static var GaleriaDocIdRequests = [Int]()
    static var GaleriaDocPorcentajes = [Int]()
    
    static func GaleriaGetData() -> (data: [Data], names: [String], fileNames: [String], mimeTypes: [String], toDel: String) {
        var arrayData = [Data]()
        var arrayNames = [String]()
        var arrayFileNames = [String]()
        var arrayMimeTypes = [String]()
        for i in 0..<Globals.GaleriaMultimedia.count {
            let unit = Globals.GaleriaMultimedia[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("multimedia\(i)")
                arrayFileNames.append(unit.Descripcion!)
                arrayMimeTypes.append(unit.mimeType!)
            }
        }
        for i in 0..<Globals.GaleriaDocumentos.count {
            let unit = Globals.GaleriaDocumentos[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("documento\(i)")
                arrayFileNames.append(unit.Descripcion!)
                arrayMimeTypes.append(unit.mimeType!)
            }
        }
        var toDel = (Globals.GaleriaCorrelativosABorrar.map{String($0)}).joined(separator: ";")
        toDel = toDel == "" ? "-" : toDel
        return (arrayData, arrayNames, arrayFileNames, arrayMimeTypes, toDel)
    }
    
    // Cambiar para usar en Todo Galeria
    //No olvidar enviar NroDetInspeccion en el Key de cada archivo (no nombre de archivo, sino lo que va a la izq)
    /*static var UOTab3Multimedia = [FotoVideo]()
    static var UOTab3Documentos = [DocumentoGeneral]()
    static var UOTab3Nombres = Set<String>()
    static var UOTab3CorrelativosABorrar = Set<Int>()*/
    
    // Variables Galeria
    
    // Upsert Observación
    static var UOCodigo = ""
    static var UOModo = ""
    static var UOTipo = "" // Usado solo en GET
    
    static var UOTab1ObsGD = ObservacionGD()
    static var UOTab1CodUbicacion = ""
    static var UOTab1CodSubUbicacion = ""
    static var UOTab1CodUbiEspecifica = ""
    static var UOTab1Fecha = Date()
    static var UOTab1String = ""
    
    static var UOTab2ObsDetalle = ObsDetalle()
    static var UOTab2String = ""
    static var UOTab2ObsSubDetalle = [ObsSubDetalle]() // Usado solo en GET
    static var UOTab2Involucrados = [Persona]() // Usado solo en GET
    static var UOTab2AspectosPrevios = [String]() // Usado solo en GET
    static var UOTab2EtapaDesviacion = [[String]]() // Usado solo en GET
    static var UOTab2Comentarios = [[String]]() // Usado solo en GET
    static var UOTab2Metodologia = [String]() // Usado solo en GET
    static var UOTab2ActividadAltoRiesgo = [String]() // Usado solo en GET
    static var UOTab2ActividadAltoRiesgoExt = [[String]]() // Usado solo en GET
    static var UOTab2Clasificacion = [String]() // Usado solo en GET
    static var UOTab2ComportamientoCondicion = [String]() // Usado solo en GET
    static var UOTab2ComportamientoCondicionExt = [[String]]() // Usado solo en GET
    
    static var UOTab4Planes: [PlanAccionDetalle] = []
    static var UOTab4CodAccionABorrar = Set<String>()
    // Upsert Observación
    
    static func UOloadModo(_ modo: String, _ codigo: String) {
        UOModo = modo
        UOCodigo = codigo
        GaleriaModo = modo
        UOTab1ObsGD = ObservacionGD()
        UOTab4Planes = []
        GaleriaDocIdRequests = []
        GaleriaDocPorcentajes = []
        
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
            GaleriaMultimedia = []
            GaleriaDocumentos = []
            GaleriaNombres.removeAll()
            GaleriaCorrelativosABorrar.removeAll()
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
                        let fotovideo = multimedia.toFotoVideo()
                        arrayFotoVideo.append(fotovideo)
                        Images.downloadImage("\(multimedia.Correlativo ?? 0)", {() in
                            fotovideo.imagen = Images.imagenes["P-\(multimedia.Correlativo ?? 0)"]
                        })
                        // Images.downloadImage()
                        break
                    case "TP02":
                        let fotovideo = multimedia.toFotoVideo()
                        arrayFotoVideo.append(fotovideo)
                        Images.downloadImage("\(multimedia.Correlativo ?? 0)", {() in
                            fotovideo.imagen = Images.imagenes["P-\(multimedia.Correlativo ?? 0)"]
                        })
                        break
                    default:
                        arrayDocumentos.append(multimedia.toDocumentoGeneral())
                        break
                    }
                }
                GaleriaMultimedia = arrayFotoVideo
                GaleriaDocumentos = arrayDocumentos
                GaleriaDocIdRequests = [Int].init(repeating: -1, count: GaleriaDocumentos.count)
                GaleriaDocPorcentajes = [Int].init(repeating: 0, count: GaleriaDocumentos.count)
                (Tabs.forAddObs[2] as! UpsertObsPVCTab3).galeriaVC.galeria.tableView.reloadData()
                // (Tabs.forAddObs[2] as! UpsertObsPVCTab3).galeriaVC.loadModo("PUT")
            }, error: nil)
            Rest.getDataGeneral(Routes.forPlanAccion(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
                UOTab4Planes = arrayPlanes.Data
                /*for plan in UOTab4Planes {
                    plan.NroDocReferencia = UOCodigo
                }*/
                (Tabs.forAddObs[3] as! UpsertObsPVCTab4).tableView.reloadData()
            }, error: nil)
            break
        case "GET":
            // Tab1
            (Tabs.forObsDetalle[0] as! ObsDetallePVCTab1).hijo.data = [["Codigo", "-"], ["Area", "-"], ["Nivel de riesgo", "-"], ["Observado Por", "-"], ["Fecha", "-"], ["Hora", "-"], ["Gerencia", "-"], ["Superintendencia", "-"]]
            (Tabs.forObsDetalle[0] as! ObsDetallePVCTab1).hijo.tableView.reloadData()
            Rest.getDataGeneral(Routes.forObservaciones(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                UOTab1ObsGD = Dict.dataToUnit(data!)!
                (Tabs.forObsDetalle[0] as! ObsDetallePVCTab1).reloadData()
            }, error: nil)
            Rest.getDataGeneral(Routes.forObsDetalle(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                UOTab2ObsDetalle = Dict.dataToUnit(data!)!
                print(resultValue)
                if UOTipo == "TO03" {
                    UOTab2Comentarios = [[String]]()
                    let splits = (UOTab2ObsDetalle.CodSubEstandar ?? "").components(separatedBy: ";")
                    if splits[0] != "" {
                        UOTab2Comentarios.append(["Se cumple el PET", splits[0]])
                        // valuesForComentarios.append(["Se Cumple el PET", String(splits[0])])
                    }
                    if splits.count > 1 && splits[1] != "" {
                        UOTab2Comentarios.append(["El trabajador requiere feedback", splits[1]])
                        // valuesForComentarios.append(["El trabajador requiere feedback", String(splits[1])])
                    }
                    if splits.count > 2 && splits[2] != "" {
                        UOTab2Comentarios.append(["El procedimiento debe modificarse", splits[2]])
                        // valuesForComentarios.append(["El procedimiento debe modificarse", String(splits[2])])
                    }
                    if splits.count > 3 && splits[3] != "" {
                        UOTab2Comentarios.append(["Reconocimientos/Oportunidades", splits[3]])
                        // valuesForComentarios.append(["Reconocimientos/Oportunidades", String(splits[3])])
                    }
                    Rest.getDataGeneral(Routes.forObsSubDetalle(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                        print(resultValue)
                        let arrayObsSubDetalle: ArrayGeneral<ObsSubDetalle> = Dict.dataToArray(data!)
                        UOTab2ObsSubDetalle = arrayObsSubDetalle.Data
                        UOTab2AspectosPrevios = []
                        for subDetalle in UOTab2ObsSubDetalle {
                            switch subDetalle.CodTipo ?? "" {
                            case "PREA":
                                UOTab2AspectosPrevios.append(Utils.searchMaestroStatic("ASPECTOSOBS", subDetalle.CodSubtipo ?? ""))
                            case "PETO":
                                UOTab2EtapaDesviacion.append([subDetalle.CodSubtipo ?? "", subDetalle.Descripcion ?? ""])
                            default:
                                break
                            }
                        }
                        (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).reloadData()
                    }, error: nil)
                    Rest.getDataGeneral(Routes.forObsInvolucrados(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                        print(resultValue)
                        let arrayInvolucrados: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                        UOTab2Involucrados = arrayInvolucrados.Data
                        
                        (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).reloadData()
                    }, error: nil)
                }
                if UOTipo == "TO04" {
                    Rest.getDataGeneral(Routes.forObsSubDetalle(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                        print(resultValue)
                        let arrayObsSubDetalle: ArrayGeneral<ObsSubDetalle> = Dict.dataToArray(data!)
                        UOTab2ObsSubDetalle = arrayObsSubDetalle.Data
                        UOTab2Metodologia = []
                        UOTab2ActividadAltoRiesgo = []
                        UOTab2ActividadAltoRiesgoExt = [["Interacción de Seguridad", UOTab2ObsDetalle.CodSubEstandar ?? ""]]
                        UOTab2Clasificacion = []
                        UOTab2ComportamientoCondicion = []
                        UOTab2ComportamientoCondicionExt = [["Detalle de los comportamientos/condiciones no seguras", UOTab2ObsDetalle.CodActiRel ?? ""], ["Acciones inmediatas (si es aplicable):", UOTab2ObsDetalle.Accion ?? ""]]
                        for subDetalle in UOTab2ObsSubDetalle {
                            switch subDetalle.CodTipo ?? "" {
                            case "OBSR":
                                UOTab2Metodologia.append(subDetalle.Descripcion ?? "")
                            case "HHA":
                                UOTab2ActividadAltoRiesgo.append(subDetalle.Descripcion ?? "")
                                if subDetalle.Descripcion == "19" {
                                    UOTab2ActividadAltoRiesgoExt.insert(["Otras actividades de alto riesgo", UOTab2ObsDetalle.CodObservacion ?? ""], at: 0)
                                }
                            case "OBSC":
                                UOTab2Clasificacion.append(subDetalle.Descripcion ?? "")
                            case "OBCC":
                                UOTab2ComportamientoCondicion.append(subDetalle.Descripcion ?? "")
                                if subDetalle.Descripcion == "COMCON11" {
                                    UOTab2ComportamientoCondicionExt.insert(["Otro comportamiento/condición", UOTab2ObsDetalle.CodTipo ?? ""], at: 0)
                                }
                            default:
                                break
                            }
                        }
                        (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).reloadData()
                    }, error: nil)
                    Rest.getDataGeneral(Routes.forObsInvolucrados(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                        print(resultValue)
                        let arrayInvolucrados: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                        // UOTab2Involucrados = arrayInvolucrados.Data
                        let codLider = UOTab2ObsDetalle.CodEstado ?? ""
                        var lider = Persona()
                        var newInvolucrados = [Persona]()
                        for involucrado in arrayInvolucrados.Data {
                            if involucrado.CodPersona ?? "" == codLider {
                                lider = involucrado
                            } else {
                                newInvolucrados.append(involucrado)
                            }
                        }
                        newInvolucrados.insert(lider, at: 0)
                        UOTab2Involucrados = newInvolucrados
                        (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).reloadData()
                    }, error: nil)
                }
                (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).reloadData()
            }, error: nil)
            Rest.getDataGeneral(Routes.forMultimedia(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                let separados = Utils.separateMultimedia(arrayMultimedia.Data)
                GaleriaDocumentos = separados.documentos
                GaleriaMultimedia = separados.fotovideos
                GaleriaDocIdRequests = [Int].init(repeating: -1, count: GaleriaDocumentos.count)
                GaleriaDocPorcentajes = [Int].init(repeating: 0, count: GaleriaDocumentos.count)
                GaleriaVCViewContainerIsHidden = GaleriaMultimedia.count > 0 || GaleriaDocumentos.count > 0
                GaleriaVCGaleriaContainerIsHidden = !GaleriaVCViewContainerIsHidden
                for media in GaleriaMultimedia {
                    Images.downloadImage("\(media.Correlativo!)", {() in
                        media.imagen = Images.imagenes["P-\(media.Correlativo!)"]
                        (Tabs.forObsDetalle[2] as! ObsDetallePVCTab3).galeria.galeria.tableView.reloadData()
                    })
                }
                Rest.getDataGeneral(Routes.forPlanAccion(UOCodigo), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
                    UOTab4Planes = arrayPlanes.Data
                    (Tabs.forObsDetalle[3] as! ObsDetallePVCTab4).tabla?.reloadData()
                }, error: nil)
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
        var data = String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!
        if UOModo == "PUT" && data == UOTab1String {
            data = "-"
        }
        
        if nombreVariable == "" {
            return (true, data)
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
        var data = String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!
        if UOModo == "PUT" && data == UOTab1String {
            data = "-"
        }
        
        if nombreVariable == "" {
            return (true, data)
        } else {
            return (false, nombreVariable)
        }
    }
    
    static func UOTab3GetData() -> (data: [Data], names: [String], fileNames: [String], mimeTypes: [String], toDel: String) {
        var arrayData = [Data]()
        var arrayNames = [String]()
        var arrayFileNames = [String]()
        var arrayMimeTypes = [String]()
        for i in 0..<Globals.GaleriaMultimedia.count {
            let unit = Globals.GaleriaMultimedia[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("multimedia\(i)")
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
        for i in 0..<Globals.GaleriaDocumentos.count {
            let unit = Globals.GaleriaDocumentos[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("documento\(i)")
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
        var toDel = (Globals.GaleriaCorrelativosABorrar.map{String($0)}).joined(separator: ";")
        toDel = toDel == "" ? "-" : toDel
        return (arrayData, arrayNames, arrayFileNames, arrayMimeTypes, toDel)
    }
    
    static func UOTab4GetData() -> (toAdd: String, toDel: String) {
        var cont = -1
        for plan in Globals.UOTab4Planes {
            if plan.CodAccion == nil {
                plan.CodAccion = "\(cont)"
                plan.NroDocReferencia = plan.NroDocReferencia ?? ""
                plan.CodReferencia = plan.CodReferencia ?? ""
                //plan.CodResponsable = plan.CodResponsables ?? ""
                // plan.CodTablaRef = plan.CodTabla ?? ""
                cont = cont - 1
            }
        }
        var toDel = UOTab4CodAccionABorrar.joined(separator: ";")
        toDel = toDel == "" ? "-" : toDel
        return (String.init(data: Dict.unitToData(Globals.UOTab4Planes)!, encoding: .utf8)!, toDel)
    }
    // Seccion Observacion
    
    // Upsert Inspección
    static var UIModo = ""
    static var UICodigo = ""
    
    static var UITab1InsGD = InspeccionGD()
    static var UITab1Fecha: Date? = nil
    static var UITab1FechaP: Date? = nil
    static var UITab1Hora: Date? = nil
    
    static var UITab2Realizaron = [Persona]()
    static var UITab2Atendieron = [Persona]()
    static var UITab2RealizaronNuevo = Set<String>()
    static var UITab2RealizaronNuevoLider = ""
    static var UITab2AtendieronNuevo = Set<String>()
    static var UITab2RealizaronOriginal = Set<String>()
    static var UITab2RealizaronOriginalLider = ""
    static var UITab2AtendieronOriginal = Set<String>()
    
    static var UITab2IndexLider = -1
    
    static var UITab3ObsGeneral = [InsObservacion]()
    static var UITab3LocalObsDetalle = [InsObservacionGD]()
    static var UITab3LocalMultimedias = [[FotoVideo]]()
    static var UITab3LocalDocumentos = [[DocumentoGeneral]]()
    static var UITab3LocalPlanes = [[PlanAccionDetalle]]()
    static var UITab3ObsToDel = Set<Int>()
    
    static func UILoadModo(_ modo: String, _ codigo: String) {
        UIModo = modo
        UICodigo = codigo
        switch modo {
        case "ADD":
            UICodigo = "INS0000000XYZ"
            // Tab1
            UITab1InsGD = InspeccionGD()
            UITab1Hora = nil
            UITab1Fecha = nil
            UITab1FechaP = nil
            (Tabs.forAddIns[0] as! UpsertInsPVCTab1).tableView.reloadData()
            // Tab2
            UITab2IndexLider = -1
            UITab2Realizaron = []
            UITab2RealizaronNuevo.removeAll()
            UITab2RealizaronOriginal.removeAll()
            UITab2RealizaronOriginalLider = ""
            UITab2RealizaronNuevoLider = ""
            UITab2Atendieron = []
            UITab2AtendieronOriginal.removeAll()
            UITab2AtendieronNuevo.removeAll()
            (Tabs.forAddIns[1] as! UpsertInsPVCTab2).tableView.reloadData()
            // Tab3
            UITab3ObsGeneral = []
            (Tabs.forAddIns[2] as! UpsertInsPVCTab3).tableView.reloadData()
            break
        case "PUT":
            // Tab1
            UITab1InsGD = InspeccionGD()
            UITab1Hora = nil
            UITab1Fecha = nil
            UITab1FechaP = nil
            (Tabs.forAddIns[0] as! UpsertInsPVCTab1).tableView.reloadData()
            Rest.getDataGeneral(Routes.forInspecciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
                Globals.UITab1InsGD = Dict.dataToUnit(data!)!
                UITab1Fecha = Utils.str2date(Globals.UITab1InsGD.Fecha ?? "")
                UITab1Hora = UITab1Fecha
                UITab1FechaP = Utils.str2date(Globals.UITab1InsGD.FechaP ?? "")
                (Tabs.forAddIns[0] as! UpsertInsPVCTab1).tableView.reloadData()
            }, error: nil)
            // Tab2
            UITab2IndexLider = -1
            UITab2Realizaron = []
            UITab2RealizaronNuevo.removeAll()
            UITab2RealizaronOriginal.removeAll()
            UITab2RealizaronOriginalLider = ""
            UITab2RealizaronNuevoLider = ""
            UITab2Atendieron = []
            UITab2AtendieronOriginal.removeAll()
            UITab2AtendieronNuevo.removeAll()
            (Tabs.forAddIns[1] as! UpsertInsPVCTab2).tableView.reloadData()
            Rest.getDataGeneral(Routes.forInsEquipoInspeccion(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                UITab2Realizaron = arrayPersonas.Data
                for i in 0..<UITab2Realizaron.count {
                    if UITab2Realizaron[i].Lider == "1" {
                        UITab2IndexLider = i
                        UITab2RealizaronOriginalLider = UITab2Realizaron[i].CodPersona!
                    }
                    UITab2RealizaronOriginal.insert(UITab2Realizaron[i].CodPersona!)
                    UITab2RealizaronNuevo.insert(UITab2Realizaron[i].CodPersona!)
                }
                (Tabs.forAddIns[1] as! UpsertInsPVCTab2).tableView.reloadData()
            }, error: nil)
            Rest.getDataGeneral(Routes.forInsPersonasAtendidas(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                UITab2Atendieron = arrayPersonas.Data
                for persona in arrayPersonas.Data {
                    UITab2AtendieronOriginal.insert(persona.CodPersona!)
                    UITab2AtendieronNuevo.insert(persona.CodPersona!)
                }
                (Tabs.forAddIns[1] as! UpsertInsPVCTab2).tableView.reloadData()
            }, error: nil)
            // Tab3
            UITab3ObsGeneral = []
            (Tabs.forAddIns[2] as! UpsertInsPVCTab3).tableView.reloadData()
            Rest.getDataGeneral(Routes.forInsObservaciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayObservaciones: ArrayGeneral<InsObservacion> = Dict.dataToArray(data!)
                UITab3ObsGeneral = arrayObservaciones.Data
                UITab3LocalObsDetalle = [InsObservacionGD].init(repeating: InsObservacionGD(), count: UITab3ObsGeneral.count)
                UITab3LocalMultimedias = [[FotoVideo]].init(repeating: [], count: UITab3ObsGeneral.count)
                UITab3LocalDocumentos = [[DocumentoGeneral]].init(repeating: [], count: UITab3ObsGeneral.count)
                UITab3LocalPlanes = [[PlanAccionDetalle]].init(repeating: [], count: UITab3ObsGeneral.count)
                (Tabs.forAddIns[2] as! UpsertInsPVCTab3).tableView.reloadData()
            }, error: nil)
            break
        default:
            break
        }
    }
    
    static func UITab1GetData() -> (success: Bool, data: String) {
        // Limpar de data no necesaria
        var showData = Globals.UITab1InsGD
        showData.CodInspeccion = showData.CodInspeccion ?? "INSP000000XYZ"
        
        // Verificar que estén los datos mínimos
        var nombreVariable = ""
        if Globals.UITab1FechaP == nil {
            nombreVariable = "Fecha Programada"
        } else {
            showData.FechaP = Utils.date2str(Globals.UITab1FechaP, "YYYY-MM-dd")
        }
        if Globals.UITab1Fecha == nil {
            nombreVariable = "Fecha Inspección"
        } else {
            showData.Fecha = Utils.date2str(Globals.UITab1Fecha, "YYYY-MM-dd")
            if Globals.UITab1Hora != nil {
                showData.Fecha = "\(showData.Fecha!)T\(Utils.date2str(Globals.UITab1Hora, "HH:mm:SS"))"
            } else {
                showData.Fecha = "\(showData.Fecha!)T00:00:00"
            }
        }
        if showData.Gerencia == nil || showData.Gerencia == "" {
            nombreVariable = "Gerencia"
        }
        if showData.CodUbicacion == nil || showData.CodUbicacion == "" {
            nombreVariable = "CodUbicacion"
        }
        
        // Enviar los datos, o el nombre de la variable que falta
        var data = String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!
        /*if UOModo == "PUT" && data == UOTab1String {
            data = "-"
        }*/
        print(data)
        if nombreVariable == "" {
            return (true, data)
        } else {
            return (false, nombreVariable)
        }
    }
    
    static func UITab2GetData() -> (respuesta: String, responsables: String, atendidos: String) {
        if Globals.UITab2Realizaron.count == 0 {
            return ("Personas que realizaron la inspección", "", "")
        }
        if Globals.UITab2IndexLider == -1 {
            return ("Lider en Equipo de Inspección", "", "")
        }
        var responsables = [Persona]()
        var atendieron = [Persona]()
        var strResponsables = "-"
        var strAtendieron = "-"
        switch UIModo {
        case "ADD":
            for persona in UITab2Realizaron {
                let nuevaPersona = Persona()
                nuevaPersona.CodPersona = persona.CodPersona
                nuevaPersona.Lider = persona.Lider == "1" ? "1" : "0"
                responsables.append(nuevaPersona)
            }
            for persona in UITab2Atendieron {
                let nuevaPersona = Persona()
                nuevaPersona.CodPersona = persona.CodPersona
                nuevaPersona.Lider = "0"
                atendieron.append(nuevaPersona)
            }
            strResponsables = String.init(data: Dict.unitToData(responsables)!, encoding: .utf8) ?? "-"
            strAtendieron = String.init(data: Dict.unitToData(atendieron)!, encoding: .utf8) ?? "-"
            return ("", strResponsables, strAtendieron)
        case "PUT":
            if UITab2RealizaronNuevoLider != UITab2RealizaronOriginalLider || UITab2RealizaronNuevo != UITab2RealizaronOriginal {
                let primeraPersona = Persona()
                primeraPersona.NroReferencia = UICodigo
                primeraPersona.Estado = "L"
                primeraPersona.Lider = UITab2RealizaronNuevoLider
                responsables.append(primeraPersona)
                for codigo in UITab2RealizaronNuevo.subtracting(UITab2RealizaronOriginal) {
                    let persona = Persona()
                    persona.CodPersona = codigo
                    persona.Estado = "A"
                    responsables.append(persona)
                }
                for codigo in UITab2RealizaronOriginal.subtracting(UITab2RealizaronNuevo) {
                    let persona = Persona()
                    persona.CodPersona = codigo
                    persona.Estado = "E"
                    responsables.append(persona)
                }
                strResponsables = String.init(data: Dict.unitToData(responsables)!, encoding: .utf8) ?? ""
            }
            if UITab2AtendieronNuevo != UITab2AtendieronOriginal {
                for codigo in UITab2AtendieronNuevo.subtracting(UITab2AtendieronOriginal) {
                    let persona = Persona()
                    persona.CodPersona = codigo
                    persona.Estado = "A"
                    atendieron.append(persona)
                }
                for codigo in UITab2AtendieronOriginal.subtracting(UITab2AtendieronNuevo) {
                    let persona = Persona()
                    persona.CodPersona = codigo
                    persona.Estado = "E"
                    atendieron.append(persona)
                }
                atendieron[0].NroReferencia = UICodigo
                strAtendieron = String.init(data: Dict.unitToData(atendieron)!, encoding: .utf8) ?? "-"
            }
            return ("", strResponsables, strAtendieron)
        default:
            return ("Error desconocido, informe a un administrador", "", "")
        }
    }
    
    static func UITab3GetData() -> (observaciones: String, planes: String, atendidos: String, data: [Data], names: [String], fileNames: [String], mimeTypes: [String], obsToDel: String) {
        switch UIModo {
        case "ADD":
            var arrayData = [Data]()
            var arrayNames = [String]()
            var arrayFileNames = [String]()
            var arrayMimeTypes = [String]()
            var arrayPlanes = [PlanAccionDetalle]()
            for i in 0..<UITab3ObsGeneral.count {
                // Tab1 - UIO
                UITab3ObsGeneral[i].Correlativo = i+1
                UITab3LocalObsDetalle[i].Correlativo = nil
                UITab3LocalObsDetalle[i].CodInspeccion = ""//"INSP000000XYZ"
                UITab3LocalObsDetalle[i].NroDetInspeccion = i+1
                UITab3LocalObsDetalle[i].Lugar = UITab3LocalObsDetalle[i].Lugar ?? ""
                UITab3LocalObsDetalle[i].Observacion = UITab3LocalObsDetalle[i].Observacion ?? ""
                // Tab2 - UIO
                for unit in UITab3LocalMultimedias[i] {
                    if unit.multimediaData != nil && unit.Descripcion != nil {
                        arrayData.append(unit.multimediaData!)
                        arrayNames.append("\(i+1)")
                        arrayFileNames.append(unit.getFileName())
                        arrayMimeTypes.append(unit.getMimeType())
                    }
                }
                for unit in UITab3LocalDocumentos[i] {
                    if unit.multimediaData != nil && unit.Descripcion != nil {
                        arrayData.append(unit.multimediaData!)
                        arrayNames.append("\(i+1)")
                        arrayFileNames.append(unit.getFileName())
                        arrayMimeTypes.append(unit.getMimeType())
                    }
                }
                // Tab3 - UIO
                for j in 0..<UITab3LocalPlanes[i].count {
                    let unit = UITab3LocalPlanes[i][j].copy()
                    unit.CodAccion = "\((j * -1)-1)"
                    unit.NroDocReferencia = ""
                    unit.SolicitadoPor = nil
                    unit.Responsables = nil
                    unit.CodEstadoAccion = "01"
                    unit.CodReferencia = "02"
                    unit.CodTabla = "TINS"
                    unit.NroAccionOrigen = i+1
                    arrayPlanes.append(unit)
                }
            }
            let strObservaciones = String.init(data: Dict.unitToData(UITab3LocalObsDetalle)!, encoding: .utf8) ?? "[]"
            let strPlanes = String.init(data: Dict.unitToData(arrayPlanes)!, encoding: .utf8) ?? "[]"
            return (strObservaciones, strPlanes, "", arrayData, arrayNames, arrayFileNames, arrayMimeTypes, "")
        case "PUT":
            var toDel = (UITab3ObsToDel.map{String($0)}).joined(separator: ";")
            toDel = toDel == "" ? "-" : toDel
            return ("[]", "[]", "", [], [], [], [], toDel)
        default:
            return ("[]", "[]", "", [], [], [], [], "")
        }
    }
    // Upsert Inspección
    
    
    // Upsert InsObservacion
    static var UIOModo = ""
    static var UIOCodigo = ""
    static var UIOCorrelativo: Int?
    
    static var UIOTab1ObsDetalle = InsObservacionGD()
    // static var UIOTab1CodUbiEspecifica: String?
    // No hay variables para tab2: Galeria
    static var UIOTab3Planes = [PlanAccionDetalle]()
    static var UIOTab3PlanesToDel = Set<String>()
    
    static func UIOLoadModo(_ modo: String, _ codigoInspeccion: String, _ correlativo: Int?, _ id: Int) {
        UIOModo = modo
        UIOCodigo = codigoInspeccion
        UIOCorrelativo = correlativo
        
        switch modo {
        case "ADD":
            // Tab1
            UIOTab1ObsDetalle = InsObservacionGD()
            // UIOTab1CodUbiEspecifica = ""
            (Tabs.forAddInsObs[0] as! UpsertInsObsPVCTab1).tableView.reloadData()
            // Tab2
            GaleriaModo = "ADD"
            GaleriaNombres.removeAll()
            GaleriaDocIdRequests = []
            GaleriaDocPorcentajes = []
            GaleriaDocumentos = []
            GaleriaMultimedia = []
            GaleriaCorrelativosABorrar.removeAll()
            (Tabs.forAddInsObs[1] as! UpsertInsObsPVCTab2).galeria.tableView.reloadData()
            // Tab3
            UIOTab3Planes = []
            (Tabs.forAddInsObs[2] as! UpsertInsObsPVCTab3).tableView.reloadData()
            break
        case "PUT":
            if correlativo != nil {
                // Tab1
                Rest.getDataGeneral(Routes.forInsObservacionGD("\(correlativo!)"), true, success: {(resultValue:Any?,data:Data?) in
                    let insObservacionGD: InsObservacionGD = Dict.dataToUnit(data!)!
                    Globals.UIOTab1ObsDetalle = insObservacionGD
                    Globals.UIOTab1ObsDetalle.Correlativo = correlativo
                    (Tabs.forAddInsObs[0] as! UpsertInsObsPVCTab1).tableView.reloadData()
                }, error: nil)
                // Tab2
                GaleriaModo = "PUT"
                GaleriaNombres.removeAll()
                GaleriaDocumentos = []
                GaleriaMultimedia = []
                GaleriaCorrelativosABorrar.removeAll()
                Rest.getDataGeneral(Routes.forMultimedia(codigoInspeccion), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                    let separados = Utils.separateMultimedia(arrayMultimedia.Data)
                    for fotovideo in separados.fotovideos {
                        print("\(fotovideo.Descripcion) - \(fotovideo.Correlativo)")
                        Images.downloadImage("\(fotovideo.Correlativo!)", {() in
                            fotovideo.imagen = Images.imagenes["P-\(fotovideo.Correlativo!)"]
                        })
                        // Images.downloadImage("\(fotovideo.Correlativo!)")
                    }
                    GaleriaMultimedia = separados.fotovideos
                    GaleriaDocumentos = separados.documentos
                    GaleriaDocIdRequests = [Int].init(repeating: -1, count: GaleriaDocumentos.count)
                    GaleriaDocPorcentajes = [Int].init(repeating: 0, count: GaleriaDocumentos.count)
                    (Tabs.forAddInsObs[1] as! UpsertInsObsPVCTab2).galeria.tableView.reloadData()
                }, error: nil)
                Rest.getDataGeneral(Routes.forPlanAccion(codigoInspeccion), true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
                    UIOTab3Planes = arrayPlanes.Data
                    (Tabs.forAddInsObs[2] as! UpsertInsObsPVCTab3).tableView.reloadData()
                }, error: nil)
            } else {
                // Tab1
                UIOTab1ObsDetalle = UITab3LocalObsDetalle[id].copy()
                (Tabs.forAddInsObs[0] as! UpsertInsObsPVCTab1).tableView.reloadData()
                // Tab2
                GaleriaModo = "PUT"
                GaleriaNombres.removeAll()
                GaleriaDocIdRequests = []
                GaleriaDocPorcentajes = []
                GaleriaDocumentos = []
                GaleriaMultimedia = []
                GaleriaCorrelativosABorrar.removeAll()
                
            }
            
            
            break
        default:
            break
        }
    }
    
    static func UIOTab1GetData() -> (success: Bool, data: String) {
        // Limpar de data no necesaria
        let showData = Globals.UIOTab1ObsDetalle
        showData.CodInspeccion = UICodigo ?? ""
        showData.CodAspectoObs = showData.CodAspectoObs ?? ""
        showData.CodActividadRel = showData.CodActividadRel ?? ""
        showData.CodNivelRiesgo = showData.CodNivelRiesgo ?? ""
        showData.Observacion = showData.Observacion ?? ""
        showData.Lugar = showData.Lugar ?? ""
        /*parametros.Add(new SqlParameter("CodInspeccion", value.CodInspeccion == null ? "" : value.CodInspeccion));
         parametros.Add(new SqlParameter("CodTipoInspeccion", value.CodTipo == null ? (object)DBNull.Value : value.CodTipo));
         parametros.Add(new SqlParameter("CodProveedor", value.CodContrata == null ? (object)DBNull.Value : value.CodContrata));
         parametros.Add(new SqlParameter("FechaProgramada", value.FechaP == null ? (object)"" : value.FechaP));
         parametros.Add(new SqlParameter("FechaInspeccion", value.Fecha == null ? (object)"" : value.Fecha));
         parametros.Add(new SqlParameter("CodPosicionGer", value.Gerencia));
         parametros.Add(new SqlParameter("CodPosicionSup", value.SuperInt == null ? (object)DBNull.Value : value.SuperInt));
         parametros.Add(new SqlParameter("CodUbicacion", value.CodUbicacion));
         parametros.Add(new SqlParameter("CodSubUbicacion", value.CodSubUbicacion == null ? (object)DBNull.Value : value.CodSubUbicacion));*/
        
        
        // Verificar que estén los datos mínimos
        var nombreVariable = ""
        if showData.CodAspectoObs == "" {
            nombreVariable = "Aspecto Observado"
        }
        if showData.CodActividadRel == "" {
            nombreVariable = "Actividad Relacionada"
        }
        if showData.CodNivelRiesgo == "" {
            nombreVariable = "Nivel Riesgo"
        }
        if showData.Observacion == "" {
            nombreVariable = "Observación"
        }
        
        // Enviar los datos, o el nombre de la variable que falta
        // Verificar, modo PUT aun no esta
        var data = String.init(data: Dict.unitToData(showData)!, encoding: .utf8)!
        /*if UOModo == "PUT" && data == UOTab1String {
            data = "-"
        }*/
        
        if nombreVariable == "" {
            return (true, data)
        } else {
            return (false, nombreVariable)
        }
    }
    
    static func UIOTab2GetData() -> () {
        var arrayData = [Data]()
        var arrayNames = [String]()
        var arrayFileNames = [String]()
        var arrayMimeTypes = [String]()
        var arrayPlanes = [PlanAccionDetalle]()
        for unit in GaleriaMultimedia {
            if unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("nombre")
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
        for unit in GaleriaDocumentos {
            if unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("nombre")
                arrayFileNames.append(unit.getFileName())
                arrayMimeTypes.append(unit.getMimeType())
            }
        }
    }
    
    static func UIOTab3GetData() -> (toAdd: String, toDel: String) {
        var arrayPlanes = [PlanAccionDetalle]()
        var toAdd = ""
        var toDel = ""
        for unit in UIOTab3Planes {
            let copia = unit.copy()
            copia.CodAccion = "-1"
            copia.NroDocReferencia = ""
            copia.SolicitadoPor = nil
            copia.Responsables = nil
            copia.CodEstadoAccion = "01"
            copia.CodReferencia = "02"
            copia.CodTabla = "TINS"
            copia.NroAccionOrigen = -2000
            arrayPlanes.append(copia)
        }
        toAdd = String.init(data: Dict.unitToData(arrayPlanes)!, encoding: .utf8) ?? "[]"
        toDel = UIOTab3PlanesToDel.joined(separator: ";")
        toDel = toDel == "" ? "-" : toDel
        return (toAdd, toDel)
    }
    // Upsert InsObservacion
    
    // Upsert Facilito
    static var UFViewController = UpsertFacilitoVC()
    static var UFModo = ""
    static var UFCodigo = ""
    static var UFDetalle = FacilitoGD()
    
    static func UFLoadModo(_ modo: String, _ codigo: String) {
        UFModo = modo
        UFCodigo = codigo
        UFDetalle = FacilitoGD()
        UFDetalle.Tipo = "A"
        Globals.GaleriaModo = modo
        Globals.GaleriaDocumentos = []
        Globals.GaleriaMultimedia = []
        Globals.GaleriaNombres.removeAll()
        Globals.GaleriaCorrelativosABorrar.removeAll()
        switch modo {
        case "ADD":
            UFViewController.tabla?.reloadData()
            break
        case "PUT":
            Rest.getDataGeneral(Routes.forFacilitoDetalle(codigo), true, success: {(resultValue:Any?,data:Data?) in
                UFDetalle = Dict.dataToUnit(data!)!
                UFViewController.tabla?.reloadData()
                print(resultValue)
            }, error: {(error) in
                print(error)
            })
            Rest.getDataGeneral(Routes.forMultimedia("\(codigo)-1"), true, success: {(resultValue:Any?,data:Data?) in
                var arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                // var separado = Utils.separateMultimedia(arrayMultimedia.Data)
                Globals.GaleriaMultimedia = Utils.separateMultimedia(arrayMultimedia.Data).fotovideos
                for media in Globals.GaleriaMultimedia {
                    Images.downloadImage("\(media.Correlativo!)", {() in
                        media.imagen = Images.imagenes["P-\(media.Correlativo!)"]
                        UFViewController.tabla?.reloadSections([2], with: .none)
                    })
                }
                // UFViewController.tabla?.reloadData()
            }, error: nil)
            break
        default:
            break
        }
    }
    
    static func UFGetData() -> (respuesta: String, data: String) {
        var nombreVariable = ""
        if UFDetalle.CodPosicionGer == nil || UFDetalle.CodPosicionGer == "" {
            nombreVariable = "Gerencia"
        }
        if UFDetalle.UbicacionExacta == nil || UFDetalle.UbicacionExacta == "" {
            nombreVariable = "Ubicacion"
        }
        if UFDetalle.Observacion == nil || UFDetalle.Observacion == "" {
            nombreVariable = "Observacion"
        }
        if UFDetalle.Accion == nil || UFDetalle.Accion == "" {
            nombreVariable = "Accion"
        }
        if nombreVariable == "" {
            UFDetalle.CodObsFacilito = UFCodigo
            UFDetalle.CodPosicionSup = UFDetalle.CodPosicionSup ?? ""
            UFDetalle.RespAuxiliar = UFDetalle.RespAuxiliar ?? ""
            UFDetalle.Estado = UFDetalle.Estado ?? "P"
            return ("", String.init(data: Dict.unitToData(UFDetalle)!, encoding: .utf8)!)
        } else {
            return (nombreVariable, "")
        }
    }
    // Upsert Facilito
    
    static func loadGlobals() {
        
        Utils.maestroStatic1["VIGENCIA"] = ["1", "2", "3", "4", "5"]
        Utils.maestroStatic2["VIGENCIA"] = ["Dias", "Semanas", "Meses", "Años", "Nunca"]
        
        Utils.maestroStatic1["ASPECTOSOBS"] = ["P001", "P002", "P003", "P004", "P005", "P006", "P007", "P008"]
        Utils.maestroStatic2["ASPECTOSOBS"] = ["EPP completos para la tarea", "Orden y Limpieza", "Estado de Herramientas", "Materiales necesarios para la tarea", "Estado de las instalaciones y/o estructuras", "Análisis de Seguridad en el trabajo / Peligros identificados y controles existentes", "Permiso(s) de Trabajo", "Se cumplen las  restricciones o condiciones generales del PET"]
        
        Utils.maestroStatic1["GESTIONRIESGO"] = ["GESRIES1", "GESRIES2", "GESRIES3"]
        Utils.maestroStatic2["GESTIONRIESGO"] = ["Permiso de trabajo", "PET(Procedimiento escrito de trabajo)", "AST(Análisis de Seguridad en el trabajo)"]
        
        Utils.maestroStatic1["CLASIFICACIONOBS"] = ["CLASOBS1", "CLASOBS2", "CLASOBS3", "CLASOBS4"]
        Utils.maestroStatic2["CLASIFICACIONOBS"] = ["Comportamiento seguro", "Comportamiento de riesgo", "Condición segura", "Condición insegura"]
        
        Utils.maestroStatic1["CONDICIONCOMPORTAMIENTO"] = ["COMCON1", "COMCON2", "COMCON3", "COMCON4", "COMCON5", "COMCON6", "COMCON7", "COMCON8", "COMCON10", "COMCON11"]
        Utils.maestroStatic2["CONDICIONCOMPORTAMIENTO"] = ["Competencias", "Salud e Higiene", "Posición de las Personas", "Valores de Glencore", "Medio Ambiente", "Orden y Limpieza", "Herramientas y Equipos", "Aptitud para el Trabajo", "Condiciones de Trabajo", "Otro"]
        
        Utils.maestroStatic1["REFERENCIAPLAN"] = ["01", "02", "03", "04", "05", "06", "07", "08", "09"]
        Utils.maestroStatic2["REFERENCIAPLAN"] = ["Observaciones", "Inspecciones", "Incidentes", "IPERC", "Auditorias", "Simulacros", "Reuniones", "Comites", "Capacitaciones"]
        
        Utils.maestroStatic1["ESTADOPLAN"] = ["01", "02", "03", "04", "05"]
        Utils.maestroStatic2["ESTADOPLAN"] = ["Pendiente", "Atendido", "En Proceso", "Observado", "Cerrado"]
        
        Utils.maestroStatic1["NIVELRIESGO"] = ["BA", "ME", "AL"]
        Utils.maestroStatic2["NIVELRIESGO"] = ["Baja", "Media", "Alta"]
        
        Utils.maestroStatic1["TABLAS"] = ["TCOM", "THIG", "TINC", "TINS", "TIPE", "TOBS", "TREU", "TSIM", "TYOS", "TCAP", "TDETAINSP", "TDIPEAFEC", "TEAU", "TEIN", "THALL", "TINVEAFEC", "TSEC", "TSIM", "TTES", "OTROS"]
        Utils.maestroStatic2["TABLAS"] = ["Comites", "Higiene", "Incidentes", "Inspecciones", "IPERC", "Observaciones", "Reuniones", "Simulacro", "Yo Aseguro", "ActaAsistencia", "DetalleInspeccion", "DiasPerdidosAfectado", "EquipoAuditor", "EquipoInvestigacion", "Hallazgos", "InvestigaAfectado", "SecuenciaEvento", "Simulacro", "TestigoInvolucrado", "Otros"]
        
        Utils.maestroStatic1["TIPOFACILITO"] = ["A", "C"]
        Utils.maestroStatic2["TIPOFACILITO"] = ["Acción", "Condición"]
        
        Utils.maestroStatic1["SEXO"] = ["01", "02"]
        Utils.maestroStatic2["SEXO"] = ["Masculino", "Femenino"]
        
        Utils.maestroStatic1["ESTADOFACILITO"] = ["A", "O", "P", "S"]
        Utils.maestroStatic2["ESTADOFACILITO"] = ["Atendido", "Observado", "Pendiente", "Espera"]
        
        Utils.maestroStatic1["ROLUSUARIO"] = ["1", "2", "3", "4"]
        Utils.maestroStatic2["ROLUSUARIO"] = ["Rol 1", "Rol 2", "Rol 3", "Usuario HSEC"]
        
        Utils.maestroStatic1["TIPOAUTENTICACION"] = ["B", "W"]
        Utils.maestroStatic2["TIPOAUTENTICACION"] = ["Básico", "Windows"]
        
        Utils.maestroStatic1["ACTOSUBESTANDAR"] = ["0001","0002","0003","0004","0005","0006","0007","0008","0009","0010","0011","0012","0013","0014","0015","0016","0017","0018","0019","0020","0021","0022","0023","0024","0025"]
        Utils.maestroStatic2["ACTOSUBESTANDAR"] = ["Operar equipos sin autorización","Operar  equipo a velocidad inadecuada","No Avisar","No Advertir","No Asegurar","Desactivar Dispositivos de Seguridad","Usar Equipos y Herramientas Defectuosos","Uso inadecuado o no uso de EPP","Cargar Incorrectamente","Ubicación Incorrecta","Levantar Incorrectamente","Posición Inadecuada para el Trabajo o la Tarea","Dar mantenimiento a equipo en operación","Jugar en el trabajo","Usar equipo inadecuadamente","Trabajo bajo la Influencia del Alcohol y/u otras Drogas","Maniobra incorrecta","Uso inapropiado de herramientas","Evaluación de riesgos deficiente por parte del personal","Control inadecuado de energía (bloqueo/etiquetado)","Instrumentos mal interpretados / mal leídos","Hechos de violencia","Exponerse a la línea de fuego","No uso de los 3 puntos de apoyo","Intento por realizar tareas múltiples en forma simultánea"]
        Utils.maestroStatic1["CONDICIONSUBESTANDAR"] = ["0027","0028","0029","0030","0031","0032","0033","0034","0035","0036","0037","0038","0039","0040","0041","0042","0043","0044","0045","0046","0047"]
        Utils.maestroStatic2["CONDICIONSUBESTANDAR"] = ["Protección inadecuada, defectuosa o inexistente","Paredes, techos, etc. inestables","Caminos, pisos, superficies inadecuadas","Equipo de protección personal inadecuado","Herramientas, Equipos, Materiales Defectuosos o sin calibración","Congestión o Acción Restringida","Alarmas, Sirenas, Sistemas de Advertencia Inadecuado  o defectuosos","Peligros de Incendio y Explosión","Limpieza y Orden deficientes","Exceso de Ruido","Exceso de Radiación","Temperaturas Extremas","Peligros ergonómicos","Excesiva o inadecuada iluminación","Ventilación Inadecuada","Condiciones Ambientales Peligrosas","Dispositivos de seguridad inadecuados / defectuosos","Sistemas y Equipos energizados","Productos químicos peligrosos","Altura desprotegida","Derrame"]
    }
}
