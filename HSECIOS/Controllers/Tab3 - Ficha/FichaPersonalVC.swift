import UIKit

class FichaPersonalVC: UIViewController {
    
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var opcionFiltro: UIView!
    
    let dataInLeft = ["Usuario:", "DNI:", "Sexo:", "Correo Electrónico", "Empresa", "Rol", "Área", "Tipo de Logueo:"]
    var dataInRight = ["-", "-", "-", "-", "-", "-", "-", "-"]
    var codigo = ""
    var codPersona = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Ficha", Images.minero)
        loadData(data: Utils.userData)
        self.codPersona = Utils.userData.CodPersona ?? ""
        self.opcionFiltro.isHidden = !(Utils.userData.Rol == "1" || Utils.userData.Rol == "4")
    }
    
    func printData(_ data: String){
        print(data)
    }
    
    func loadDataFromDNI(codigo: String) {
        Rest.getDataGeneral(Routes.forInfGeneral(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let userData: UserData = Dict.dataToUnit(data!)!
            // print(dict)
            // let userData = Dict.toUserData(dict)
            self.loadData(data: userData)
            self.codPersona = userData.CodPersona ?? ""
        }, error: nil)
        /*Rest.getData(Routes.forInfGeneral(codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
            print(dict)
            let userData = Dict.toUserData(dict)
            self.loadData(data: userData)
            self.codPersona = userData.CodPersona
        })*/
    }
    
    func loadData(data: UserData) {
        self.nombre.text = data.Nombres
        self.codigo = data.CodPersona ?? ""
        self.dataInRight[0] = data.Codigo_Usuario ?? "-"
        self.dataInRight[1] = data.NroDocumento ?? "-"
        self.dataInRight[2] = data.Sexo ?? "-"
        self.dataInRight[3] = data.Email ?? "-"
        self.dataInRight[4] = data.Empresa ?? "-"
        self.dataInRight[5] = data.Rol ?? "-"
        self.dataInRight[6] = data.Area ?? "-"
        self.dataInRight[7] = data.Tipo_Autenticacion ?? "-"
        
        let hijo = self.childViewControllers[0] as! TwoColumnTVC
        hijo.dataLeft = dataInLeft
        hijo.dataRight = dataInRight
        hijo.tableView.reloadData()
        if (data.NroDocumento ?? "") != "" {
            avatar.image = Images.getImageFor("A-\(data.NroDocumento ?? "")")
        }
        // Images.loadAvatarFromDNI(data.NroDocumento ?? "", avatar, true)
    }
    
    
    @IBAction func clickFiltro(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona:Persona) in
            self.loadDataFromDNI(codigo: persona.NroDocumento ?? "")
        })
    }
    
    @IBAction func clickEnMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCapacitacion" {
            let destination = segue.destination as! CapacitacionesVC
            destination.codPersona = self.codPersona
        }
        if segue.identifier == "toEstadistica" {
            let destination = segue.destination as! EstadGralVC
            destination.codPersona = self.codPersona
        }
    }
    
}
