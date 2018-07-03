import UIKit

class InspeccionesVC: UIViewController {
    var muro = MuroTVC()
    var data: [String:String] = ["Pagenumber": "1", "Elemperpage": "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Inspecciones", Images.minero)
        
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            self.data["Pagenumber"] = "1"
            self.data["Elemperpage"] = "\(cantidad)"
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data = arrayMuroElement.Data
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
            self.data["Pagenumber"] = "\(pagina)"
            self.data["Elemperpage"] = "10"
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data = arrayMuroElement.Data
                self.muro.tableView.reloadData()
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchO(), self.data, true, vcontroller: self, success: {(dict:NSDictionary) in
                let data: [MuroElement] = Dict.toArrayMuroElement(dict)
                self.muro.data = data
                self.muro.tableView.reloadData()
            })*/
        }
        self.muro.alClickCelda = {(unit: MuroElement) in
            Tabs.indexInsDetalle = 1
            VCHelper.openInsDetalle(self, unit)
        }
        Rest.postDataGeneral(Routes.forMuroSearchI(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.data = arrayMuroElement.Data
            self.muro.tableView.reloadData()
        }, error: nil)
        /*Rest.postData(Routes.forMuroSearchI(), self.data, true, vcontroller: self, success: {(dict:NSDictionary) in
            let data: [MuroElement] = Dict.toArrayMuroElement(dict)
            self.muro.data = data
            self.muro.tableView.reloadData()
        })*/
    }
    
    
    @IBAction func clickMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
    @IBAction func clickBuscar(_ sender: Any) {
        VCHelper.openFiltroMuro(self, "INS")
    }
    
    
}
