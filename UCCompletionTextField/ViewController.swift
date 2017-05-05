//
//  ViewController.swift
//  UCCompletionTextField
//
//  Created by Mohamed on 5/05/17.
//  Copyright © 2017 mohamedz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var completionTextField: UCCompletionTextField!
    
    fileprivate var content:[String] = ["John", "Kimberley", "Georges", "William", "Kate", "Harry", "Andrew", "Laurence", "Chelsea", "Samuel", "Eric",
                                        "Jeremy", "Jessica", "Fernando", "Mike", "Anne", "Albessa", "Charles"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.completionTextField.delegate = self
        self.completionTextField.labelPlaceHolder.text = "Begin the search ..."
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

extension ViewController: UCCompletionTextFieldDelegate{
    func textFieldShouldSelect(_ textField: UCCompletionTextField) -> Bool {
         return true
    }
    
    func dataForPopoverInTextField(_ textField: UCCompletionTextField) -> [String]!  {
        textField.content = self.content
        return self.content
    }
}
