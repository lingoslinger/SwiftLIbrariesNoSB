//
//  LibraryLabel.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit

class LibraryLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    convenience init(numberOfLines: Int) {
        self.init()
        self.numberOfLines = numberOfLines
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .natural
        translatesAutoresizingMaskIntoConstraints = false
    }
}
