import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let tooskiePantry = Pantry(name: "Tooskie pantry")
    var userPantry = Pantry(name: "User pantry")
    var serverConfig = ServerConfig()

    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!

    @IBAction func launchRecipes(_ sender: Any) {
        print("Launch")
        self.loadPantry()
    }
    
    @IBAction func ingredientSearch(_ sender: Any) {
        print("Add")
        self.addIngredient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPantry()
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        ingredientSearchBar.delegate = self
        print("View did load")
    }
    
    func loadPantry() {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.serverConfig.getUrlScheme()
        urlComponents.host = self.serverConfig.getUrlHost()
        urlComponents.path = "/ingredient/"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                        self.tooskiePantry.setIngredientList(list: ingredients)
                    } catch {
                        print("Error")
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func addIngredient(){
        if let text = ingredientSearchBar.text {
            if let chosenIngredient = self.tooskiePantry.getIngredientByName(ingredientName: text.capitalize()){
                self.addAndDisplayNewIngredient(ingredient: chosenIngredient)
            }
            else {
                self.alertIngredientNotAvailable()
            }
        }
    }
    
    func addAndDisplayNewIngredient(ingredient: Ingredient) {
        userPantry.addIngredient(ingredient: ingredient)
        self.reload()
        self.ingredientSearchBar.text = ""
    }
    
    func alertIngredientNotAvailable() {
        let alert = UIAlertController(title: "Erreur", message: "Cet ingrédient n'est pas disponible", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }

        let ingredient = self.userPantry.getIngredient(index: indexPath.row)
        cell.configure(ingredient: ingredient, viewController: self)
        return cell
    }
    
    func removeIngredient(ingredient: Ingredient) {
        let potentialIndexIngredient = self.userPantry.getIndex(ingredient: ingredient)
        if let indexIngredient = potentialIndexIngredient {
            self.userPantry.removeIngredient(ingredient: ingredient)
            let indexPath = IndexPath(item: indexIngredient, section: 0)
            pantryTableView.deleteRows(at: [indexPath], with: .fade)
            self.reload()
        }
    }
    
    private func reload(){
        self.pantryTableView.reloadData()
        self.scrollToBottom()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.userPantry.count-1, section: 0)
            self.pantryTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}


