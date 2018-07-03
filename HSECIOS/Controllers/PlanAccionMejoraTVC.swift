import UIKit

class PlanAccionMejoraTVC: UITableViewController, UITextFieldDelegate {
    
    var codPlanAccion = ""
    var mejora = AccionMejora()
    var responsables: [Persona] = []
    var multimedia: [FotoVideo] = []
    var documentos: [DocumentoGeneral] = []
    var modo = "GET"
    var data: [String:String] = [:]
    var porcentaje = 0
    var mostrarSeccion1 = false
    var mostrarSeccion2 = false
    
    
    var dataNoEdit: [[String]] = [["Responsable", "-"], ["Fecha", "-"], ["Porcentaje de avance", "-"], ["Tarea realizada", "-"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
    }
    
    func cleanData() {
        self.dataNoEdit = [["Responsable", "-"], ["Fecha", "-"], ["Porcentaje de avance", "-"], ["Tarea realizada", "-"]]
        self.multimedia = []
        self.documentos = []
        self.tableView.reloadData()
    }
    
    func loadData(_ modo: String, _ accion: AccionMejora, _ codPlanAccion: String, _ responsables: [Persona]) {
        self.modo = modo
        self.mejora = accion
        self.codPlanAccion = codPlanAccion
        self.responsables = responsables
        self.tableView.reloadData()
        self.mostrarSeccion1 = false
        self.mostrarSeccion2 = false
        switch modo {
        case "ADD":
            self.mostrarSeccion1 = true
            self.mostrarSeccion2 = true
        case "GET":
            Rest.getDataGeneral(Routes.forAccionMejoraDetalle(accion.Correlativo), true, success: {(resultValue:Any?,data:Data?) in
                let detalle: AccionMejoraDetalle = Dict.dataToUnit(data!)!
                self.dataNoEdit[0][1] = detalle.Responsable
                self.dataNoEdit[1][1] = Utils.str2date2str(detalle.Fecha)
                self.dataNoEdit[2][1] = detalle.PorcentajeAvance
                self.dataNoEdit[3][1] = detalle.Descripcion
                self.multimedia = detalle.multimedia
                self.documentos = detalle.documentos
                self.mostrarSeccion1 = detalle.multimedia.count > 0
                self.mostrarSeccion2 = detalle.documentos.count > 0
                self.tableView.reloadData()
            }, error: nil)
            /*Rest.getData(Routes.forAccionMejoraDetalle(accion.Correlativo), true, vcontroller: self, success: {(dict:NSDictionary) in
                let detalle = Dict.toAccionMejoraDetalle(dict)
                self.dataNoEdit[0][1] = detalle.Responsable
                self.dataNoEdit[1][1] = Utils.str2date2str(detalle.Fecha)
                self.dataNoEdit[2][1] = detalle.PorcentajeAvance
                self.dataNoEdit[3][1] = detalle.Descripcion
                self.multimedia = detalle.multimedia
                self.documentos = detalle.documentos
                self.mostrarSeccion1 = detalle.multimedia.count > 0
                self.mostrarSeccion2 = detalle.documentos.count > 0
                self.tableView.reloadData()
            })*/
        case "PUT":
            Rest.getDataGeneral(Routes.forMultimedia(accion.Correlativo), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                let (multimedia, documentos) = Utils.separateMultimedia(arrayMultimedia.Data)
                self.multimedia = multimedia
                self.documentos = documentos
                self.tableView.reloadData()
            }, error: nil)
            /*Rest.getData(Routes.forMultimedia(accion.Correlativo), true, vcontroller: self, success: {(dict:NSDictionary) in
                let (multimedia, documentos) = Dict.toArrayMultimediaYDocumentos(dict)
                self.multimedia = multimedia
                self.documentos = documentos
                self.tableView.reloadData()
            })*/
        default:
            break
        }
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                let nsString = textField.text as NSString?
                let num = nsString?.replacingCharacters(in: range, with: string)
                let numero = Int(num!) ?? 0
                if numero <= 100 && numero >= 0 {
                    self.porcentaje = numero
                    return true
                }
            }
            return false
        }
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        case 1:
            return self.multimedia.count > 0 ? 50 : CGFloat.leastNonzeroMagnitude
        case 2:
            return self.documentos.count > 0 ? 50 : CGFloat.leastNonzeroMagnitude
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
        switch section {
        case 0:
            header.texto.text = "Registro de atención"
            header.view.isHidden = true
        case 1:
            if !self.mostrarSeccion1 {
                return nil
            }
            header.texto.text = "Galería de Fotos Videos"
            header.view.isHidden = self.modo == "GET"
        case 2:
            if !self.mostrarSeccion2 {
                return nil
            }
            header.texto.text = "Otros Documentos"
            header.view.isHidden = self.modo == "GET"
        default:
            break
        }
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return self.multimedia.count / 2 + self.multimedia.count % 2
        case 2:
            return self.documentos.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.modo == "GET" {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                celda.texto1.text = self.dataNoEdit[indexPath.row][0]
                celda.texto2.text = self.dataNoEdit[indexPath.row][1]
                return celda
            }
            switch indexPath.row {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Responsable", "HelveticaNeue-Bold", 13)
                celda.boton.tag = 0
                if self.responsables.count > 1 {
                    celda.boton.setTitle("- SELECCIONE -", for: .normal)
                }
                if self.responsables.count == 1 {
                    celda.boton.setTitle(self.responsables[0].Nombres, for: .normal)
                }
                if self.responsables.count == 0 {
                    celda.boton.setTitle("NO HAY RESPONSABLES DISPONIBLES", for: .normal)
                }
                celda.boton.titleLabel?.numberOfLines = 2
                if self.modo == "PUT" {
                    celda.boton.setTitle(self.mejora.Persona, for: .normal)
                }
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.text = "Fecha"
                celda.boton.tag = 1
                celda.boton.setTitle(Utils.date2str(Date(), "dd 'de' MMMM").uppercased(), for: .normal)
                celda.boton.titleLabel?.numberOfLines = 2
                if self.modo == "PUT" {
                    
                }
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Porcentaje de avance", "HelveticaNeue-Bold", 13)
                celda.inputTexto.text = "\(self.porcentaje)"
                celda.inputTexto.tag = 0
                celda.inputTexto.keyboardType = .numberPad
                celda.inputTexto.delegate = self
                if self.modo == "PUT" {
                    
                }
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Tarea realizada", "HelveticaNeue-Bold", 13)
                celda.inputTexto.text = "\(self.porcentaje)"
                celda.inputTexto.tag = 1
                celda.inputTexto.delegate = self
                if self.modo == "PUT" {
                    
                }
                return celda
            default:
                return UITableViewCell()
            }
        case 1: // Celda Galeria
            var celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! CeldaGaleria
            let dataIzq = self.multimedia[indexPath.row * 2]
            let dataDer: FotoVideo? = indexPath.row * 2 + 1 >= self.multimedia.count ? nil : self.multimedia[indexPath.row * 2 + 1]
            Utils.initCeldaGaleria(&celda, dataIzq, dataDer, self.modo != "GET", tableView, indexPath)
            return celda
            // return UITableViewCell()
        case 2: // Celda Documentos
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda7") as! CeldaDocumento
            let unit = self.documentos[indexPath.row]
            return Utils.initCeldaDocumento(celda, unit, self.modo != "GET", self.modo != "GET")
            // return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickResponsableFecha(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            var nombres: [String] = []
            for i in 0..<self.responsables.count {
                nombres.append(self.responsables[i].Nombres)
            }
            Utils.showDropdown(boton, nombres, {(index,item) in
                self.data["CodPersona"] = self.responsables[index].CodPersona
                print(self.data)
            })
        case 1:
            Utils.openDatePicker("Fecha", Date(), nil, nil, chandler: {(date) in
                boton.setTitle(Utils.date2str(date, "dd 'de' MMMM").uppercased(), for: .normal)
                self.data["Fecha"] = Utils.date2str(date, "YYYY-MM-dd")
                print(self.data)
            })
        default:
            break
        }
    }
    
    @IBAction func clickFlechaIzq(_ sender: Any) {
        self.porcentaje = self.porcentaje > 0 ? self.porcentaje - 1 : 0
        self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
    @IBAction func clickFlechaDer(_ sender: Any) {
        self.porcentaje = self.porcentaje < 100 ? self.porcentaje + 1 : 100
        self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
    
}

