import UIKit
import CoreData

class TotaalOverviewController:UITableViewController{
    
    @IBOutlet weak var totaalLabel : UILabel!
    @IBOutlet weak var inkomstenLabel : UILabel!
    @IBOutlet weak var kostenLabel : UILabel!
    
    private var model = KostModel()
    private let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        getDataFromDatabase()
        setTotaal()
        setInkomsten()
        setKosten()
    }
    
    private func getDataFromDatabase(){
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let request = NSFetchRequest(entityName: "Kost")
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0{
                for item in results as! [NSManagedObject]{
                    let opbrengst: Bool = item.valueForKey("opbrengst") as! Bool
                    let naam: String = item.valueForKey("naam") as! String
                    let bedrag: Double = item.valueForKey("bedrag") as! Double
                    let beschrijving: String = item.valueForKey("beschrijving") as! String
                    let datum: NSDate = item.valueForKey("datum") as! NSDate
                    let categorie: String = item.valueForKey("categorie") as! String
                    
                    model.kosten.append(Kost(opbrengst: opbrengst ,naam: naam, beschrijving: beschrijving, bedrag: bedrag ,datum: datum , categorie: categorie))
                }
            }
        }catch{
            
        }
        
        
    }
    
    private func setTotaal(){
        totaalLabel.text = ("€  \(model.berekenTotaal())")
    }
    
    private func setInkomsten(){
        inkomstenLabel.text = ("€  \(model.inkomsten)")
    }
    
    private func setKosten(){
        kostenLabel.text = ("€  \(model.uitgaves)")
    }
    
    
    
    

}