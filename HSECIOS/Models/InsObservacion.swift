class InsObservacion: Codable {
    var Correlativo: Int?
    var CodInspeccion: String?
    var CodNivelRiesgo: String?
    var Observacion: String?
}

class InsObservacionGD: Codable {
    var Correlativo: Int?
    var CodInspeccion: String?
    var NroDetInspeccion: Int?
    var Lugar: String?
    var CodUbicacion: String?
    var CodAspectoObs: String?
    var CodActividadRel: String?
    var CodNivelRiesgo: String?
    var Observacion: String?
    var Estado: String?
    
    /*init() {
        self.Correlativo = nil
        self.CodInspeccion = nil
        self.NroDetInspeccion = nil
        self.Lugar = nil
        self.CodUbicacion = nil
        self.CodAspectoObs = nil
        self.CodActividadRel = nil
        self.Observacion = nil
        self.Estado = nil
    }
    
    init(Correlativo: Int?, CodInspeccion: String?, NroDetInspeccion: Int?, Lugar: String?, CodUbicacion: String?, CodAspectoObs: String?, CodActividadRel: String?, CodNivelRiesgo: String?, Observacion: String?, Estado: String?) {
        self.Correlativo = Correlativo
        self.CodInspeccion = CodInspeccion
        self.NroDetInspeccion = NroDetInspeccion
        self.Lugar = Lugar
        self.CodUbicacion = CodUbicacion
        self.CodAspectoObs = CodAspectoObs
        self.CodActividadRel = CodActividadRel
        self.Observacion = Observacion
        self.Estado = Estado
    }*/
    
    func copy() -> InsObservacionGD {
        let copia = InsObservacionGD()
        copia.Correlativo = self.Correlativo
        copia.CodInspeccion = self.CodInspeccion
        copia.NroDetInspeccion = self.NroDetInspeccion
        copia.Lugar = self.Lugar
        copia.CodUbicacion = self.CodUbicacion
        copia.CodAspectoObs = self.CodAspectoObs
        copia.CodActividadRel = self.CodActividadRel
        copia.Observacion = self.Observacion
        copia.Estado = self.Estado
        return copia
        //return InsObservacionGD(Correlativo: self.Correlativo, CodInspeccion: self.CodInspeccion, NroDetInspeccion: self.NroDetInspeccion, Lugar: self.Lugar, CodUbicacion: self.CodUbicacion, CodAspectoObs: self.CodAspectoObs, CodActividadRel: self.CodActividadRel, CodNivelRiesgo: self.CodNivelRiesgo, Observacion: self.Observacion, Estado: self.Estado)
    }
}
