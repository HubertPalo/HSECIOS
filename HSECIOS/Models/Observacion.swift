class ObservacionGD: Codable {
    var CodObservacion: String?
    var CodAreaHSEC: String?
    var CodNivelRiesgo: String?
    var ObservadoPor: String?
    var CodObservadoPor: String?
    var Fecha: String?
    var Gerencia: String?
    var Superint: String?
    var CodUbicacion: String?
    var Lugar: String?
    var CodTipo: String?
    var FechaInicio: String?
    var FechaFin: String?
}

class ObsDetalle: Codable {
    var CodObservacion: String?
    var CodTipo: String?
    var Observacion: String?
    var Accion: String?
    var CodActiRel: String?
    var CodHHA: String?
    var CodSubEstandar: String?
    var CodEstado: String?
    var CodError: String?
}

class ObsSubDetalle: Codable {
    var Codigo: String?
    var CodTipo: String?
    var CodSubTipo: String?
    var Descripcion: String?
}
