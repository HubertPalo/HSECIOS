import UIKit
class Dict {
    
    static func toArrayMuroElement(_ dictionary: NSDictionary) -> [MuroElement] {
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
    
    static func extractUserData(_ dictionary: NSDictionary) {
        UserInfo.Avatar = dictionary["Avatar"] as? String ?? ""
        
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
    
    static func toArrayObsMultimedia(_ dictionary: NSDictionary) -> [ObsMultimedia] {
        var array: [ObsMultimedia] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = ObsMultimedia()
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Urlmin = data[i]["Urlmin"] as? String ?? ""
                unit.TipoArchivo = data[i]["TipoArchivo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        return array
    }
    
    static func toArrayMultimedia(_ dictionary: NSDictionary) -> [Multimedia] {
        var array: [Multimedia] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = Multimedia()
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = data[i]["TipoArchivo"] as? String ?? ""
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                array.append(unit)
            }
        }
        print(array)
        return array
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
    
    static func toArrayObsComentario(_ dictionary: NSDictionary) -> [ObsComentario] {
        var array: [ObsComentario] = []
        let count = dictionary["Count"] as? Int ?? 0
        if count > 0 {
            let data = dictionary["Data"] as? [NSDictionary] ?? []
            for i in 0..<data.count {
                let unit = ObsComentario()
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
                unit.CodSubTipo = data[i]["CodSubTipo"] as? String ?? ""
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
        unit.CodUbicacion = dictionary["CodUbicacion"] as? String ?? ""
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
    
}
