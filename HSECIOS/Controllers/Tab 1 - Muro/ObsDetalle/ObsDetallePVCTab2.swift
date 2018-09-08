import UIKit

class ObsDetallePVCTab2: UIViewController {
    
    @IBOutlet weak var containerTP01: UIView!
    @IBOutlet weak var containerTP02: UIView!
    @IBOutlet weak var containerTP03: UIView!
    @IBOutlet weak var containerTP04: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
        
    }
    
    // var observacion = MuroElement()
    // var hijo = ObsDetalleTVC()
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(1)
        }
        // let hijo = self.childViewControllers[0] as! ObsDetalleTVC
        /*Rest.getDataGeneral(Routes.forObsDetalle(observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            hijo.obsDetalle = Dict.dataToUnit(data!)!
            hijo.observacion = self.observacion
            hijo.reloadValues()
            if self.observacion.Tipo == "TO03" || self.observacion.Tipo == "TO04" {
                Rest.getDataGeneral(Routes.forObsSubDetalle(self.observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
                    let arrayObsSubDetalle: ArrayGeneral<ObsSubDetalle> = Dict.dataToArray(data!)
                    hijo.obsSubDetalle = arrayObsSubDetalle.Data
                    hijo.reloadValues()
                }, error: nil)
                Rest.getDataGeneral(Routes.forObsInvolucrados(self.observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
                    let arrayInvolucrados: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                    hijo.obsInvolucrados = arrayInvolucrados.Data
                    hijo.reloadValues()
                }, error: nil)
            }
        }, error: nil)*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.hijo = self.childViewControllers[0] as! ObsDetalleTVC
    }
    
    func reloadData() {
        containerTP01?.isHidden = Globals.UOTab1ObsGD.CodTipo ?? "" != "TO01"
        containerTP02?.isHidden = Globals.UOTab1ObsGD.CodTipo ?? "" != "TO02"
        containerTP03?.isHidden = Globals.UOTab1ObsGD.CodTipo ?? "" != "TO03"
        containerTP04?.isHidden = Globals.UOTab1ObsGD.CodTipo ?? "" != "TO04"
        /* self.hijo.obsDetalle = Globals.UOTab2ObsDetalle
        self.hijo.obsSubDetalle = Globals.UOTab2ObsSubDetalle
        self.hijo.obsInvolucrados = Globals.UOTab2Involucrados
        self.hijo.reloadValues()
        self.hijo.tableView.reloadData()*/
    }
}
