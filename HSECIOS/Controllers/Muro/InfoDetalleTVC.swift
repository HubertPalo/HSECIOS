import UIKit

class InfoDetalleTVC: UITableViewController {
    
    var dataLeft: [String] = []
    var dataRight: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLeft.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! InfoDetalleTVCell
        celda.infoLeft.text = dataLeft[indexPath.row]
        celda.infoRight.text = dataRight[indexPath.row]
        return celda
    }
    
}

class InfoDetalleTVCell: UITableViewCell {
    @IBOutlet weak var infoLeft: UILabel!
    @IBOutlet weak var infoRight: UILabel!
}
