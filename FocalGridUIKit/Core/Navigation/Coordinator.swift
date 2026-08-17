//
//  Coordinator.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
