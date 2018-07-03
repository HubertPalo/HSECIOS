import UIKit

class FiltroContrataTVC: UITableViewController {
    
    var nombres: [String] = []
    var codigos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto1View
        let indice = indexPath.row
        celda.texto1.text = nombres[indice]
        celda.texto2.text = codigos[indice]
        celda.view.isHidden = indice == nombres.count - 1
        // print("\(indice == nombres.count) : \(indice) - \(nombres.count)")
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let padre = self.parent as! FiltroContrataVC
        let indice = indexPath.row
        padre.seleccionarDataYSalir(nombres[indice], codigos[indice])
    }
    
    
}
