import UIKit

class UpsertObsPVCTab2: UITableViewController, UITextViewDelegate {
    
    var modo = "ADD"
    var codigo = ""
    
    var obsDetalle = ObsDetalle()
    
    var tipo = "TO01"
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadModo(_ modo: String, _ codigo: String) {
        self.modo = modo
        self.codigo = codigo
        switch modo {
        case "ADD":
            /*self.obsGD.CodTipo = "TO01"
            self.obsGD.CodObservadoPor = Utils.userData.CodPersona
            self.obsGD.ObservadoPor = Utils.userData.Nombres
            self.obsGD.CodUbicacion = ""
            self.codUbicacion = ""
            self.codSubUbicacion = ""
            self.codUbiEspecifica = ""
            self.fecha = Date()*/
            self.tableView.reloadData()
        case "PUT":
            Rest.getDataGeneral(Routes.forObsDetalle(codigo), false, success: {(resultValue:Any?,data:Data?) in
                self.obsDetalle = Dict.dataToUnit(data!)!
                self.tipo = self.obsDetalle.CodTipo!
                self.tableView.reloadData()
            }, error: nil)
            break
        default:
            break
        }
    }
    
    func getData() -> String {
        /*self.obsGD.Fecha = Utils.date2str(self.fecha, "YYYY-MM-dd")
        var ubicacion = ""
        if self.codUbicacion != "" {
            ubicacion.append(self.codUbicacion)
        }
        if self.codSubUbicacion != "" {
            ubicacion.append(".\(self.codSubUbicacion)")
        }
        if self.codUbiEspecifica != "" {
            ubicacion.append(".\(self.codUbiEspecifica)")
        }
        self.obsGD.CodUbicacion = ubicacion
        let showData = self.obsGD
        showData.ObservadoPor = nil*/
        return String.init(data: Dict.unitToData(self.obsDetalle)!, encoding: .utf8)!
    }
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField.tag {
        case 1:
            self.obsDetalle.Observacion = textField.text
            // self.data["Observacion"] = textField.text
        case 2:
            self.obsDetalle.Accion = textField.text
            // self.data["Accion"] = textField.text
        default:
            break
        }
        return true
    }*/
    
    /*func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.obsDetalle.Observacion = textField.text
            // self.data["Observacion"] = textField.text
        case 2:
            self.obsDetalle.Accion = textField.text
            //self.data["Accion"] = textField.text
        default:
            break
        }
    }*/
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            self.obsDetalle.Observacion = textView.text
        case 1:
            self.obsDetalle.Accion = textView.text
        default:
            break
        }
        // self.tableView.reloadRows(at: [IndexPath.init(row: textView.tag, section: 0)], with: .none)
    }
    
    /*func textViewDidEndEditing(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            self.obsDetalle.Observacion = textView.text
        case 1:
            self.obsDetalle.Accion = textView.text
        default:
            break
        }
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.tipo {
        case "TO01":
            return 7
        case "TO02":
            return 5
        /*case "TO03":
            return 7
        case "TO04":
            return 7*/
        default:
            return 0
        }
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 75
        }
        return UITableViewAutomaticDimension
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1TextView
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Observación:", "HelveticaNeue-Bold", 13)
            celda.textView.text = self.obsDetalle.Observacion
            // celda.textView.sizeToFit()
            celda.textView.delegate = self
            celda.textView.tag = 0
            // celda.textView.isScrollEnabled = false
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1TextView
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Acción:", "HelveticaNeue-Bold", 13)
            celda.textView.text = self.obsDetalle.Accion
            // celda.textView.sizeToFit()
            celda.textView.delegate = self
            celda.textView.tag = 1
            // celda.textView.isScrollEnabled = false
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("ACTR", self.obsDetalle.CodActiRel ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 1
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("HHA Relacionada:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("HHAR", self.obsDetalle.CodHHA ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 2
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            var dato = ""
            if self.tipo == "TO01" {
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Acto Sub-Estándar:", "HelveticaNeue-Bold", 13)
                dato = Utils.searchMaestroStatic("ACTOSUBESTANDAR", self.obsDetalle.CodSubEstandar ?? "")
                celda.boton.tag = 3
            } else {
                celda.texto.attributedText = Utils.generateAttributedString(["Condición Sub-Estándar:"], ["HelveticaNeue-Bold"], [13])
                celda.boton.tag = 6
                dato = Utils.searchMaestroStatic("CONDICIONSUBESTANDAR", self.obsDetalle.CodSubEstandar ?? "")
            }
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Estado:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("ESOB", self.obsDetalle.CodEstado ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 4
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Error:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("EROB", self.obsDetalle.CodError ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 5
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        print((sender as! UIButton).tag)
        let botonDer = sender as! UIButton
        switch (sender as! UIButton).tag {
        case 1:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["ACTR"] ?? [], {(index, item) in
                self.obsDetalle.CodActiRel = Utils.maestroCodTipo["ACTR"]?[index]
                // self.data["ActividadRelacionada"] = Utils.maestroCodTipo["ACTR"]?[index]
                // print(self.data)
            })
        case 2:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["HHAR"] ?? [], {(index, item) in
                self.obsDetalle.CodHHA = Utils.maestroCodTipo["HHAR"]?[index]
                // self.data["HHARelacionada"] = Utils.maestroCodTipo["HHAR"]?[index]
                // print(self.data)
            })
        case 3:
            Utils.showDropdown(botonDer, Utils.maestroStatic2["ACTOSUBESTANDAR"] ?? [], {(index, item) in
                self.obsDetalle.CodSubEstandar = Utils.maestroStatic1["ACTOSUBESTANDAR"]?[index]
                // self.data["ActoSubEstandar"] = Utils.maestroStatic1["ACTOSUBESTANDAR"]?[index]
                // print(self.data)
            })
        case 4:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["ESOB"] ?? [], {(index, item) in
                self.obsDetalle.CodEstado = Utils.maestroCodTipo["ESOB"]?[index]
                // self.data["Estado"] = Utils.maestroCodTipo["ESOB"]?[index]
                // print(self.data)
            })
        case 5:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["EROB"] ?? [], {(index, item) in
                self.obsDetalle.CodError = Utils.maestroCodTipo["EROB"]?[index]
                // self.data["Error"] = Utils.maestroCodTipo["EROB"]?[index]
                // print(self.data)
            })
        case 6:
            Utils.showDropdown(botonDer, Utils.maestroStatic2["CONDICIONSUBESTANDAR"] ?? [], {(index, item) in
                self.obsDetalle.CodSubEstandar = Utils.maestroStatic1["CONDICIONSUBESTANDAR"]?[index]
                //self.data["CondicionSubEstandar"] = Utils.maestroStatic1["CONDICIONSUBESTANDAR"]?[index]
                // print(self.data)
            })
        default:
            break
        }
    }
    
}
