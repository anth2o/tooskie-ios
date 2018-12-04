import UIKit

class PantryFillViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private var pantryPosted = false {
        didSet {
            self.getRecipes()
        }
    }
    private var recipes = GlobalVariables.recipes{
        didSet {
            GlobalVariables.recipes = recipes
            if recipes.count > 0 {
                performSegue(withIdentifier: "RecipeSuggestion", sender: self)
            }
            else {
                performSegue(withIdentifier: "PantryToShopping", sender: self)
            }
        }
    }
    private var keyboardIsVisible = false
    private let minLettersSuggestion = 1
    private let numberWordsSuggested = 3
    private var currentIngredient: Ingredient?
    
    struct SuggestedWord {
        var button = UIButton()
        var ingredient: Ingredient?
        
        init(button: UIButton){
            self.button = button
        }
    }
    
    private var listSuggestedWord  = [SuggestedWord]()

//    Outlets
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    @IBOutlet weak var launchButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingredientsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var launchRecipesButton: UIButton!
    @IBOutlet weak var toolbar: UIStackView!
    @IBOutlet weak var suggestionBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionBar: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tintView: UIView!
    
    //    Actions
    @IBAction func launchRecipes(_ sender: Any) {
        print("Launch")
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.tintView.isHidden = false
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
    
    @objc func pressButton(_ button: UIButton) {
        if let ingredient = self.listSuggestedWord[button.tag].ingredient {
            self.addAndDisplayNewIngredient(ingredient: ingredient)
            self.clearSuggestions()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        self.loadPantry()
        self.loadUserPantry()
        pantryTableView.rowHeight = 60.0
        ingredientSearchBar.delegate = self
        ingredientSearchBar.backgroundImage = UIImage()
        ingredientsView.setBorder(borderWidth: 3.0)
        suggestionBar.isHidden = true
        suggestionBar.setBorder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.pantryTableView.scrollToBottom()
        self.addSubviews()
        self.activity.isHidden = true
        self.configureTintView()
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
        self.pantryTableView.isUserInteractionEnabled = !show
        self.mainViewBottomConstraint.constant += keyboardFrame.height * (show ? 1 : -1)
        self.ingredientsViewBottomConstraint.constant -= (self.launchRecipesButton.frame.height + self.launchButtonBottomConstraint.constant - self.suggestionBar.frame.height + self.toolbar.frame.height) * (show ? 1 : -1)
        self.suggestionBarBottomConstraint.constant -= keyboardFrame.height * (show ? 1 : -1)
        self.pantryTableView.scrollToBottom()
        UIView.animate(withDuration: animationDurarion) {
            self.launchRecipesButton.isHidden = show
            self.suggestionBar.isHidden = !show
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search and add ingredient")
        self.addIngredient()
    }
    
    func addSubviews() {
        for i in 0..<self.numberWordsSuggested {
            let subview = UIButton()
            subview.backgroundColor = UIColor.lightGray
            subview.titleLabel?.textAlignment = .center
            subview.setTitle("", for: .normal)
            subview.tag = i
            subview.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
            subview.heightAnchor.constraint(equalToConstant: self.suggestionBar.frame.height).isActive = true
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.titleLabel?.lineBreakMode = .byTruncatingTail
            self.suggestionBar.addArrangedSubview(subview)
            let suggestedWord = SuggestedWord(button: subview)
            self.listSuggestedWord.append(suggestedWord)
        }
    }
    
    private func configureTintView() {
        self.tintView.backgroundColor = UIColor.darkGray
        self.tintView.alpha = 0.5
        self.tintView.isHidden = true
    }
    
// Handle ingredients
    
    func addIngredient(){
        if let text = ingredientSearchBar.text {
            if let chosenIngredient = GlobalVariables.tooskiePantry.getIngredientByName(ingredientName: text.capitalize()){
                if GlobalVariables.userPantry.contains(ingredient: chosenIngredient) {
                    self.alertIngredientAlreadyThere()
                    self.ingredientSearchBar.text = ""
                }
                else {
                    self.addAndDisplayNewIngredient(ingredient: chosenIngredient)
                }
            }
            else {
                self.alertIngredientNotAvailable()
            }
        }
    }
    
    func addAndDisplayNewIngredient(ingredient: Ingredient) {
        GlobalVariables.userPantry.addIngredient(ingredient: ingredient)
        self.reload()
        self.ingredientSearchBar.text = ""
    }
    
    func alertIngredientNotAvailable() {
        let alert = UIAlertController(title: "Erreur", message: "Cet ingrédient n'est pas disponible", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertIngredientAlreadyThere() {
        let alert = UIAlertController(title: "Déjà là", message: "Cet ingrédient est déjà présent dans le garde-manger", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeIngredient(ingredient: Ingredient) {
        let potentialIndexIngredient = GlobalVariables.userPantry.getIndex(ingredient: ingredient)
        if let indexIngredient = potentialIndexIngredient {
            GlobalVariables.userPantry.removeIngredient(ingredient: ingredient)
            let indexPath = IndexPath(item: indexIngredient, section: 0)
            pantryTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    Table View methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }

        let ingredient = GlobalVariables.userPantry.getIngredient(index: indexPath.row)
        cell.ingredient = ingredient
        cell.viewController = self
        cell.ingredientName.text = ingredient.getName()
        if let pictureData = ingredient.getPictureData() {
            cell.ingredientPicture.image = UIImage(data: pictureData)
        }
        else {
            cell.ingredientPicture.image = UIImage(named: "NoNetwork")
        }
        if #available(iOS 11.0, *) {
            cell.userInteractionEnabledWhileDragging = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func reload(){
        self.pantryTableView.reloadData()
        self.pantryTableView.scrollToBottom()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= minLettersSuggestion {
            let tempIngredientList = GlobalVariables.tooskiePantry.getIngredientsByPrefix(prefix: searchText)
            var ingredientCount = 0
            var wordSuggestedCount = 0
            while ingredientCount < tempIngredientList.count && wordSuggestedCount < self.numberWordsSuggested {
                let tempIngredient = tempIngredientList[ingredientCount]
                if !GlobalVariables.userPantry.contains(ingredient: tempIngredient) {
                    self.listSuggestedWord[wordSuggestedCount].button.setTitle(tempIngredient.getName(), for: .normal)
                    self.listSuggestedWord[wordSuggestedCount].ingredient = tempIngredient
                    wordSuggestedCount += 1
                }
                ingredientCount += 1
            }
        }
        else {
            self.clearSuggestions()
        }
    }
    
    private func clearSuggestions() {
        for i in 0..<self.numberWordsSuggested {
            self.listSuggestedWord[i].button.setTitle("", for: .normal)
        }
    }
    
//    API requests
    
    func loadPantry() {
        if GlobalVariables.tooskiePantry.count > 0 {
            return
        }
        let request = GlobalVariables.serverConfig.getRequest(path: "/api/ingredient/", method: "GET")
        let session = GlobalVariables.serverConfig.getSession()
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
                        GlobalVariables.tooskiePantry.setIngredientList(list: ingredients)
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
        if GlobalVariables.userPantry.count > 0 {
            return
        }
        if let permaname = GlobalVariables.userPantry.permaname {
            let request = GlobalVariables.serverConfig.getRequest(path: "/api/pantry/" + permaname, method: "GET")
            let session = GlobalVariables.serverConfig.getSession()
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
                            GlobalVariables.userPantry.setIngredientList(list: ingredients)
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
        let myPost = GlobalVariables.userPantry.toPost()
        var request = GlobalVariables.serverConfig.getRequest(path: "/api/pantry/", method: "POST")
        let session = GlobalVariables.serverConfig.getSession()
        request = GlobalVariables.serverConfig.encodeDataForPost(post: myPost, request: request)
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
        if let permaname = GlobalVariables.userPantry.permaname {
            let session = GlobalVariables.serverConfig.getSession()
            let request = GlobalVariables.serverConfig.getRequest(path: "/api/recipe-with-pantry/" + permaname, method: "GET")
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


