//
//  LibraryPhoneTextView.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit

class LibraryPhoneTextView: UITextView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textColor = .link
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .natural
        dataDetectorTypes = [.phoneNumber]
        translatesAutoresizingMaskIntoConstraints = false
    }
}
