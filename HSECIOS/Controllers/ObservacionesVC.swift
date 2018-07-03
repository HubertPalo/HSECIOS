import UIKit

class ObservacionesVC: UIViewController {
    var muro = MuroTVC()
    var data: [String:String] = ["Lugar": "1", "CodUbicacion": "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            self.data["Lugar"] = "1"
            self.data["CodUbicacion"] = "\(cantidad)"
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let data: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data = data.Data
                self.muro.tableView.reloadData()
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchO(), self.data, true, vcontroller: self, success: {(dict:NSDictionary) in
                let data: [MuroElement] = Dict.toArrayMuroElement(dict)
                self.muro.data = data
                self.muro.tableView.reloadData()
            })*/
        }
        self.muro.alScrollLimiteBot = {
            var pagina = self.muro.data.count / 10
            if self.muro.data.count % 10 == 0 {
                pagina = pagina + 1
            }
            self.data["Lugar"] = "\(pagina)"
            self.data["CodUbicacion"] = "10"
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let data: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data = data.Data
                self.muro.tableView.reloadData()
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchO(), self.data, true, vcontroller: self, success: {(dict:NSDictionary) in
                let data: [MuroElement] = Dict.toArrayMuroElement(dict)
                self.muro.data = data
                self.muro.tableView.reloadData()
            })*/
        }
        
        self.muro.alClickCelda = {(unit:MuroElement) in
            Tabs.indexObsDetalle = 1
            VCHelper.openObsDetalle(self, unit)
        }
        
        Utils.setTitleAndImage(self, "Observaciones", Images.minero)
        Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            let data: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.data = data.Data
            self.muro.tableView.reloadData()
        }, error: nil)
        /*Rest.postData(Routes.forMuroSearchO(), self.data, true, vcontroller: self, success: {(dict:NSDictionary) in
            let data: [MuroElement] = Dict.toArrayMuroElement(dict)
            self.muro.data = data
            self.muro.tableView.reloadData()
        })*/
    }
    
    @IBAction func clickFiltro(_ sender: Any) {
        VCHelper.openFiltroMuro(self, "OBS")
        /*VCHelper.openFiltroObservacion(self, {(data:[String:String]) in
            Rest.postData(Routes.forMuroSearchO(), data, true, vcontroller: self, success: {(dict: NSDictionary) in
                let data: [MuroElement] = Dict.toArrayMuroElement(dict)
                let hijo = self.childViewControllers[0] as! MuroTVC
                hijo.data = data
                print(data.count)
                hijo.tableView.reloadData()
                /*let vcs = self.navigationController!.viewControllers
                 let previous = vcs[vcs.count - 2] as! MuroSearchVC
                 previous.saveData(data)*/
                //self.alFiltrar?(data)
                /*self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                print(data)*/
            })
            
        })*/
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
}
