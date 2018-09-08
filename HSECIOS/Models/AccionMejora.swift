class AccionMejora: Codable {
    var Correlativo: Int?
    var Descripcion: String?
    var PorcentajeAvance: String?
    var Editable: String?
    var Persona: String?
    var Fecha: String?
    var UrlObs: String?
}

class AccionMejoraDetalle: Codable {
    var Correlativo = ""
    var CodAccion = ""
    var CodResponsable = ""
    var Responsable = ""
    var Descripcion = ""
    var Fecha = ""
    var PorcentajeAvance = ""
    var Estado = ""
    var multimedia: [FotoVideo] = []
    var documentos: [DocumentoGeneral] = []
}

class AccionMejoraAtencion: Codable {
    var Correlativo: Int?
    var CodAccion: String?
    var CodResponsable: String?
    var Responsable: String?
    var Descripcion: String?
    var Fecha: String?
    var PorcentajeAvance: String?
    var Estado: String?
    var Files: ArrayGeneral<Multimedia>?
    
    func copy() -> AccionMejoraAtencion {
        let copia = AccionMejoraAtencion()
        copia.Correlativo = self.Correlativo
        copia.CodAccion = self.CodAccion
        copia.CodResponsable = self.CodResponsable
        copia.Responsable = self.Responsable
        copia.Descripcion = self.Descripcion
        copia.Fecha = self.Fecha
        copia.PorcentajeAvance = self.PorcentajeAvance
        copia.Estado = self.Estado
        copia.Files = self.Files
        return copia
    }
}
