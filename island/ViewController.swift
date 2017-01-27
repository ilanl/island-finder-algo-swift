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
        
        let p = self.map![indexPath.row]!
        cell.backgroundColor = p.getColor()
        return cell
    }
    
    
    //MARK: -
    //MARK: Actions
    @IBAction func didPressRefresh(_ sender: Any) {
        self.mapCollection.reloadData()
    }
    
    @IBAction func didPressNewMap(_ sender: UIButton) {
        
        self.solveButton.setTitle("Solve!", for: .normal)

        self.map = MapGenerator(rows: 10, columns: 10, percentageOfLand: 60).random()
        
        self.mapCollection.reloadData()
        self.solveButton.isEnabled = true
    }
    
    @IBAction func didPressSolve(_ sender: Any) {
        
        guard let _map = map else { return }
        
        if (solveButton.titleLabel?.text == "Solve again!"){
            self.map!.reset()
        }
        
        self.solveButton.setTitle("Solve again!", for: .normal)
        
        let result = IslandFinder(map: self.map!).getCount { [weak self] p in
            guard let weakSelf = self else { assertionFailure("fatal error"); return  }
            DispatchQueue.main.async {
                let pointIndex = _map.columns * p.x + p.y
                weakSelf.mapCollection.reloadItems(at: [IndexPath(row: pointIndex , section: 0)])
            }
        }
        self.alert(message: "Found \(result) islands")
        self.mapCollection.reloadData()
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

