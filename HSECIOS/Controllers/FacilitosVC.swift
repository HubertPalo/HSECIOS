import UIKit

class FacilitosVC: UIViewController {
    var muro = FacilitosTVC()
    var data: [String:String] = ["Observacion": "1", "Accion": "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Reportes facilito", Images.minero)
        self.muro = self.childViewControllers[0] as! FacilitosTVC
        self.muro.alScrollLimiteTop = {
            let cantidad = self.muro.facilitos.Data.count > 10 ? self.muro.facilitos.Data.count : 10
            self.data["Observacion"] = "1"
            self.data["Accion"] = "\(cantidad)"
            Rest.postDataGeneral(Routes.forFiltroFacilito(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                self.muro.facilitos = Dict.dataToArray(data!)
                self.muro.tableView.reloadData()
            }, error: nil)
            /*Rest.postData3(Routes.forFiltroFacilito(), self.data, true, vcontroller: self, success: {(data: Data) in
                let decoder = JSONDecoder()
                do {
                    let products: ArrayGeneral<FacilitoElement> = try decoder.decode(ArrayGeneral<FacilitoElement>.self, from: data as! Data)
                    print(products)
                    self.muro.facilitos.Count = products.Count
                    self.muro.facilitos.Data = products.Data
                } catch {
                    
                }
                self.muro.tableView.reloadData()
                })*/
        }
        self.muro.alScrollLimiteBot = {
            var pagina = self.muro.facilitos.Data.count / 10
            if self.muro.facilitos.Data.count % 10 == 0 {
                pagina = pagina + 1
            }
            self.data["Observacion"] = "\(pagina)"
            self.data["Accion"] = "10"
            Rest.postDataGeneral(Routes.forFiltroFacilito(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                self.muro.facilitos = Dict.dataToArray(data!)
                self.muro.tableView.reloadData()
            }, error: nil)
        }
        
        self.muro.alSeleccionarCelda = {(facilito) in
            VCHelper.openFacilitoDetalle(self, facilito)
        }
        Rest.postDataGeneral(Routes.forFiltroFacilito(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            self.muro.facilitos = Dict.dataToArray(data!)
            self.muro.tableView.reloadData()
        }, error: nil)
    }
    
    @IBAction func clickMenu(_ sender: Any) {
        Utils.openMenu()
    }
    
    @IBAction func clickBuscar(_ sender: Any) {
        VCHelper.openFiltroMuro(self, "OBF")
    }
    
}
