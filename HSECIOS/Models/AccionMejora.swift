class AccionMejora: Codable {
    var Correlativo = "" // 20604
    var Descripcion = ""
    var PorcentajeAvance = ""
    var Editable = ""
    var Persona = ""
    var Fecha = ""
    var UrlObs = ""
    func temp() {
        //
    }
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
