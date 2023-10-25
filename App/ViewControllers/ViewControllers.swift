//
//  ViewControlles.swift
//  MobileAppSourceCodeV1
//
//  Created by Kaushal Chaudhary on 25/10/23.
//

import Foundation
import UIKit

class Home: BaseViewController {
    
}
class All: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/collections/all")!)
        }
        set{}
    }
}
class Account: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/account")!)
        }
        set{}
    }
}
class Cart: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/cart")!)
        }
        set{}
    }
}
