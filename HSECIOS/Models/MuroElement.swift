class MuroElement: Codable {
    var Codigo: String?
    var Tipo: String?
    var Area: String?
    var NivelR: String?
    var Fecha: String?
    var ObsPor: String?
    var Comentarios: Int?
    var Editable: String?
    var Obs: String?
    var UrlPrew: String?
    var UrlObs: String?
    var Empresa: String?
    var Estado: String?
    
    func toFacilito() -> FacilitoElement {
        let unit = FacilitoElement()
        /*var Codigo: String?
        var Tipo: String?
        var Area: String?
        var NivelR: String?
        var Fecha: String?
        var ObsPor: String?
        var Comentarios: Int?
        var Editable: String?
        var Obs: String?
        var UrlPrew: String?
        var UrlObs: String?
        var Empresa: String?
        var Estado: String?*/
        
        unit.CodObsFacilito = self.Codigo
        unit.Tipo = self.Tipo
        unit.Observacion = self.Obs
        unit.Estado = self.NivelR
        unit.Empresa = self.Empresa
        unit.Editable = self.Editable
        unit.Total = self.Estado
        unit.Persona = self.ObsPor
        unit.Fecha = self.Fecha
        unit.FechaFin = nil
        unit.UrlPrew = self.UrlPrew
        unit.UrlObs = self.UrlObs
        unit.TiempoDiffMin = nil
        return unit
    }
}
