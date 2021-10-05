//
//  LibraryDetailViewController.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 9/22/21.
//

import UIKit
import MapKit

class LibraryDetailViewController: UIViewController {
    
    var library: Library?
    
    convenience init(library: Library) {
        self.init()
        self.library = library
    }
    
    private let mapView = LibraryMapView()
    private let addressLabel = LibraryLabel()
    private let hoursLabel = LibraryLabel(numberOfLines: 0)
    private let phoneTextView = LibraryPhoneTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(addressLabel)
        view.addSubview(phoneTextView)
        view.addSubview(hoursLabel)
        setupAutoLayout()
        setupUI()
    }
    
    private func setupAutoLayout() {
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        phoneTextView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        phoneTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        phoneTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        phoneTextView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        hoursLabel.topAnchor.constraint(equalTo: phoneTextView.bottomAnchor, constant: 20).isActive = true
        hoursLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        hoursLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupUI() {
        title = library?.name
        annotateMap()
        addressLabel.text = library?.address
        parsePhoneNumber()
        hoursLabel.text = library?.hoursOfOperation?.formattedHours
    }
    
    private func parsePhoneNumber() {
        guard let phone = library?.phone else { return }
        var numberOfMatches = 0
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            numberOfMatches = detector.numberOfMatches(in: phone, range: NSRange(phone.startIndex..., in: phone))
        } catch {
            self.showErrorDialogWithMessage(message: error.localizedDescription)
        }
        if numberOfMatches == 0 { // if no phnone number here, a "closed for construction" message is the only other result, so...
            phoneTextView.textColor = #colorLiteral(red: 0.9952842593, green: 0.1894924343, blue: 0.3810988665, alpha: 1)
            phoneTextView.text = phone
        } else {
            phoneTextView.text = "Phone: \(phone)"
        }
    }
    
    private func annotateMap() {
        guard let latitudeString = library?.location?.latitude,
              let longitudeString = library?.location?.longitude,
              let lat = Double(latitudeString),
              let lon = Double(longitudeString) else { return }
        let zoomLocation = CLLocationCoordinate2D.init(latitude: lat,
                                                       longitude: lon)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = library?.name
        mapView.addAnnotation(point)
        mapView.setRegion(mapView.regionThatFits(viewRegion), animated: true)
    }
}
