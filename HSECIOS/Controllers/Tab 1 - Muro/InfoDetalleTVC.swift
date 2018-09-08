import UIKit

class InfoDetalleTVC: UITableViewController {
    
    var data = [[String]]()
    var separatorHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! Celda2Texto1View
        celda.texto1.text = data[indexPath.row][0]
        celda.texto2.text = data[indexPath.row][1]
        celda.view.isHidden = separatorHidden || indexPath.row == data.count - 1
        return celda
    }
    
}
