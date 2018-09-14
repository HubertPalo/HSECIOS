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
    var newInputs:[String] = ["","","","",""]
    var oldInputs:[String] = ["","","","",""]
    var pagina = 1
    var alSeleccionarPersonas: ((_ persona: [Persona]) -> Void)?
    var searched = false
    var indexSeleccionadas: [Bool] = []
    
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
        self.pagina = 1
        self.personas = []
        self.indexSeleccionadas = []
        self.newInputs = ["","","","",""]
        self.oldInputs = ["","","","",""]
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -10 {
                if searched {
                    self.pagina = self.pagina + 1
                    Rest.getDataGeneral(Routes.forBuscarPersona(oldInputs[1], oldInputs[0], oldInputs[2], oldInputs[3], oldInputs[4], pagina, nroitems), true, success: {(resultValue:Any?,data:Data?) in
                        let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                        
                        var setDocPersonas = Set<String>()
                        for persona in self.personas {
                            setDocPersonas.insert(persona.NroDocumento ?? "")
                        }
                        
                        var newArrayPersona = [Persona]()
                        for persona in arrayPersonas.Data {
                            if (persona.NroDocumento ?? "" != "") && !setDocPersonas.contains(persona.NroDocumento ?? "") {
                                newArrayPersona.append(persona)
                            }
                        }
                        
                        // Ordenar personas (enviar seleccionados arriba)
                        var id = 0
                        for i in 0..<self.indexSeleccionadas.count {
                            if self.indexSeleccionadas[i] {
                                if i != id {
                                    (self.indexSeleccionadas[i], self.indexSeleccionadas[id]) = (self.indexSeleccionadas[id], self.indexSeleccionadas[i])
                                    (self.personas[i], self.personas[id]) = (self.personas[id], self.personas[i])
                                }
                                id = id + 1
                            }
                        }
                        
                        
                        self.personas.append(contentsOf: newArrayPersona)
                        self.indexSeleccionadas.append(contentsOf: [Bool].init(repeating: false, count: newArrayPersona.count))
                        /*var nuevasPersonas = arrayPersonas.Data
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
                        self.personas.append(contentsOf: viejasPersonas)
                        self.indexSeleccionadas.append(contentsOf: newIndex)*/
                        self.tabla.reloadData()
                        
                        /*let personas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                        self.personas.append(contentsOf: personas.Data)
                        self.tabla.reloadData()*/
                    }, error: nil)
                }
            }
        }
    }
    
    @IBAction func clickEnTitulo(_ sender: Any) {
        viewToHide.isHidden = !viewToHide.isHidden
    }
    
    @IBAction func editApellidos(_ sender: Any) {
        self.newInputs[0] = campoApellidos.text!
    }
    
    @IBAction func editNombres(_ sender: Any) {
        self.newInputs[1] = campoNombres.text!
    }
    
    @IBAction func editDNI(_ sender: Any) {
        self.newInputs[2] = campoDNI.text!
    }
    
    @IBAction func clickEnGerencia(_ sender: Any) {
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["GERE"] ?? [], {(index, item) in
            self.newInputs[3] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
            self.newInputs[4] = ""
            self.campoSuperintendencia.setTitle("-", for: .normal)
        })
    }
    
    @IBAction func clickEnSuperintendencia(_ sender: Any) {
        let gerenciaSeleccionada = self.newInputs[3]
        Utils.showDropdown((sender as! UIButton), Utils.maestroDescripcion["SUPE.\(gerenciaSeleccionada)"] ?? [], {(index, item) in
            self.newInputs[4] = Utils.maestroCodTipo["SUPE.\(gerenciaSeleccionada)"]?[index] ?? ""
        })
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        self.view.endEditing(true)
        self.pagina = 1
        self.oldInputs = self.newInputs
        Rest.getDataGeneral(Routes.forBuscarPersona(oldInputs[1], oldInputs[0], oldInputs[2], oldInputs[3], oldInputs[4], pagina, nroitems), true, success: {(resultValue:Any?,data:Data?) in
            let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            self.searched = true
            
            var docSeleccionadas = Set<String>()
            var personasSeleccionadas = [Persona]()
            for i in 0..<self.indexSeleccionadas.count {
                if self.indexSeleccionadas[i] {
                    personasSeleccionadas.append(self.personas[i])
                    docSeleccionadas.insert(self.personas[i].NroDocumento ?? "")
                }
            }
            
            var newPersonas = [Persona]()
            for persona in arrayPersonas.Data {
                if !docSeleccionadas.contains(persona.NroDocumento ?? "") {
                    newPersonas.append(persona)
                }
            }
            
            var flags = [Bool].init(repeating: true, count: personasSeleccionadas.count)
            personasSeleccionadas.append(contentsOf: newPersonas)
            flags.append(contentsOf: [Bool].init(repeating: false, count: newPersonas.count))
            
            /*var nuevasPersonas = arrayPersonas.Data
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
            self.indexSeleccionadas = newIndex*/
            self.personas = personasSeleccionadas
            self.indexSeleccionadas = flags
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
