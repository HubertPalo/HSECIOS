import UIKit

class PopUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var dataLeft: [String] = []
    var dataRight: [String] = []
    var dataTitle = ""
    var alSalir: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1Imagen
        celda.texto.text = self.dataTitle
        celda.imagen.image = UIImage.init(named: "x")?.withRenderingMode(.alwaysTemplate)
        celda.imagen.tintColor = UIColor.white
        return celda.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLeft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto1View
        celda.texto1.text = dataLeft[indexPath.row]
        celda.texto2.text = dataRight[indexPath.row]
        celda.view.isHidden = indexPath.row == dataRight.count - 1
        return celda
    }
    
    @IBAction func exitPopUp(_ sender: Any) {
        alSalir?()
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
