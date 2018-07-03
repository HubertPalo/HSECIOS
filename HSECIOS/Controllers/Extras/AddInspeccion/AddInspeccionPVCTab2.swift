import UIKit

class AddInspeccionPVCTab2: UITableViewController {
    
    var personas: [[Persona]] = [[],[]]
    var indexLider = -1
    
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
            header.texto.text = "Personas que realizan la inspección"
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
        return self.personas[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && self.indexLider != indexPath.row {
            self.indexLider = indexPath.row
            self.tableView.reloadSections([0], with: .automatic)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
        let unit = self.personas[indexPath.section][indexPath.row]
        celda.selectionStyle = .none
        celda.texto1.text = unit.Nombres
        celda.texto2.text = unit.Cargo
        var flagLider = indexPath.section == 0 && indexPath.row == self.indexLider
        celda.accessoryType = flagLider ? .checkmark : .none
        celda.backgroundColor = flagLider ? Colores.celdaSeleccionada : UIColor.clear
        return celda
    }
    
    @IBAction func clickAddPersona(_ sender: Any) {
        let boton = sender as! UIButton
        // var nuevasPersonas: [Persona] = [Persona].init(self.personas[boton.tag])
        VCHelper.openFiltroPersonas(self, {(personas) in
            for i in 0..<personas.count {
                let personaPorAgregar = personas[i]
                var personaRepetida = false
                for j in 0..<self.personas[boton.tag].count {
                    personaRepetida = personaRepetida || self.personas[boton.tag][j].NroDocumento == personas[i].NroDocumento
                }
                if !personaRepetida {
                    self.personas[boton.tag].append(personaPorAgregar)
                }
            }
            self.tableView.reloadSections([boton.tag], with: .automatic)
        })
    }
    
    @IBAction func clickDelPersona(_ sender: Any) {
        var superview = (sender as! UIButton).superview
        while !(superview is Celda2Texto) {
            superview = superview?.superview
        }
        let celda = superview as! Celda2Texto
        let index = self.tableView.indexPath(for: celda)!
        self.personas[index.section].remove(at: index.row)
        if index.section == 0 {
            if index.row == self.indexLider {
                self.indexLider = -1
            }
            if index.row < self.indexLider {
                self.indexLider = self.indexLider - 1
            }
        }
        self.tableView.reloadSections([index.section], with: .automatic)
    }
    
}
