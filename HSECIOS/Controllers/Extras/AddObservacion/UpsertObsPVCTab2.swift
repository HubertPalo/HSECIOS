import UIKit

class UpsertObsPVCTab2: UITableViewController, UITextViewDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            Globals.UOTab2ObsDetalle.Observacion = textView.text
        case 1:
            Globals.UOTab2ObsDetalle.Accion = textView.text
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Globals.UOTab2ObsDetalle.CodTipo ?? "TO01" {
        case "TO01":
            return 7
        case "TO02":
            return 5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1TextView
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Observación:", "HelveticaNeue-Bold", 13)
            celda.textView.text = Globals.UOTab2ObsDetalle.Observacion
            celda.textView.delegate = self
            celda.textView.tag = 0
            celda.textView.layer.borderColor = Colores.colorDeBorde.cgColor
            celda.textView.layer.borderWidth = 1.0
            celda.textView.layer.cornerRadius = 5.0
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1TextView
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Acción:", "HelveticaNeue-Bold", 13)
            celda.textView.text = Globals.UOTab2ObsDetalle.Accion
            celda.textView.delegate = self
            celda.textView.tag = 1
            celda.textView.layer.borderColor = Colores.colorDeBorde.cgColor
            celda.textView.layer.borderWidth = 0.5
            celda.textView.layer.cornerRadius = 5.0
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("ACTR", Globals.UOTab2ObsDetalle.CodActiRel ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 1
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("HHA Relacionada:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("HHAR", Globals.UOTab2ObsDetalle.CodHHA ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 2
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            var dato = ""
            if Globals.UOTab2ObsDetalle.CodTipo == "TO01" {
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Acto Sub-Estándar:", "HelveticaNeue-Bold", 13)
                dato = Utils.searchMaestroStatic("ACTOSUBESTANDAR", Globals.UOTab2ObsDetalle.CodSubEstandar ?? "")
                celda.boton.tag = 3
            } else {
                celda.texto.attributedText = Utils.generateAttributedString(["Condición Sub-Estándar:"], ["HelveticaNeue-Bold"], [13])
                celda.boton.tag = 6
                dato = Utils.searchMaestroStatic("CONDICIONSUBESTANDAR", Globals.UOTab2ObsDetalle.CodSubEstandar ?? "")
            }
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            return celda
        case 5:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Estado:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("ESOB", Globals.UOTab2ObsDetalle.CodEstado ?? "")
            dato = dato != "" ? dato : "- SELECCIONE -"
            celda.boton.setTitle(dato, for: .normal)
            celda.boton.tag = 4
            return celda
        case 6:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto1Boton
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Error:", "HelveticaNeue-Bold", 13)
            var dato = Utils.searchMaestroDescripcion("EROB", Globals.UOTab2ObsDetalle.CodError ?? "")
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
                Globals.UOTab2ObsDetalle.CodActiRel = Utils.maestroCodTipo["ACTR"]?[index]
            })
        case 2:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["HHAR"] ?? [], {(index, item) in
                Globals.UOTab2ObsDetalle.CodHHA = Utils.maestroCodTipo["HHAR"]?[index]
            })
        case 3:
            Utils.showDropdown(botonDer, Utils.maestroStatic2["ACTOSUBESTANDAR"] ?? [], {(index, item) in
                Globals.UOTab2ObsDetalle.CodSubEstandar = Utils.maestroStatic1["ACTOSUBESTANDAR"]?[index]
            })
        case 4:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["ESOB"] ?? [], {(index, item) in
                Globals.UOTab2ObsDetalle.CodEstado = Utils.maestroCodTipo["ESOB"]?[index]
            })
        case 5:
            Utils.showDropdown(botonDer, Utils.maestroDescripcion["EROB"] ?? [], {(index, item) in
                Globals.UOTab2ObsDetalle.CodError = Utils.maestroCodTipo["EROB"]?[index]
            })
        case 6:
            Utils.showDropdown(botonDer, Utils.maestroStatic2["CONDICIONSUBESTANDAR"] ?? [], {(index, item) in
                Globals.UOTab2ObsDetalle.CodSubEstandar = Utils.maestroStatic1["CONDICIONSUBESTANDAR"]?[index]
            })
        default:
            break
        }
    }
    
}
