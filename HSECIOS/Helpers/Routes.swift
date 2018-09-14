import  UIKit

class Routes {
    
    static func forCapCursoNotas( _ code: String,_ pageNo: Int, _ elemsPP: Int) -> String{
        print("\(Config.urlBase)/Capacitacion/GetParticipantesCurso?CodCurso=\(code)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)")
        return "\(Config.urlBase)/Capacitacion/GetParticipantesCurso?CodCurso=\(code)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
        
        // Capacitacion/GetParticipantesCurso?CodCurso=006849&Pagenumber=1&Elemperpage=14
    }
    
    static func forChangePass() -> String {
        return "\(Config.urlBase)/Membership/ChanguePass"
    }
    
    static func forRecoveryPass() -> String {
        return "\(Config.urlBase)/Membership/RecoveryPass"
    }
    
    static func forNotificacion(_ correlativo: String, codigoUpsert: String) -> String {
        return "\(Config.urlBase)/ObsFacilito/SendNotification/\(correlativo)-\(codigoUpsert)"
    }
    
    static func forPOSTFacAtencion() -> String {
        return "\(Config.urlBase)/ObsFacilito/PostAtencion"
    }
    
    static func forADDFacilito() -> String{
        return "\(Config.urlBase)/ObsFacilito/Post"
    }
    
    static func forPUTFacilito() -> String{
        return "\(Config.urlBase)/ObsFacilito/Post"
    }
    
    static func forADDInspeccion() -> String {
        return "\(Config.urlBase)/Inspecciones/Insertar"
    }
    
    static func forPUTInspeccion() -> String {
        return "\(Config.urlBase)/Inspecciones/Actualizar"
    }
    
    static func forADDInsObservacion() -> String {
        return "\(Config.urlBase)/Inspecciones/InsertarObservacion"
    }
    
    static func forPUTInsObservacion() -> String {
        return "\(Config.urlBase)/Inspecciones/ActualizarObservacion"
    }
    
    static func forPostPlanAccion() -> String {
        return "\(Config.urlBase)/PlanAccion/Post"
    }
    
    static func forPlanAccionDelete(_ code: String) -> String {
        return "\(Config.urlBase)/PlanAccion/Delete/\(code)"
    }
    
    static func forLogin(_ username: String, _ password: String) -> String{
        return "\(Config.urlBase)/membership/authenticate?username=\(username)&password=\(password)&domain=anyaccess"
    }
    
    static func forLogin() -> String{
        return "\(Config.urlBase)/membership/authenticate"
    }
    
    static func forUserData() -> String{
        return "\(Config.urlBase)/usuario/getdata/"
    }
    
    static func forMuro(_ pageNo: Int, _ elemsPP: Int) -> String{
        return "\(Config.urlBase)/Muro/GetMuro/\(pageNo)/\(elemsPP)"
    }
    
    static func forMuroFiltro(_ text:String, _ type:Int, _ pageNo: Int, _ elemsPP: Int) -> String{
        let newText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return "\(Config.urlBase)/Muro/Search/\(newText)/\(type)/\(pageNo)/\(elemsPP)"
    }
    
    static func forDownloadFile(_ part: String) -> String {
        return "\(Config.urlBase)\(part)"
    }
    
    static func forAvatarFromDNI(_ dni: String) -> String {
        return "\(Config.urlBase)/Media/GetAvatar/\(dni)/Carnet.jpg"
    }
    
    static func forImagePreview(_ code: String) -> String {
        return "\(Config.urlBase)/Media/GetImagePreview/\(code)/Preview.jpg"
    }
    
    static func forImageFull(_ code: String) -> String {
        return "\(Config.urlBase)/Media/GetImage/\(code)/Image.jpg"
    }
    
    // Busqueda
    static func forMuroSearchO() -> String{
        return "\(Config.urlBase)/Observaciones/FiltroObservaciones"
    }
    static func forMuroSearchI() -> String{
        return "\(Config.urlBase)/Inspecciones/FiltroInspecciones"
    }
    static func forMuroSearchN() -> String{
        return "\(Config.urlBase)/Noticia/FiltroNoticias"
    }
    // Busqueda
    static func forPostMultimedia() -> String{
        return "\(Config.urlBase)/Media/UploadAllFiles"
    }
    static func forMultimedia(_ code: String) -> String{
        return "\(Config.urlBase)/media/GetMultimedia/\(code)"
    }
    static func forComentarios(_ code: String) -> String{
        return "\(Config.urlBase)/Comentario/getObs/\(code)"
    }
    static func forPostComentario() -> String{
        return "\(Config.urlBase)/Comentario/insert"
    }
    static func forBuscarPersona(_ apellidos: String, _ nombres: String, _ dni: String, _ gerencia: String, _ superintendencia: String, _ pagina: Int, _ nroitems: Int) -> String{
        return "\(Config.urlBase)/Usuario/FiltroPersona?Filtros=\(apellidos)@\(nombres)@\(dni)@\(gerencia)@\(superintendencia)&Pagenumber=\(pagina)&Elemperpage=\(nroitems)"
    }
    
    
    // Observaciones
    static func forObservaciones(_ code: String) -> String{
        return "\(Config.urlBase)/Observaciones/Get/\(code)"
    }
    static func forPlanAccion(_ code: String) -> String{
        return "\(Config.urlBase)/PlanAccion/GetPlanes/\(code)"
    }
    static func forObsDetalle(_ code: String) -> String{
        return "\(Config.urlBase)/Observaciones/GetDetalle/\(code)"
    }
    static func forObsSubDetalle(_ code: String) -> String{
        return "\(Config.urlBase)/Observaciones/GetSubDetalle/\(code)"
    }
    static func forObsInvolucrados(_ code: String) -> String{
        return "\(Config.urlBase)/Observaciones/GetInvolucrados/\(code)"
    }
    // Observaciones
    
    // Inspecciones
    static func forInspecciones(_ code: String) -> String{
        return "\(Config.urlBase)/Inspecciones/Get/\(code)"
    }
    static func forInsEquipoInspeccion(_ code: String) -> String {
        return "\(Config.urlBase)/Inspecciones/GetEquipoInspeccion/\(code)"
    }
    static func forInsPersonasAtendidas(_ code: String) -> String {
        return "\(Config.urlBase)/Inspecciones/GetPersonasAtendidas/\(code)"
    }
    static func forInsObservaciones(_ code: String) -> String {
        return "\(Config.urlBase)/Inspecciones/GetDetalleInspeccion/\(code)"
    }
    static func forInsObservacionGD(_ code: String) -> String {
        return "\(Config.urlBase)/Inspecciones/GetDetalleInspeccionID/\(code)"
    }
    // Inspecciones
    
    // Noticias
    static func forNoticia(_ code: String) -> String {
        return "\(Config.urlBase)/Noticia/Get/\(code)"
    }
    // Noticias
    
    static func forSendFeeback() -> String {
        return "\(Config.urlBase)/Usuario/SendFeedback"
    }
    
    // Facilito
    static func forFiltroFacilito() -> String {
        return "\(Config.urlBase)/ObsFacilito/Filtro"
    }
    static func forFiltroFacilitoEstadistica(_ codPersona: String, _ year: String, _ month: String, _ pageNo: Int, _ elempp: Int) -> String {
        return "\(Config.urlBase)/ObsFacilito/GetObservacionFacFicha/\(codPersona)/\(year)%7C\(month)/\(pageNo)/\(elempp)"
    }
    static func forFacilitoDetalle(_ code: String) -> String {
        return "\(Config.urlBase)/ObsFacilito/GetObsFacilitoID/\(code)"
    }
    static func forFacilitoHistorialAtencion(_ code: String) -> String {
        return "\(Config.urlBase)/ObsFacilito/GetHistorialAtencion/\(code)"
    }
    // Facilito
    
    // Ficha Personal
    static func forInfGeneral(_ code: String) -> String{
        return "\(Config.urlBase)/FichaPersonal/InformacionGeneral?id=\(code)"
    }
    static func forCapRecibidas(_ code: String) -> String{
        return "\(Config.urlBase)/FichaPersonal/CapacitacionesRecibidas/\(code)"
    }
    static func forCapPerfil(_ code: String) -> String{
        return "\(Config.urlBase)/FichaPersonal/PerfilCapacitacion/\(code)"
    }
    static func forEstadisticaGeneral(_ code: String, _ year: String, _ month: String) -> String{
        return "\(Config.urlBase)/FichaPersonal/EstadisticasGenerales?CodPersona=\(code)&Anho=\(year)&Mes=\(month)"
    }
    static func forEstadisticaDetalle(_ code: String, _ year: String, _ month: String, _ category: String) -> String{
        return "\(Config.urlBase)/FichaPersonal/EstadisticasDetalles?Categoria=\(category)&CodPersona=\(code)&anho=\(year)&mes=\(month)"
    }
    static func forPlanAccionGeneral(_ code: String, _ year: String, _ month: String, _ pageNo: Int, _ elemsPP: Int) -> String{
        return "\(Config.urlBase)/PlanAccion/GetPlanes?CodPersonaF=\(code)&Fecha=\(year)%7C\(month)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
    }
    static func forPlanAccionDetalle(_ code: String) -> String{
        return "\(Config.urlBase)/PlanAccion/Get/\(code)"
    }
    static func forPlanesAccionPendientes(_ code: String, _ year: String, _ month: String, _ pageNo: Int, _ elemsPP: Int) -> String{
        return "\(Config.urlBase)/PlanAccion/GetPlanes?CodPersonaF=\(code)&Fecha=P\(year)%7C\(month)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
    }
    // Ficha Personal
    
    // Capacitaciones
    static func forCapacitacionGeneral(_ code: String, _ year: String, _ month: String, _ pageNo: Int, _ elemsPP: Int) -> String{
        return "\(Config.urlBase)/Capacitacion/GetCursos?CodPersonaF=\(code)&Fecha=\(year)%7C\(month)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
        
        //url = GlobalVariables.Url_base + "Capacitacion/GetCursos?CodPersonaF=*&Fecha=" + anio + "%7C"+ "&Pagenumber=" + "1" + "&Elemperpage=" + Elemperpage;
    }
    
    static func forCapCursoDetalle(_ code: String) -> String{
        return "\(Config.urlBase)/Capacitacion/GetCursoId/\(code)"
    }
    //Capacitaciones/cursos/notas
    /*static func forCapCursoNotas(_ code: String, _ pageNo: Int, _ elemsPP: Int) -> String{
        print("\(Config.urlBase)/Capacitacion/GetParticipantesCurso?CodCurso=\(code)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)")
        return "\(Config.urlBase)/Capacitacion/GetParticipantesCurso?CodCurso=\(code)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
        
        // Capacitacion/GetParticipantesCurso?CodCurso=006849&Pagenumber=1&Elemperpage=14
    }*/
    
    //notas update
    static func forNotasUpdate() -> String{
        return "\(Config.urlBase)/Capacitacion/UpdateParticipante"
    }
    // notas delete
    static func forUserDelete(_ codeP: String, _ codCurso: String) -> String{
        return "\(Config.urlBase)/Capacitacion/DeleteParticipante?CodpersonaP=\(codeP)&CodCurso=\(codCurso)"
    }
    // total de asistentes
    static func forAsistentesT(_ codeC: String, _ fecha: String, _ pageNo: Int, _ elemsPP: Int) -> String{
        return "\(Config.urlBase)/Capacitacion/GetAsistentesCurso?CodCurso=\(codeC)&Fecha=\(fecha)&Pagenumber=\(pageNo)&Elemperpage=\(elemsPP)"
    }
    
    //eliminar asistente
    static func forDeleteA(_ codeP: String, _ codeC: String, _ fecha: String) -> String{
        return "\(Config.urlBase)/Capacitacion/DeleteAsistentente?CodPersonaA=\(codeP)&CodCurso=\(codeC)&Fecha=\(fecha)"
    }
    //add asistente
    static func forAddAsistente() -> String{
        return "\(Config.urlBase)/Capacitacion/InsertAsistentente"
    }
    
    
    static func forAddParticipante() -> String{
        return "\(Config.urlBase)/Capacitacion/InsertParticipante"
    }
    
    // Varios
    static func forMaestroALL() -> String{
        return "\(Config.urlBase)/Maestro/GetTipoMaestro/ALL"
    }
    static func forAccionMejora(_ code: String) -> String {
        return "\(Config.urlBase)/AccionMejora/Get/\(code)"
    }
    static func forAccionMejoraDetalle(_ code: String) -> String {
        return "\(Config.urlBase)/AccionMejora/GetID/\(code)"
    }
    static func forAccionMejoraPutPost() -> String {
        return "\(Config.urlBase)/AccionMejora/PutPost"
    }
    static func forAccionMejoraDelete(_ code: String) -> String {
        return "\(Config.urlBase)/AccionMejora/Delete/\(code)"
    }
    // Varios
    
    // ADD-EDIT
    static func forADDPUTFacilito() -> String{
        return "\(Config.urlBase)/ObsFacilito/Insertar"
    }
    // ADD
    
}
