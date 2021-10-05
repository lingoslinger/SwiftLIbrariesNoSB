//
//  LibraryMapView.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit
import MapKit

class LibraryMapView: MKMapView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
