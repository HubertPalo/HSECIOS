import UIKit

class PersonasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var tabla: UITableView!
    
    var data: [Persona] = []
    var paintLeader = false
    
    override func viewDidAppear(_ animated: Bool) {
        tabla.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.allowsSelection = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PersonasTVCell
        let unit = data[indexPath.row]
        celda.nombreCompleto.text = unit.Nombres
        celda.Area.text = unit.Cargo
        if paintLeader && unit.Estado == "1" {
            celda.backgroundColor = UIColor.cyan
        } else {
            celda.backgroundColor = UIColor.white
        }
        return celda
    }
}

class PersonasTVCell: UITableViewCell {
    
    @IBOutlet weak var nombreCompleto: UILabel!
    
    @IBOutlet weak var Area: UILabel!
    
}
