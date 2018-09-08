class CapCursoGeneral: Codable {
    var CodCurso: String?
    var CodTema: String?
    var Tipo: String?
    var Empresa: String?
    var Duracion: Int?
    var Fecha: String?
    var Recurrence: String?
    var Estado: String?
}

class Curso: Codable {
    var CodCurso: String?
    var Empresa: String?
    var CodTema: String?
    var Capacidad: String?
    var Tipo: String?
    var Area: String?
    var Lugar: String?
    var Fecha: String?
    var Duracion: Int?
    var PuntajeTotal: String?
    var PuntajeP: String?
    var Vigencia: String?
    var Expositores: String?
}
