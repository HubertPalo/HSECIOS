import UIKit

class FiltroPersonasVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var viewToHide: UIView!
    @IBOutlet weak var campoApellidos: UITextField!
    @IBOutlet weak var campoNombres: UITextField!
    @IBOutlet weak var campoDNI: UITextField!
    @IBOutlet weak var campoGerencia: UIButton!
    @IBOutlet weak var campoSuperintendencia: UIButton!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    var nroitems = 10
    var personas: [Persona] = []
    var indexSeleccionadas: [Bool] = []
    var inputs:[String] = ["","","","",""]
    
    var alSeleccionarPersonas: ((_ persona: [Persona]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Búsqueda personas", Images.user)
        tabla.delegate = self
        tabla.dataSource = self
        campoApellidos.delegate = self
        campoNombres.delegate = self
        campoDNI.delegate = self
        self.botonTopDer.isEnabled = false
    }
    
    func cleanData() {
        self.personas = []
        self.indexSeleccionadas = []
        self.inputs = ["","","","",""]
        self.campoApellidos?.text = ""
        self.campoNombres?.text = ""
        self.campoDNI?.text = ""
        self.campoGerencia?.setTitle("-", for: .normal)
        self.campoSuperintendencia?.setTitle("-", for: .normal)
        self.botonTopDer?.isEnabled = false
        self.tabla?.reloadData()
    }
    
    //Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! Celda3Texto
        let unit = personas[indexPath.row]
        let flagSeleccion = self.indexSeleccionadas[indexPath.row]
        celda.texto1.text = unit.Nombres
        celda.texto2.text = unit.NroDocumento
        celda.texto3.text = unit.Cargo
        celda.accessoryType = flagSeleccion ? .checkmark : .none
        celda.backgroundColor = flagSeleccion ? Colores.celdaSeleccionada : UIColor.clear
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexSeleccionadas[indexPath.row] = !self.indexSeleccionadas[indexPath.row]
        let flagSeleccion = self.indexSeleccionadas[indexPath.row]
        let celda = tableView.cellForRow(at: indexPath)!
        celda.accessoryType = flagSeleccion ? .checkmark : .none
        celda.backgroundColor = flagSeleccion ? Colores.celdaSeleccionada : UIColor.clear
        var mostrarBoton = false
        for i in 0..<indexSeleccionadas.count {
            mostrarBoton = mostrarBoton || indexSeleccionadas[i]
        }
        self.botonTopDer.isEnabled = mostrarBoton
        tableView.reloadData()
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
            let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            //var nuevasPersonas = Dict.toArrayPersona(dict)
            var nuevasPersonas = arrayPersonas.Data
            var viejasPersonas: [Persona] = []
            for i in 0..<self.indexSeleccionadas.count {
                if self.indexSeleccionadas[i] {
                    viejasPersonas.append(self.personas[i])
                    for j in 0..<nuevasPersonas.count {
                        if nuevasPersonas[j].NroDocumento == self.personas[i].NroDocumento {
                            nuevasPersonas.remove(at: j)
                            break
                        }
                    }
                }
            }
            var newIndex = [Bool].init(repeating: true, count: viejasPersonas.count)
            newIndex.append(contentsOf: [Bool].init(repeating: false, count: nuevasPersonas.count))
            viejasPersonas.append(contentsOf: nuevasPersonas)
            self.personas = viejasPersonas
            self.indexSeleccionadas = newIndex
            self.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forBuscarPersona(inputs[1], inputs[0], inputs[2], inputs[3], inputs[4], nroitems), true, vcontroller: self, success: {(dict:NSDictionary) in
            var nuevasPersonas = Dict.toArrayPersona(dict)
            var viejasPersonas: [Persona] = []
            for i in 0..<self.indexSeleccionadas.count {
                if self.indexSeleccionadas[i] {
                    viejasPersonas.append(self.personas[i])
                    for j in 0..<nuevasPersonas.count {
                        if nuevasPersonas[j].NroDocumento == self.personas[i].NroDocumento {
                            nuevasPersonas.remove(at: j)
                            break
                        }
                    }
                }
            }
            var newIndex = [Bool].init(repeating: true, count: viejasPersonas.count)
            newIndex.append(contentsOf: [Bool].init(repeating: false, count: nuevasPersonas.count))
            viejasPersonas.append(contentsOf: nuevasPersonas)
            
            // var personasParaTabla = self.personasSeleccionadas
            // personasParaTabla.append(contentsOf: nuevasPersonas)
            
            self.personas = viejasPersonas
            self.indexSeleccionadas = newIndex
            self.tabla.reloadData()
        })*/
    }
    
    @IBAction func clickAgregar(_ sender: Any) {
        var personasSeleccionadas: [Persona] = []
        for i in 0..<indexSeleccionadas.count {
            if indexSeleccionadas[i] {
                personasSeleccionadas.append(personas[i])
            }
        }
        self.alSeleccionarPersonas?(personasSeleccionadas)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
