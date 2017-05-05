//
//  UCCompletionTextFieldDelegate.swift
//  UCCompletionTextField
//
//  Created by Mohamed on 5/05/17.
//  Copyright © 2017 mohamedz. All rights reserved.
//

import Foundation

protocol UCCompletionTextFieldDelegate {
    func dataForPopoverInTextField(_ textField: UCCompletionTextField) -> [String]!
    func textFieldShouldSelect(_ textField: UCCompletionTextField) -> Bool
}
