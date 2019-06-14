import UIKit
import Firebase
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var authUI: FUIAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            btnLogin.setTitle("Logout", for: .normal)
        }
    }

    @IBAction func doBtnCreate(_ sender: Any) {
        if let email = tfEmail.text, let password = tfPassword.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                (authDataResult, error) in
                print(authDataResult?.user.email ?? "no user email")
                print(Auth.auth().currentUser?.uid ?? "no user id")
            }
        }
    }
    
    @IBAction func doBtnLogin(_ sender: Any) {
        let a = Auth.auth().currentUser == nil ? "not logged" : "logged"
        print(a)
        if Auth.auth().currentUser == nil {
            if let authVC = authUI?.authViewController() {
                present(authVC, animated: true, completion: nil)
            }
//            if let email = tfEmail.text, let password = tfPassword.text {
//                Auth.auth().signIn(withEmail: email, password: password) {
//                    (authDataResult, error) in
//                    if error == nil {
//                        self.btnLogin.setTitle("Logout", for: .normal)
//                    }
//                }
//            }
        } else {
            self.logout()
        }
    }
    
    func logout () {
        do {
            try Auth.auth().signOut()
            self.btnLogin.setTitle("Login", for: .normal)
        }
        catch {
            
        }
    }
}

