//
//  ViewController+ErrorDialog.swift
//  RadioStations
//
//  Created by Allan Evans on 12/5/18.
//  Copyright © 2018 - 2021 Allan Evans. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorDialogWithMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.navigationController?.pushViewController(alert, animated: true)
    }
}
