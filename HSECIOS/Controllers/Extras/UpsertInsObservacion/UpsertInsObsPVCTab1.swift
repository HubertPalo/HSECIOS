import UIKit

class UpsertInsObsPVCTab1: UITableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertInsObsVC {
            padre.selectTab(0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            Globals.UIOTab1ObsDetalle.Lugar = textField.text ?? ""
        case 1:
            Globals.UIOTab1ObsDetalle.Observacion = textField.text ?? ""
        default:
            break
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda2Texto
            celda.texto1.text = "Código"
            var dato = Globals.UIOTab1ObsDetalle.CodInspeccion
            dato = dato == "" ? "INSP000000XYZ" : dato
            celda.texto2.text = dato
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda2Texto
            celda.texto1.text = "Nro Inspección"
            celda.texto2.text = Globals.UIOTab1ObsDetalle.NroDetInspeccion != nil ? "\(Globals.UIOTab1ObsDetalle.NroDetInspeccion!)" : "-"
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.text = "Ubicación Específica"
            var dato = Utils.searchMaestroDescripcion("UBIC.\(Globals.UIOTab1ObsDetalle.CodUbicacion ?? "")")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 0
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1InputText
            celda.texto.text = "Lugar"
            celda.inputTexto.text = Globals.UIOTab1ObsDetalle.Lugar
            celda.inputTexto.delegate = self
            celda.inputTexto.tag = 0
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Aspecto Observado", "HelveticaNeue-Bold", 14)
            var dato = Utils.searchMaestroDescripcion("ASPO", Globals.UIOTab1ObsDetalle.CodAspectoObs ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 1
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada", "HelveticaNeue-Bold", 14)
            var dato = Utils.searchMaestroDescripcion("ACTR", Globals.UIOTab1ObsDetalle.CodActividadRel ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 2
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Nivel de riesgo", "HelveticaNeue-Bold", 14)
            var dato = Utils.searchMaestroStatic("NIVELRIESGO", Globals.UIOTab1ObsDetalle.CodNivelRiesgo ?? "")
            dato = dato == "" ? "- SELECCIONE -" : dato
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 3
            return celda
        case 7:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1InputText
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Observación", "HelveticaNeue-Bold", 14)
            celda.inputTexto.text = Globals.UIOTab1ObsDetalle.Observacion
            celda.inputTexto.delegate = self
            celda.inputTexto.tag = 1
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            Utils.showDropdown(boton, Utils.maestroDescripcion["UBIC.\(Globals.UITab1InsGD.CodSubUbicacion ?? "")"] ?? [], {(index,item) in
                Globals.UIOTab1ObsDetalle.CodUbicacion = "\(Globals.UITab1InsGD.CodSubUbicacion!).\(Utils.maestroCodTipo["UBIC.\(Globals.UITab1InsGD.CodSubUbicacion!)"]![index])"
            })
            break
        case 1:
            Utils.showDropdown(boton, Utils.maestroDescripcion["ASPO"] ?? [], {(index,item) in
                Globals.UIOTab1ObsDetalle.CodAspectoObs = Utils.maestroCodTipo["ASPO"]![index]
            })
            break
        case 2:
            Utils.showDropdown(boton, Utils.maestroDescripcion["ACTR"] ?? [], {(index,item) in
                Globals.UIOTab1ObsDetalle.CodActividadRel = Utils.maestroCodTipo["ACTR"]![index]
            })
            break
        case 3:
            Utils.showDropdown(boton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index,item) in
                Globals.UIOTab1ObsDetalle.CodNivelRiesgo = Utils.maestroStatic1["NIVELRIESGO"]![index]
            })
            break
        default:
            break
        }
    }
    
}
