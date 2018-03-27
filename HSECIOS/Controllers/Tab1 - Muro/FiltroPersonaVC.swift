import UIKit
import DropDown
class FiltroPersonaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    @IBOutlet weak var viewToHide: UIView!
    
    @IBOutlet weak var campoApellidos: UITextField!
    
    @IBOutlet weak var campoNombres: UITextField!
    
    @IBOutlet weak var campoDNI: UITextField!
    
    @IBOutlet weak var campoGerencia: UIButton!
    
    @IBOutlet weak var campoSuperintendencia: UIButton!
    
    let dropdown = DropDown()
    
    var nroitems = 10
    var personas: [Persona] = []
    var inputs:[String] = ["","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        campoApellidos.delegate = self
        campoNombres.delegate = self
        campoDNI.delegate = self
    }
    
    //Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MuroSearchFilterPersonTVCell
        let unit = personas[indexPath.row]
        celda.nombreCompleto.text = unit.Nombres
        celda.dni.text = unit.NroDocumento
        celda.cargo.text = unit.Cargo
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = personas[indexPath.row]
        let vcs = self.navigationController!.viewControllers
        let previous = vcs[vcs.count - 2]
        if previous is FiltroObservacionVC {
            (previous as! FiltroObservacionVC).savePersona(unit)
        }
        if previous is FiltroInspeccionVC {
            (previous as! FiltroInspeccionVC).savePersona(unit)
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    //Tabla
    
    func showDropdown(_ boton: UIButton, _ dropDatasource: [String], _ resultDatasource: [String]) {
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = dropDatasource
        dropdown.selectionAction = { (index, item) in
            boton.setTitle(item, for: .normal)
            if boton == self.campoGerencia {
                self.inputs[3] = resultDatasource[index]
                self.inputs[4] = ""
                self.campoSuperintendencia.setTitle("-", for: .normal)
            }
            if boton == self.campoSuperintendencia {
                self.inputs[4] = resultDatasource[index]
            }
            print(index)
            print(item)
            print(self.inputs)
        }
        dropdown.show()
    }
    
    func successGettingData(_ data:[Persona]) {
        personas = data
        tabla.reloadData()
    }
    func errorGettingData(_ error:String) {
        print(error)
    }
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
        showDropdown(campoGerencia, Globals.gArrayGerencia[1], Globals.gArrayGerencia[0])
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        var arrayForLabel:[String] = []
        var arrayForValue:[String] = []
        
        if let array = Globals.gArraySuperintendencia[inputs[3]] {
            arrayForLabel = array[1]
            arrayForValue = array[0]
        }
        showDropdown(campoSuperintendencia, arrayForLabel, arrayForValue)
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        self.view.endEditing(true)
        //let inputs = [campoNombres.text!, campoApellidos.text!,campoDNI.text!, gerencia, superintendencia]
        Helper.getData(Routes.forBuscarPersona(inputs[1], inputs[0], inputs[2], inputs[3], inputs[4], nroitems), true, vcontroller: self, success: {(dict:NSDictionary) in
            self.personas = Dict.toArrayPersona(dict)
            self.tabla.reloadData()
        })
        //HMuro.buscarPersonas(inputs[1], inputs[0], inputs[2], inputs[3], inputs[4], 1, nroitems, vcontroller: self)
    }
    
    
}

class MuroSearchFilterPersonTVCell: UITableViewCell {
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var dni: UILabel!
    @IBOutlet weak var cargo: UILabel!
}
