import CoreData

struct KostModel
{
    var uitgaves : Double = 0
    var inkomsten : Double = 0
    
    var kosten: [Kost] = [
        /*(Kost(opbrengst: true,naam: "Testdata", beschrijving: "dsbvhsqvshv", bedrag: 5 ,datum:  NSDate() , categorie: "Winkelen")),
        (Kost(opbrengst: false ,naam: "Testdata", beschrijving: "dsbvhsqvshv", bedrag: 5 ,datum:  NSDate() , categorie: "Winkelen")),*/
    ]
    
    mutating func berekenTotaal() -> Double{
        
        for kost in kosten{
            if(kost.opbrengst == true){
                inkomsten += kost.bedrag as Double
            }else{
                uitgaves += kost.bedrag as Double
            }
        }
        return inkomsten - uitgaves
    }
    
}
