import UIKit
import CoreData

class OverViewController:UITableViewController
{
    private var model = KostModel()
    private let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        getDataFromDatabase()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return model.kosten.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("previewKostCell", forIndexPath: indexPath) as! PreviewKostCell
        
        let kost = model.kosten[indexPath.row]
        if(kost.opbrengst){
            cell.backgroundColor = UIColor.greenColor()
        }else{
            cell.backgroundColor = UIColor.redColor()
        }
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        cell.naamLabel.text = ("\(kost.naam)")
        cell.beschrijvingLabel.text = ("\(kost.beschrijving)")
        cell.datumLabel.text = ("\(formatter.stringFromDate(kost.datum))")
        cell.prijsLabel.text = ("€ \(kost.bedrag)")
        cell.categorieLabel.text = ("Categorie: \(kost.categorie)")
        return cell
    }
    
    //het is niet gelukt om data te verwijderen uit de databank.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.beginUpdates()
            model.kosten.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.toolbarHidden = false
    }

    
    @IBAction func unwindFromAdd(segue: UIStoryboardSegue){
        let addController = segue.sourceViewController as! AddController
        if let kost = addController.kost{
            tableView.beginUpdates()
            putDataInDatabase(kost)
            model.kosten.append(kost)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: model.kosten.count - 1, inSection: 0)], withRowAnimation: .Automatic)
            tableView.endUpdates()
           
        }
    }
    
    private func putDataInDatabase(kost : Kost){
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newKost = NSEntityDescription.insertNewObjectForEntityForName("Kost", inManagedObjectContext: context)
        
        newKost.setValue(kost.opbrengst, forKey: "opbrengst")
        newKost.setValue(kost.naam, forKey: "naam")
        newKost.setValue(kost.beschrijving, forKey: "beschrijving")
        newKost.setValue(kost.bedrag, forKey: "bedrag")
        newKost.setValue(kost.datum, forKey: "datum")
        newKost.setValue(kost.categorie, forKey: "categorie")
        
        do{
            try context.save()
        }catch{
            print("There was an error saving data")
        }
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
    
    
}

