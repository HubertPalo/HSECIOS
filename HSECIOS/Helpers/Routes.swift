import  UIKit

class Routes {
    
    static func forLogin(_ username: String, _ password: String) -> String{
        return "\(Config.urlBase)/membership/authenticate?username=\(username)&password=\(password)&domain=anyaccess"
    }
    
    static func forUserData() -> String{
        return "\(Config.urlBase)/usuario/getdata/"
    }
    
    static func forMuro(_ cant: Int) -> String{
        return "\(Config.urlBase)/Muro/GetMuro/1/\(cant)"
    }
    
    static func forDownloadFile(_ part: String) -> String {
        return "\(Config.urlBase)\(part)"
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
    
    static func forMultimedia(_ code: String) -> String{
        return "\(Config.urlBase)/media/GetMultimedia/\(code)"
    }
    static func forComentarios(_ code: String) -> String{
        return "\(Config.urlBase)/Comentario/getObs/\(code)"
    }
    static func forPostComentario() -> String{
        return "\(Config.urlBase)/Comentario/insert"
    }
    static func forBuscarPersona(_ apellidos: String, _ nombres: String, _ dni: String, _ gerencia: String, _ superintendencia: String, _ nroitems: Int) -> String{
        return "\(Config.urlBase)/Usuario/FiltroPersona/\(apellidos)@\(nombres)@\(dni)@\(gerencia)@\(superintendencia)/1/\(nroitems)"
    }
    
    
    // Observaciones
    static func forObservaciones(_ code: String) -> String{
        return "\(Config.urlBase)/Observaciones/Get/\(code)"
    }
    static func forObsPlanAccion(_ code: String) -> String{
        return "\(Config.urlBase)/PlanAccion/GetPlanes/\(code)"
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
    // Varios
    
    // Varios
}
