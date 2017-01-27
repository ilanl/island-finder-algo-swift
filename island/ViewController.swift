import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var map: Map?
    
    @IBOutlet weak var solveButton: UIButton!
    @IBOutlet weak var mapCollection: UICollectionView!
    
    //MARK: -
    //MARK: Draw map
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let totalNumberOfCells = self.map == nil ? 0 : self.map!.columns * self.map!.rows
        return totalNumberOfCells
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        guard let p = self.map![indexPath.row] else { return cell }
        cell.backgroundColor = p.getColor()
        
        return cell
    }
    
    
    //MARK: -
    //MARK: Actions
    @IBAction func didPressNewMap(_ sender: UIButton) {
        
        self.map = RandomMapGenerator(rows: 10, columns: 10, probability: arc4random_uniform(100)).newMap()
        self.mapCollection.reloadData()
        self.solveButton.isEnabled = true
    }
    
    @IBAction func didPressSolve(_ sender: Any) {
        
        guard let _ = map, self.solveButton.isEnabled else { return }
        self.solveButton.isEnabled = false
        let result = IslandFinder(map: self.map!).findIslandsCount()
        self.mapCollection.reloadData()
        self.alert(message: "Found \(result) islands")
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

