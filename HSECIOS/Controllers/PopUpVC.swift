import UIKit

class PopUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tabla: UITableView!
    
    var dataLeft: [String] = []
    var dataRight: [String] = []
    var dataTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.titulo.text = self.dataTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLeft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PopUpVCell
        celda.stackView.layer.borderWidth = 1
        celda.stackView.layer.borderColor = UIColor.gray.cgColor
        
        celda.valueInLeft.text = dataLeft[indexPath.row]
        celda.valueInRight.text = dataRight[indexPath.row]
        return celda
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tableView.contentSize.height)
        print(dataLeft.count)
        return tableView.contentSize.height / CGFloat(dataLeft.count)
    }*/
    
    @IBAction func exitPopUp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

class PopUpVCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIView!
    
    @IBOutlet weak var valueInLeft: UILabel!
    
    @IBOutlet weak var valueInRight: UILabel!
}
