import UIKit

class VCHelper {
    static var filtroMuro = UIViewController()
    static var filtroPersona = UIViewController()
    static var filtroPersonas = UIViewController()
    static var filtroObservacion = UIViewController()
    static var filtroInspeccion = UIViewController()
    static var filtroNoticia = UIViewController()
    static var filtroContrata = UIViewController()
    static var agregarInspeccion = UIViewController()
    static var agregarInsObservacion = UIViewController()
    static var agregarObsPlanAccion = UIViewController()
    static var obsDetalle = UIViewController()
    static var insDetalle = UIViewController()
    static var insObsDetalle = UIViewController()
    static var facDetalle = UIViewController()
    static var notDetalle = UIViewController()
    static var facDetalleAtencion = UIViewController()
    static var planAccionDetalle = UIViewController()
    static var planAccionMejora = UIViewController()
    static var upsertFacilito = UIViewController()
    static var upsertObsPlan = UIViewController()
    static var upsertObservacion = UIViewController()
    
    static func initVCs() {
        self.filtroMuro = Utils.mainSB.instantiateViewController(withIdentifier: "muroFiltro")
        self.filtroPersona = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroPersona")
        self.filtroPersonas = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroPersonas")
        self.filtroObservacion = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroObservacion")
        self.filtroInspeccion = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroInspeccion")
        self.filtroNoticia = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroNoticia")
        self.filtroContrata = Utils.utilsSB.instantiateViewController(withIdentifier: "filtroContrata")
        self.agregarInspeccion = Utils.addInspeccionSB.instantiateViewController(withIdentifier: "addInspeccion")
        self.agregarInsObservacion = Utils.addInsObsSB.instantiateViewController(withIdentifier: "addInsObs")
        self.agregarObsPlanAccion = Utils.utilsSB.instantiateViewController(withIdentifier: "AddPutObsPlanAccion")
        self.obsDetalle = Utils.obsDetalleSB.instantiateViewController(withIdentifier: "obsDetalle")
        self.insDetalle = Utils.insDetalleSB.instantiateViewController(withIdentifier: "insDetalle")
        self.insObsDetalle = Utils.insObsDetalleSB.instantiateViewController(withIdentifier: "insObsDetalle")
        self.notDetalle = Utils.notDetalleSB.instantiateViewController(withIdentifier: "notDetalle")
        self.facDetalle = Utils.facDetalleSB.instantiateViewController(withIdentifier: "facDetalle")
        self.facDetalleAtencion = Utils.facDetalleSB.instantiateViewController(withIdentifier: "facDetalleAtencion")
        self.planAccionDetalle = Utils.planAccionSB.instantiateViewController(withIdentifier: "planAccionDetalle")
        self.planAccionMejora = Utils.planAccionSB.instantiateViewController(withIdentifier: "planAccionMejora")
        self.upsertFacilito = Utils.facDetalleSB.instantiateViewController(withIdentifier: "upsertFacilito")
        self.upsertObsPlan = Utils.addObservacionSB.instantiateViewController(withIdentifier: "upsertObsPlan")
        self.upsertObservacion = Utils.addObservacionSB.instantiateViewController(withIdentifier: "upsertObservacion")
    }
    
    static func openUpsertObservacion(_ viewcontroller: UIViewController, _ modo: String, _ codigo: String) {
        let vc = self.upsertObservacion as! UpsertObsVC
        Globals.UOloadModo(modo, codigo)
        // vc.loadModo(modo, codigo)
        /*(Tabs.forAddObs[0] as! UpsertObsPVCTab1).loadModo(modo, codigo)
        (Tabs.forAddObs[1] as! UpsertObsPVCTab2).loadModo(modo, codigo)
        (Tabs.forAddObs[2] as! UpsertObsPVCTab3).loadModo(modo, codigo)*/
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openUpsertObsPlan(_ viewcontroller: UIViewController, _ modo: Int, _ plan: PlanAccionDetalle, _ element: MuroElement, _ alTerminar: ((_ plan: PlanAccionDetalle) -> Void)?) {
        let vc = self.upsertObsPlan as! UpsertObsPlanTVC
        plan.FechaSolicitud = Utils.date2str(Date(), "YYYY-MM-dd")
        plan.SolicitadoPor = Utils.userData.Nombres
        plan.CodSolicitadoPor = Utils.userData.CodPersona
        vc.loadModo(modo, plan, element, alTerminar)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openUpsertFacilito(_ viewcontroller: UIViewController, _ modo: String, _ codigo: String) {
        let vc = self.upsertFacilito as! FacilitoUpsertTVC
        vc.loadModo(modo, codigo)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openFiltroPersona(_ viewcontroller: UIViewController, _ alSeleccionarPersona: @escaping (_ persona:Persona)-> Void) {
        let filtroVC = self.filtroPersona as! FiltroPersonaVC
        filtroVC.alSeleccionarPersona = alSeleccionarPersona
        filtroVC.cleanData()
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    static func openFiltroPersonas(_ viewcontroller: UIViewController, _ alSeleccionarPersonas: @escaping (_ personas:[Persona])-> Void) {
        let filtroVC = self.filtroPersonas as! FiltroPersonasVC
        filtroVC.alSeleccionarPersonas = alSeleccionarPersonas
        filtroVC.cleanData()
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openFiltroObservacion(_ viewcontroller: UIViewController, _ alBuscarObservacion: @escaping (_ data:[String:String])-> Void) {
        let filtroVC = self.filtroObservacion as! FiltroObservacionVC
        filtroVC.alFiltrar = alBuscarObservacion
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openFiltroNoticia(_ viewcontroller: UIViewController, _ alBuscarNoticia: @escaping (_ data:[String:String])-> Void) {
        let filtroVC = self.filtroNoticia as! FiltroNoticiaVC
        filtroVC.cleanData()
        filtroVC.alClickOK = alBuscarNoticia
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openFiltroInspeccion(_ viewcontroller: UIViewController, _ alBuscarInspeccion: @escaping (_ data:[String:String])-> Void) {
        let filtroVC = self.filtroInspeccion as! FiltroInspeccionVC
        filtroVC.alFiltrar = alBuscarInspeccion
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openAddInspeccion(_ viewcontroller: UIViewController)-> Void {
        let agregarVC = self.agregarInspeccion as! AddInspeccionVC
        viewcontroller.navigationController?.pushViewController(agregarVC, animated: true)
    }
    
    static func openAddInsObservacion(_ viewcontroller: UIViewController)-> Void {
        let agregarVC = self.agregarInsObservacion as! AddInsObservacionVC
        viewcontroller.navigationController?.pushViewController(agregarVC, animated: true)
    }
    
    static func openAddObsPlanAccion(_ viewcontroller: UIViewController)-> Void {
        let agregarVC = self.agregarObsPlanAccion as! AddPutObsPlATVC
        viewcontroller.navigationController?.pushViewController(agregarVC, animated: true)
    }
    
    static func openFiltroContrata(_ viewcontroller: UIViewController, _ alBuscarContrata: @escaping (_ nombre:String, _ codigo:String)-> Void)-> Void {
        let filtroVC = self.filtroContrata as! FiltroContrataVC
        filtroVC.limpiarData()
        filtroVC.alSeleccionarCelda = alBuscarContrata
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openFiltroMuro(_ viewcontroller: UIViewController, _ tipo: String) {
        let filtroVC = self.filtroMuro as! MuroFiltroVC
        filtroVC.loadTipo(tipo)
        viewcontroller.navigationController?.pushViewController(filtroVC, animated: true)
    }
    
    static func openObsDetalle(_ viewcontroller: UIViewController, _ observacion: MuroElement) {
        let vc = self.obsDetalle as! ObsDetalleVC
        vc.observacion = observacion
        Tabs.indexObsDetalle = 0
        (Tabs.forObsDetalle[0] as! ObsDetallePVCTab1).loadObservacion(observacion)
        (Tabs.forObsDetalle[1] as! ObsDetallePVCTab2).observacion = observacion
        (Tabs.forObsDetalle[2] as! ObsDetallePVCTab3).observacion = observacion
        (Tabs.forObsDetalle[3] as! ObsDetallePVCTab4).observacion = observacion
        (Tabs.forObsDetalle[4] as! ObsDetallePVCTab5).observacion = observacion
        
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openInsDetalle(_ viewcontroller: UIViewController, _ inspeccion: MuroElement) {
        let vc = self.insDetalle as! InsDetalleVC
        vc.inspeccion = inspeccion
        Tabs.indexInsDetalle = 0
        (Tabs.forInsDetalle[0] as! InsDetallePVCTab1).inspeccion = inspeccion
        (Tabs.forInsDetalle[1] as! InsDetallePVCTab2).inspeccion = inspeccion
        (Tabs.forInsDetalle[2] as! InsDetallePVCTab3).inspeccion = inspeccion
        (Tabs.forInsDetalle[3] as! InsDetallePVCTab4).inspeccion = inspeccion
        
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openInsObsDetalle(_ viewcontroller: UIViewController, _ insObs: InsObservacion) {
        let vc = self.insObsDetalle as! InsObservacionVC
        print("\(insObs.CodInspeccion) - \(insObs.Correlativo)")
        (Tabs.forInsObservacion[0] as! InsObservacionPVCTab1).insObservacion = insObs
        (Tabs.forInsObservacion[1] as! InsObservacionPVCTab2).insObs = insObs
        (Tabs.forInsObservacion[2] as! InsObservacionPVCTab3).insObs = insObs
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openNotDetalle(_ viewcontroller: UIViewController, _ noticia: MuroElement) {
        let vc = self.notDetalle as! NotDetalleVC
        vc.loadNoticia(noticia)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openFacilitoDetalle(_ viewcontroller: UIViewController, _ facilito: FacilitoElement) {
        let vc = self.facDetalle as! FacDetalleTVC
        vc.cleanData()
        vc.loadFacilito(facilito)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openFacilitoDetalleAtencion(_ viewcontroller: UIViewController, _ atencion: HistorialAtencionElement, _ facilito: FacilitoElement, _ editable: Bool) {
        let vc = self.facDetalleAtencion as! FacDetalleAtencionTVC
        vc.cleanData()
        vc.loadAtencion(atencion, facilito, editable)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openPlanAccionDetalle(_ viewcontroller: UIViewController, _ plan: PlanAccionGeneral) {
        let vc = self.planAccionDetalle as! PlanAccionDetalleTVC
        vc.cleanData()
        vc.loadData(plan)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    static func openPlanAccionDetalle(_ viewcontroller: UIViewController, _ plan: PlanAccionDetalle) {
        let vc = self.planAccionDetalle as! PlanAccionDetalleTVC
        vc.cleanData()
        vc.loadData(plan)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openGetPlanAccionMejora(_ viewcontroller: UIViewController, _ accion: AccionMejora, _ codPlanAccion: String, _ responsable: Persona) {
        let vc = self.planAccionMejora as! PlanAccionMejoraTVC
        vc.cleanData()
        vc.loadData("GET", accion, codPlanAccion, [responsable])
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openAddPlanAccionMejora(_ viewcontroller: UIViewController, _ codPlanAccion: String, _ responsables: [Persona]) {
        let vc = self.planAccionMejora as! PlanAccionMejoraTVC
        vc.cleanData()
        vc.loadData("ADD", AccionMejora(), codPlanAccion, responsables)
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func openPutPlanAccionMejora(_ viewcontroller: UIViewController, _ codPlanAccion: String, _ accion: AccionMejora, _ tipo: String) {
        let vc = self.planAccionMejora as! PlanAccionMejoraTVC
        vc.cleanData()
        vc.loadData(tipo, accion, codPlanAccion, [])
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*static func openPlanAccionMejora(_ viewcontroller: UIViewController, _ accion: AccionMejora, _ tipo: String) {
        let vc = self.planAccionMejora as! PlanAccionMejoraTVC
        vc.cleanData()
        vc.loadData(tipo, accion, [])
        viewcontroller.navigationController?.pushViewController(vc, animated: true)
    }*/
    
}
