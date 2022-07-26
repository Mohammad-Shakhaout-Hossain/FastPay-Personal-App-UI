//
//  PasswordChecker.swift
//  Fastpay
//
//  Created by Anamul Habib on 5/31/20.
//  Copyright © 2020 Fastpay. All rights reserved.
//

import Foundation

enum PasswordRule{
    case oneCapitalLetter
    case oneLowercaseLetter
    case oneNumber
    case oneSymbol
    case eightCharacters
}

class PasswordChecker{
    
    let firstName: String
    let lastName: String
    let password: String
    
    init(firstName: String, lastName: String, password: String) {
        
        self.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = password
    }
    
    func check() -> Array<PasswordRule>? {
        
        var missingRules = Array<PasswordRule>()
        
        if !NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password){
            missingRules.append(.oneCapitalLetter)
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password){
            missingRules.append(.oneLowercaseLetter)
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: password){
            missingRules.append(.oneSymbol)
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password){
            missingRules.append(.oneNumber)
        }
        
        if password.count < 8{
            missingRules.append(.eightCharacters)
        }
        
        return missingRules.count > 0 ? missingRules : nil
    }
}
