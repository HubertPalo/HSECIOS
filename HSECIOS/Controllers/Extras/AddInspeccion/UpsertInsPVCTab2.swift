import UIKit

class UpsertInsPVCTab2: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertInsVC {
            padre.selectTab(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1Boton
        header.boton.tag = section
        switch section {
        case 0:
            header.texto.attributedText = Utils.addInitialRedAsterisk("Personas que realizan la inspección", "HelveticaNeue-Bold", 14)
        case 1:
            header.texto.text = "Personas que atendieron"
        default:
            break
        }
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Globals.UITab2Realizaron.count
        case 1:
            return Globals.UITab2Atendieron.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto1Boton
        let unit = indexPath.section == 0 ? Globals.UITab2Realizaron[indexPath.row] : Globals.UITab2Atendieron[indexPath.row]
        celda.selectionStyle = .none
        celda.texto1.text = unit.Nombres
        celda.texto2.text = unit.Cargo
        celda.backgroundColor = unit.Lider == "1" ? Colores.celdaSeleccionada : UIColor.clear
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if Globals.UITab2IndexLider != -1 {
                Globals.UITab2Realizaron[Globals.UITab2IndexLider].Lider = "0"
            }
            Globals.UITab2IndexLider = indexPath.row
            Globals.UITab2RealizaronNuevoLider = Globals.UITab2Realizaron[indexPath.row].CodPersona!
            Globals.UITab2Realizaron[Globals.UITab2IndexLider].Lider = "1"
            self.tableView.reloadSections([0], with: .none)
        }
    }
    
    @IBAction func clickAddPersona(_ sender: Any) {
        let boton = sender as! UIButton
        VCHelper.openFiltroPersonas(self, {(personasPorAgregar) in
            for personaPorAgregar in personasPorAgregar {
                var personaRepetida = false
                switch boton.tag {
                case 0:
                    for personaEnLista in Globals.UITab2Realizaron {
                        if personaEnLista.NroDocumento != nil && personaEnLista.NroDocumento != "" {
                            personaRepetida = personaRepetida || personaEnLista.NroDocumento == personaPorAgregar.NroDocumento
                        }
                    }
                    if !personaRepetida {
                        Globals.UITab2Realizaron.append(personaPorAgregar)
                        Globals.UITab2RealizaronNuevo.insert(personaPorAgregar.CodPersona!)
                    }
                    break
                case 1:
                    for personaEnLista in Globals.UITab2Atendieron {
                        if personaEnLista.NroDocumento != nil && personaEnLista.NroDocumento != "" {
                            personaRepetida = personaRepetida || personaEnLista.NroDocumento == personaPorAgregar.NroDocumento
                        }
                    }
                    if !personaRepetida {
                        Globals.UITab2Atendieron.append(personaPorAgregar)
                        Globals.UITab2AtendieronNuevo.insert(personaPorAgregar.CodPersona!)
                    }
                    break
                default:
                    break
                }
            }
            self.tableView.reloadSections([boton.tag], with: .automatic)
        })
    }
    
    @IBAction func clickDelPersona(_ sender: Any) {
        var superview = (sender as! UIButton).superview
        while !(superview is UITableViewCell) {
            superview = superview?.superview
        }
        let celda = superview as! UITableViewCell
        let index = self.tableView.indexPath(for: celda)!
        switch index.section {
        case 0:
            if Globals.UITab2IndexLider == index.row {
                Globals.UITab2IndexLider = -1
            }
            Globals.UITab2RealizaronNuevo.remove(Globals.UITab2Realizaron[index.row].CodPersona!)
            Globals.UITab2Realizaron.remove(at: index.row)
            break
        case 1:
            Globals.UITab2AtendieronNuevo.remove(Globals.UITab2Atendieron[index.row].CodPersona!)
            Globals.UITab2Atendieron.remove(at: index.row)
            break
        default:
            break
        }
        self.tableView.reloadSections([index.section], with: .automatic)
    }
}
