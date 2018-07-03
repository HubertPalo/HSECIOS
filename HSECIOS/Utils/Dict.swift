import UIKit

class Dict {
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static func dataToArray<Class: Codable>(_ data: Data) -> ArrayGeneral<Class> {
        do {
            let result: ArrayGeneral<Class> = try decoder.decode(ArrayGeneral<Class>.self, from: data)
            return result
        } catch {
            return ArrayGeneral<Class>()
        }
    }
    
    static func dataToUnit<Class: Codable>(_ data: Data) -> Class? {
        do {
            let result: Class = try decoder.decode(Class.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    static func unitToData<Class: Codable>(_ objeto: Class) -> Data? {
        do {
            let result = try encoder.encode(objeto)
            return result
        } catch {
            return nil
        }
    }
    
    /*static func toUserData(_ dictionary: NSDictionary) -> UserData {
        let unit = UserData()
        unit.Area = dictionary["Area"] as? String ?? ""
        unit.Cargo = dictionary["Cargo"] as? String ?? ""
        unit.Codigo_Usuario = dictionary["Codigo_Usuario"] as? String ?? ""
        unit.CodPersona = dictionary["CodPersona"] as? String ?? ""
        unit.CodUsuario = dictionary["CodUsuario"] as? String ?? ""
        unit.Email = dictionary["Email"] as? String ?? ""
        unit.Empresa = dictionary["Empresa"] as? String ?? ""
        unit.Nombres = dictionary["Nombres"] as? String ?? ""
        unit.NroDocumento = dictionary["NroDocumento"] as? String ?? ""
        unit.Rol = dictionary["Rol"] as? String ?? ""
        unit.Sexo = dictionary["Sexo"] as? String ?? ""
        unit.Tipo_Autenticacion = dictionary["Tipo_Autenticacion"] as? String ?? ""
        return unit
    }*/
    
    /*static func toArrayMuroElement(_ dictionary: NSDictionary) -> [MuroElement] {
        var array: [MuroElement] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            var data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = MuroElement()
                unit.Codigo = data[i]["Codigo"] as? String ?? ""
                unit.Tipo = data[i]["Tipo"] as? String ?? ""
                unit.Area = data[i]["Area"] as? String ?? ""
                unit.NivelR = data[i]["NivelR"] as? String ?? ""
                unit.Fecha = data[i]["Fecha"] as? String ?? ""
                unit.ObsPor = data[i]["ObsPor"] as? String ?? ""
                unit.Comentarios = data[i]["Comentarios"] as? Int ?? 0
                unit.Editable = data[i]["Editable"] as? Bool ?? false
                unit.Obs = data[i]["Obs"] as? String ?? ""
                unit.UrlPrew = data[i]["UrlPrew"] as? String ?? ""
                unit.UrlObs = data[i]["UrlObs"] as? String ?? ""
                unit.Estado = data[i]["Estado"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toObsGeneralData(_ dictionary: NSDictionary) -> ObservacionGD {
        let unit = ObservacionGD()
        unit.CodObservacion = dictionary["CodObservacion"] as? String ?? ""
        unit.CodAreaHSEC = dictionary["CodAreaHSEC"] as? String ?? ""
        unit.CodNivelRiesgo = dictionary["CodNivelRiesgo"] as? String ?? ""
        unit.ObservadoPor = dictionary["ObservadoPor"] as? String ?? ""
        unit.Fecha = dictionary["Fecha"] as? String ?? ""
        unit.Gerencia = dictionary["Gerencia"] as? String ?? ""
        unit.Superint = dictionary["Superint"] as? String ?? ""
        unit.CodUbicacion = dictionary["CodUbicacion"] as? String ?? ""
        unit.Lugar = dictionary["Lugar"] as? String ?? ""
        unit.CodTipo = dictionary["CodTipo"] as? String ?? ""
        return unit
    }
    
    static func toArrayMultimedia(_ dictionary: NSDictionary) -> [Multimedia] {
        var array: [Multimedia] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Multimedia()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = data[i]["TipoArchivo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayMultimedia(_ dictionary: NSDictionary) -> [FotoVideo] {
        var array: [FotoVideo] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = FotoVideo()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = data[i]["TipoArchivo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                unit.esVideo = unit.TipoArchivo == "TP02"
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayMultimediaYDocumentos(_ dictionary: NSDictionary) -> (multimedia: [FotoVideo], documentos: [DocumentoGeneral]) {
        var multimedia: [FotoVideo] = []
        var documentos: [DocumentoGeneral] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let tipo = data[i]["TipoArchivo"] as? String ?? ""
                switch tipo {
                case "TP01": // imagen
                    let unit = FotoVideo()
                    unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                    unit.Url = data[i]["Url"] as? String ?? ""
                    unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                    unit.TipoArchivo = tipo
                    unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                    unit.esVideo = false
                    multimedia.append(unit)
                case "TP02": // video
                    let unit = FotoVideo()
                    unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                    unit.Url = data[i]["Url"] as? String ?? ""
                    unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                    unit.TipoArchivo = tipo
                    unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                    unit.esVideo = true
                    multimedia.append(unit)
                case "TP03": // documento
                    let unit = DocumentoGeneral()
                    unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                    unit.Url = data[i]["Url"] as? String ?? ""
                    unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                    unit.TipoArchivo = tipo
                    unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                    documentos.append(unit)
                default:
                    break
                }
            }
        }
        return (multimedia, documentos)
    }
    
    static func toArrayObsPlanAccion(_ dictionary: NSDictionary) -> [ObsPlanAccion] {
        var array: [ObsPlanAccion] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = ObsPlanAccion()
                unit.CodAccion = data[i]["CodAccion"] as? String ?? ""
                unit.NroDocReferencia = data[i]["NroDocReferencia"] as? String ?? ""
                unit.CodAreaHSEC = data[i]["CodAreaHSEC"] as? String ?? ""
                unit.CodNivelRiesgo = data[i]["CodNivelRiesgo"] as? String ?? ""
                unit.DesPlanAccion = data[i]["DesPlanAccion"] as? String ?? ""
                unit.FechaSolicitud = data[i]["FechaSolicitud"] as? String ?? ""
                unit.CodEstadoAccion = data[i]["CodEstadoAccion"] as? String ?? ""
                unit.CodSolicitadoPor = data[i]["CodSolicitadoPor"] as? String ?? ""
                unit.CodResponsable = data[i]["CodResponsable"] as? String ?? ""
                unit.CodActiRelacionada = data[i]["CodActiRelacionada"] as? String ?? ""
                unit.CodReferencia = data[i]["CodReferencia"] as? String ?? ""
                unit.CodTipoAccion = data[i]["CodTipoAccion"] as? String ?? ""
                unit.FecComprometidaInicial = data[i]["FecComprometidaInicial"] as? String ?? ""
                unit.FecComprometidaFinal = data[i]["FecComprometidaFinal"] as? String ?? ""
                unit.CodResponsables = data[i]["CodResponsables"] as? String ?? ""
                unit.Responsables = data[i]["Responsables"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayObsComentario(_ dictionary: NSDictionary) -> [Comentario] {
        var array: [Comentario] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Comentario()
                unit.CodComentario = data[i]["CodComentario"] as? String ?? ""
                unit.Nombres = data[i]["Nombres"] as? String ?? ""
                unit.Comentario = data[i]["Comentario"] as? String ?? ""
                unit.Fecha = data[i]["Fecha"] as? String ?? ""
                unit.Estado = data[i]["Estado"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayPersona(_ dictionary: NSDictionary) -> [Persona] {
        var array: [Persona] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Persona()
                unit.CodPersona = data[i]["CodPersona"] as? String ?? ""
                unit.Email = data[i]["Email"] as? String ?? ""
                unit.Nombres = data[i]["Nombres"] as? String ?? ""
                unit.NroDocumento = data[i]["NroDocumento"] as? String ?? ""
                unit.Cargo = data[i]["Cargo"] as? String ?? ""
                unit.Estado = data[i]["Estado"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayMaestro(_ dictionary: NSDictionary) -> [Maestro] {
        var array: [Maestro] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Maestro()
                unit.CodTipo = data[i]["CodTipo"] as? String ?? ""
                unit.Codigo = data[i]["Codigo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toInspeccionGD(_ dictionary: NSDictionary) -> InspeccionGD {
        let unit = InspeccionGD()
        unit.CodInspeccion = dictionary["CodInspeccion"] as? String ?? ""
        unit.CodTipo = dictionary["CodTipo"] as? String ?? ""
        unit.CodContrata = dictionary["CodContrata"] as? String ?? ""
        unit.FechaP = dictionary["FechaP"] as? String ?? ""
        unit.Fecha = dictionary["Fecha"] as? String ?? ""
        unit.Gerencia = dictionary["Gerencia"] as? String ?? ""
        unit.SuperInt = dictionary["SuperInt"] as? String ?? ""
        unit.CodUbicacion = dictionary["CodUbicacion"] as? String ?? ""
        unit.CodSubUbicacion = dictionary["CodSubUbicacion"] as? String ?? ""
        unit.EquipoInspeccion = dictionary["EquipoInspeccion"] as? String ?? ""
        unit.PersonasAtendidas = dictionary["PersonasAtendidas"] as? String ?? ""
        return unit
    }
    
    static func toNoticia(_ dictionary: NSDictionary) -> Noticia {
        let unit = Noticia()
        unit.CodNoticia = dictionary["CodNoticia"] as? String ?? ""
        unit.Titulo = dictionary["Titulo"] as? String ?? ""
        unit.Tipo = dictionary["Tipo"] as? String ?? ""
        unit.Descripcion = dictionary["Descripcion"] as? String ?? ""
        unit.Autor = dictionary["Autor"] as? String ?? ""
        unit.Fecha = dictionary["Fecha"] as? String ?? ""
        return unit
    }
    
    static func toArrayInsObservacion(_ dictionary: NSDictionary) -> [InsObservacion] {
        var array: [InsObservacion] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = InsObservacion()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.CodInspeccion = data[i]["CodInspeccion"] as? String ?? ""
                unit.CodNivelRiesgo = data[i]["CodNivelRiesgo"] as? String ?? ""
                unit.Observacion = data[i]["Observacion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toInsObservacionGD(_ dictionary: NSDictionary) -> InsObservacionGD {
        let unit = InsObservacionGD()
        unit.Correlativo = dictionary["Correlativo"] as? String ?? ""
        unit.CodInspeccion = dictionary["CodInspeccion"] as? String ?? ""
        unit.NroDetInspeccion = "\(dictionary["NroDetInspeccion"] as? Int ?? -1 )"
        unit.Lugar = dictionary["Lugar"] as? String ?? ""
        unit.CodUbicacion = dictionary["CodUbicacion"] as? String ?? ""
        unit.CodAspectoObs = dictionary["CodAspectoObs"] as? String ?? ""
        unit.CodActividadRel = dictionary["CodActividadRel"] as? String ?? ""
        unit.CodNivelRiesgo = dictionary["CodNivelRiesgo"] as? String ?? ""
        unit.Observacion = dictionary["Observacion"] as? String ?? ""
        unit.Estado = dictionary["Estado"] as? String ?? ""
        return unit
    }
    
    static func toArrayCapacitacion(_ dictionary: NSDictionary) -> [Capacitacion] {
        var array: [Capacitacion] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Capacitacion()
                if let nota = data[i]["Nota"] as? Int {
                    unit.Nota = "\(nota)"
                } else {
                    unit.Nota = "null"
                }
                unit.Fecha = data[i]["Fecha"] as? String ?? ""
                unit.Duracion = data[i]["Duracion"] as? String ?? ""
                unit.Cumplido = data[i]["Cumplido"] as? String ?? ""
                unit.Estado = data[i]["Estado"] as? String ?? ""
                //unit.Nota = "\(data[i]["Nota"] as? Int ?? -1 )"
                unit.Tema = data[i]["Tema"] as? String ?? ""
                unit.Tipo = data[i]["Tipo"] as? String ?? ""
                unit.Vencimiento = data[i]["Vencimiento"] as? String ?? ""
                
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayEstadisticaGral(_ dictionary: NSDictionary) -> [EstadisticaGral] {
        var array: [EstadisticaGral] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = EstadisticaGral()
                if let ejecutados = data[i]["Ejecutados"] as? Int {
                    unit.Ejecutados = "\(ejecutados)"
                } else {
                    unit.Ejecutados = "null"
                }
                if let estimados = data[i]["Estimados"] as? Int {
                    unit.Estimados = "\(estimados)"
                } else {
                    unit.Estimados = "null"
                }
                unit.Codigo = data[i]["Codigo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toObsDetalle(_ dictionary: NSDictionary) -> ObsDetalle {
        let unit = ObsDetalle()
        unit.CodObservacion = dictionary["CodObservacion"] as? String ?? ""
        unit.CodTipo = dictionary["CodTipo"] as? String ?? ""
        unit.Observacion = dictionary["Observacion"] as? String ?? ""
        unit.Accion = dictionary["Accion"] as? String ?? ""
        unit.CodActiRel = dictionary["CodActiRel"] as? String ?? ""
        unit.CodHHA = dictionary["CodHHA"] as? String ?? ""
        unit.CodSubEstandar = dictionary["CodSubEstandar"] as? String ?? ""
        unit.CodEstado = dictionary["CodEstado"] as? String ?? ""
        unit.CodError = dictionary["CodError"] as? String ?? ""
        return unit
    }
    
    static func toArrayObsSubDetalle(_ dictionary: NSDictionary) -> [ObsSubDetalle] {
        var array: [ObsSubDetalle] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = ObsSubDetalle()
                unit.Codigo = data[i]["Codigo"] as? String ?? ""
                unit.CodTipo = data[i]["CodTipo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toPlanAccionDetalle(_ dictionary: NSDictionary) -> PlanAccionDetalle {
        let unit = PlanAccionDetalle()
        unit.NroAccionOrigen = "nil"
        if let nroAccionOrigen = dictionary["NroAccionOrigen"] as? Int {
            unit.NroAccionOrigen = "\(nroAccionOrigen)"
        }
        unit.CodAccion = dictionary["CodAccion"] as? String ?? ""
        unit.NroDocReferencia = dictionary["NroDocReferencia"] as? String ?? ""
        unit.CodTipoObs = dictionary["CodTipoObs"] as? String ?? ""
        unit.CodSolicitadoPor = dictionary["CodSolicitadoPor"] as? String ?? ""
        unit.SolicitadoPor = dictionary["SolicitadoPor"] as? String ?? ""
        unit.CodActiRelacionada = dictionary["CodActiRelacionada"] as? String ?? ""
        unit.CodEstadoAccion = dictionary["CodEstadoAccion"] as? String ?? ""
        unit.CodNivelRiesgo = dictionary["CodNivelRiesgo"] as? String ?? ""
        unit.CodAreaHSEC = dictionary["CodAreaHSEC"] as? String ?? ""
        unit.CodReferencia = dictionary["CodReferencia"] as? String ?? ""
        unit.CodTipoAccion = dictionary["CodTipoAccion"] as? String ?? ""
        unit.FecComprometidaInicial = dictionary["FecComprometidaInicial"] as? String ?? ""
        unit.FecComprometidaFinal = dictionary["FecComprometidaFinal"] as? String ?? ""
        unit.DesPlanAccion = dictionary["DesPlanAccion"] as? String ?? ""
        unit.CodResponsables = dictionary["CodResponsables"] as? String ?? ""
        unit.Responsables = dictionary["Responsables"] as? String ?? ""
        unit.CodTabla = dictionary["CodTabla"] as? String ?? ""
        unit.FechaSolicitud = dictionary["FechaSolicitud"] as? String ?? ""
        unit.Estado = dictionary["Estado"] as? String ?? ""
        return unit
    }
    
    static func toArrayPlanAccionGeneral(_ dictionary: NSDictionary) -> [PlanAccionGeneral] {
        var array: [PlanAccionGeneral] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = PlanAccionGeneral()
                if let editable = data[i]["Editable"] as? Int {
                    unit.Editable = "\(editable)"
                } else {
                    unit.Editable = ""
                }
                unit.CodAccion = data[i]["CodAccion"] as? String ?? ""
                unit.FechaSolicitud = data[i]["FechaSolicitud"] as? String ?? ""
                unit.CodSolicitadoPor = data[i]["CodSolicitadoPor"] as? String ?? ""
                unit.SolicitadoPor = data[i]["SolicitadoPor"] as? String ?? ""
                unit.DesPlanAccion = data[i]["DesPlanAccion"] as? String ?? ""
                unit.CodEstadoAccion = data[i]["CodEstadoAccion"] as? String ?? ""
                unit.CodTabla = data[i]["CodTabla"] as? String ?? ""
                unit.CodNivelRiesgo = data[i]["CodNivelRiesgo"] as? String ?? ""
                // unit.Editable = "" // 2,
                unit.Estado = data[i]["Estado"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayEstadisticaDetalle(_ dictionary: NSDictionary) -> [EstadisticaDetalle] {
        var array: [EstadisticaDetalle] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = EstadisticaDetalle()
                unit.NroDocReferencia = data[i]["NroDocReferencia"] as? String ?? ""
                unit.Responsable = data[i]["Responsable"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                unit.Fecha = data[i]["Fecha"] as? String ?? ""
                unit.ResponsableDNI = data[i]["ResponsableDNI"] as? String ?? ""
                unit.DatosAdicionales = data[i]["DatosAdicionales"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toFacilitoDetalle(_ dictionary: NSDictionary) -> FacilitoDetalle {
        let respuesta = FacilitoDetalle()
        respuesta.CodObsFacilito = dictionary["CodObsFacilito"] as? String ?? ""
        respuesta.Tipo = dictionary["Tipo"] as? String ?? ""
        respuesta.CodPosicionGer = dictionary["CodPosicionGer"] as? String ?? ""
        respuesta.CodPosicionSup = dictionary["CodPosicionSup"] as? String ?? ""
        respuesta.UbicacionExacta = dictionary["UbicacionExacta"] as? String ?? ""
        respuesta.Observacion = dictionary["Observacion"] as? String ?? ""
        respuesta.RespAuxiliar = dictionary["RespAuxiliar"] as? String ?? ""
        respuesta.RespAuxiliarDesc = dictionary["RespAuxiliarDesc"] as? String ?? ""
        respuesta.Accion = dictionary["Accion"] as? String ?? ""
        respuesta.FecCreacion = dictionary["FecCreacion"] as? String ?? ""
        respuesta.FechaFin = dictionary["FechaFin"] as? String ?? ""
        respuesta.Persona = dictionary["Persona"] as? String ?? ""
        respuesta.Estado = dictionary["Estado"] as? String ?? ""
        return respuesta
    }
    
    static func toAccionMejoraDetalle(_ dictionary: NSDictionary) -> AccionMejoraDetalle {
        let respuesta = AccionMejoraDetalle()
        respuesta.Correlativo = "nil"
        if let temp = dictionary["Correlativo"] as? Int {
            respuesta.Correlativo = "\(temp)"
        }
        respuesta.CodAccion = dictionary["CodAccion"] as? String ?? ""
        respuesta.CodResponsable = dictionary["CodResponsable"] as? String ?? ""
        respuesta.Responsable = dictionary["Responsable"] as? String ?? ""
        respuesta.Descripcion = dictionary["Descripcion"] as? String ?? ""
        respuesta.Fecha = dictionary["Fecha"] as? String ?? ""
        respuesta.PorcentajeAvance = dictionary["PorcentajeAvance"] as? String ?? ""
        respuesta.Estado = dictionary["Estado"] as? String ?? ""
        let (multimedia, documentos) = self.toArrayMultimediaYDocumentos(dictionary["Files"] as? NSDictionary ?? [:])
        respuesta.multimedia = multimedia
        respuesta.documentos = documentos
        return respuesta
    }*/
}
