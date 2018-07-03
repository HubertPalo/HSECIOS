import UIKit

class TwoColumnTVC: UITableViewController {
    
    var dataLeft: [String] = []
    var dataRight: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(_ dataForLeft: [String], _ dataForRight: [String]) {
        self.dataLeft = dataForLeft
        self.dataRight = dataForRight
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLeft.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! TwoColumnTVCell
        celda.unitLeft.text = dataLeft[indexPath.row]
        celda.unitRight.text = dataRight[indexPath.row]
        return celda
    }
}


class TwoColumnTVCell: UITableViewCell {
    @IBOutlet weak var unitLeft: UILabel!
    @IBOutlet weak var unitRight: UILabel!
}
