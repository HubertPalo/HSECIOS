class PlanAccionDetalle: Codable {
    var CodAccion: String?
    var NroDocReferencia: String?
    var CodTipoObs: String?
    var CodSolicitadoPor: String?
    var SolicitadoPor: String?
    var CodActiRelacionada: String?
    var CodEstadoAccion: String?
    var CodNivelRiesgo: String?
    var CodAreaHSEC: String?
    var CodReferencia: String?
    var CodTipoAccion: String?
    var FecComprometidaInicial: String?
    var FecComprometidaFinal: String?
    var DesPlanAccion: String?
    //var CodResponsable: String? // Solo se usa en Add Obs Plan
    //var CodTablaRef: String? // Solo se usa en Add Obs Plan
    var CodResponsables: String?
    var Responsables: String?
    var CodTabla: String?
    var NroAccionOrigen: Int?
    var FechaSolicitud: String?
    var Estado: String?
    
    func copy() -> PlanAccionDetalle {
        let duplicado = PlanAccionDetalle()
        duplicado.CodAccion = self.CodAccion
        duplicado.NroDocReferencia = self.NroDocReferencia
        duplicado.CodTipoObs = self.CodTipoObs
        duplicado.CodSolicitadoPor = self.CodSolicitadoPor
        duplicado.SolicitadoPor = self.SolicitadoPor
        duplicado.CodActiRelacionada = self.CodActiRelacionada
        duplicado.CodEstadoAccion = self.CodEstadoAccion
        duplicado.CodNivelRiesgo = self.CodNivelRiesgo
        duplicado.CodAreaHSEC = self.CodAreaHSEC
        duplicado.CodReferencia = self.CodReferencia
        duplicado.CodTipoAccion = self.CodTipoAccion
        duplicado.FecComprometidaInicial = self.FecComprometidaInicial
        duplicado.FecComprometidaFinal = self.FecComprometidaFinal
        duplicado.DesPlanAccion = self.DesPlanAccion
        //duplicado.CodResponsable = self.CodResponsable
        //duplicado.CodTablaRef = self.CodTablaRef
        duplicado.CodResponsables = self.CodResponsables
        duplicado.Responsables = self.Responsables
        duplicado.CodTabla = self.CodTabla
        duplicado.NroAccionOrigen = self.NroAccionOrigen
        duplicado.FechaSolicitud = self.FechaSolicitud
        duplicado.Estado = self.Estado
        return duplicado
    }
}
