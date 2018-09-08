import UIKit

class FiltroPersonaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var viewToHide: UIView!
    @IBOutlet weak var campoApellidos: UITextField!
    @IBOutlet weak var campoNombres: UITextField!
    @IBOutlet weak var campoDNI: UITextField!
    @IBOutlet weak var campoGerencia: UIButton!
    @IBOutlet weak var campoSuperintendencia: UIButton!
    
    var nroitems = 10
    var personas: [Persona] = []
    var inputs:[String] = ["","","","",""]
    
    var alSeleccionarPersona: ((_ persona: Persona) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Búsqueda persona", Images.user)
        tabla.delegate = self
        tabla.dataSource = self
        campoApellidos.delegate = self
        campoNombres.delegate = self
        campoDNI.delegate = self
    }
    
    func cleanData() {
        self.personas = []
        self.inputs = ["","","","",""]
        self.campoApellidos?.text = ""
        self.campoNombres?.text = ""
        self.campoDNI?.text = ""
        self.campoGerencia?.setTitle("-", for: .normal)
        self.campoSuperintendencia?.setTitle("-", for: .normal)
        self.tabla?.reloadData()
    }
    
    //Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MuroSearchFilterPersonTVCell
        let unit = personas[indexPath.row]
        celda.selectionStyle = .none
        celda.nombreCompleto.text = unit.Nombres
        celda.dni.text = unit.NroDocumento
        celda.cargo.text = unit.Cargo
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = personas[indexPath.row]
        self.alSeleccionarPersona?(unit)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    //Tabla
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickEnTitulo(_ sender: Any) {
        viewToHide.isHidden = !viewToHide.isHidden
    }
    
    @IBAction func editApellidos(_ sender: Any) {
        self.inputs[0] = campoApellidos.text!
        print(inputs)
    }
    
    @IBAction func editNombres(_ sender: Any) {
        self.inputs[1] = campoNombres.text!
        print(inputs)
    }
    
    @IBAction func editDNI(_ sender: Any) {
        self.inputs[2] = campoDNI.text!
        print(inputs)
    }
    
    
    
    @IBAction func clickEnGerencia(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
            self.inputs[3] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            self.inputs[4] = ""
            self.campoSuperintendencia.setTitle("-", for: .normal)
        })
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        let gerenciaSeleccionada = self.inputs[3]
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["SUPE.\(gerenciaSeleccionada)"] ?? [], {(index, item) in
            self.inputs[4] = Utils.maestroCodTipo["SUPE.\(gerenciaSeleccionada)"]?[index] ?? ""
        })
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        self.view.endEditing(true)
        Rest.getDataGeneral(Routes.forBuscarPersona(inputs[1], inputs[0], inputs[2], inputs[3], inputs[4], nroitems), true, success: {(resultValue:Any?,data:Data?) in
            let personas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            self.personas = personas.Data
            self.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forBuscarPersona(inputs[1], inputs[0], inputs[2], inputs[3], inputs[4], nroitems), true, vcontroller: self, success: {(dict:NSDictionary) in
            self.personas = Dict.toArrayPersona(dict)
            self.tabla.reloadData()
        })*/
    }
    
}

class MuroSearchFilterPersonTVCell: UITableViewCell {
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var dni: UILabel!
    @IBOutlet weak var cargo: UILabel!
}
