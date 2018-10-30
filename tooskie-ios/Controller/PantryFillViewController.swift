import UIKit

class PantryFillViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
//    Properties
    let tooskiePantry = Pantry(name: "Tooskie pantry")
    var userPantry = Pantry(name: "iOS")
    var serverConfig = ServerConfig()
    private var pantryPosted = false {
        didSet {
            self.getRecipes()
        }
    }
    private var recipes = [Recipe](){
        didSet {
            performSegue(withIdentifier: "RecipeSuggestion", sender: self)
        }
    }
    private var keyboardIsVisible = false

//    Outlets
    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchRecipesButton: UIButton!
    
//    Actions
    @IBAction func launchRecipes(_ sender: Any) {
        print("Launch")
        self.sendPantry()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        print("Touch")
        self.ingredientSearchBar.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboardSwipe(_ sender: UIPanGestureRecognizer) {
        print("Swipe")
        let translation = sender.translation(in: self.view)
        if translation.y > 0 && abs(translation.y) > abs(translation.x) {
            self.ingredientSearchBar.resignFirstResponder()
        }
        if translation.y < 0 && abs(translation.y) > abs(translation.x) {
            self.ingredientSearchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPantry()
        self.loadUserPantry()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        self.pantryTableView.rowHeight = 60.0
        ingredientSearchBar.delegate = self
        ingredientSearchBar.backgroundImage = UIImage()
        print("View did load")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : RecipeSuggestionViewController = segue.destination as! RecipeSuggestionViewController
        destVC.recipes = self.recipes
    }
    
    @objc
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        self.keyboardIsVisible = true
    }
    
    @objc
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
        self.keyboardIsVisible = false
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        if self.keyboardIsVisible == show {
            return
        }
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height - self.launchRecipesButton.frame.height - self.searchBarConstraint.constant) * (show ? 1 : -1)
        self.pantryTableView.isUserInteractionEnabled = !show
        self.launchRecipesButton.isHidden = show
        self.bottomConstraint.constant += changeInHeight
        UIView.animate(withDuration: animationDurarion) {
            self.view.layoutIfNeeded()
            if self.userPantry.count > 0 {
                let indexPath = IndexPath(row: self.userPantry.count-1, section: 0)
                self.pantryTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            self.pantryTableView.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search and add ingredient")
        self.addIngredient()
    }
    
// Handle ingredients
    
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
    
    func removeIngredient(ingredient: Ingredient) {
        let potentialIndexIngredient = self.userPantry.getIndex(ingredient: ingredient)
        if let indexIngredient = potentialIndexIngredient {
            self.userPantry.removeIngredient(ingredient: ingredient)
            let indexPath = IndexPath(item: indexIngredient, section: 0)
            pantryTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    Table View methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }

        let ingredient = self.userPantry.getIngredient(index: indexPath.row)
        cell.ingredient = ingredient
        cell.viewController = self
        cell.ingredientName.text = ingredient.getName()
        if let pictureData = ingredient.getPictureData() {
            cell.ingredientPicture.image = UIImage(data: pictureData)
        }
        else {
            cell.ingredientPicture.image = UIImage(named: "NoNetwork")
        }
        return cell
    }
    
    private func reload(){
        self.pantryTableView.reloadData()
        self.scrollToBottom()
    }
    
    private func scrollToBottom(){
        DispatchQueue.main.async {
            if self.userPantry.count > 0 {
                let indexPath = IndexPath(row: self.userPantry.count-1, section: 0)
                self.pantryTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
//    API requests
    
    func loadPantry() {
        let request = self.serverConfig.getRequest(path: "/api/ingredient/", method: "GET")
        let session = self.serverConfig.getSession()
         let task = session.dataTask(with: request) { (data, response, responseError) in
            DispatchQueue.main.async {
                if let response = response {
                    print(response)
                }
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = data {
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
    
    func loadUserPantry() {
        if let permaname = userPantry.permaname {
            let request = self.serverConfig.getRequest(path: "/api/pantry/" + permaname, method: "GET")
            let session = self.serverConfig.getSession()
            let task = session.dataTask(with: request) { (data, response, responseError) in
                DispatchQueue.main.async {
                    if let response = response {
                        print(response)
                    }
                    if let error = responseError {
                        print(error.localizedDescription)
                    } else if let jsonData = data {
                        let decoder = JSONDecoder()
                        do {
                            let ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                            self.userPantry.setIngredientList(list: ingredients)
                            self.reload()
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
    }
    
    func sendPantry() {
        let myPost = userPantry.toPost()
        var request = self.serverConfig.getRequest(path: "/api/pantry/", method: "POST")
        let session = self.serverConfig.getSession()
        request = self.serverConfig.encodeDataForPost(post: myPost, request: request)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                self.pantryPosted = true
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    public func getRecipes() {
        if let permaname = self.userPantry.permaname {
            let session = self.serverConfig.getSession()
            let request = self.serverConfig.getRequest(path: "/api/recipe-with-pantry/" + permaname, method: "GET")
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        print(error.localizedDescription)
                    } else if let jsonData = responseData {
                        let decoder = JSONDecoder()
                        do {
                            let recipes = try decoder.decode([Recipe].self, from: jsonData)
                            self.recipes = recipes
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
    }
}


