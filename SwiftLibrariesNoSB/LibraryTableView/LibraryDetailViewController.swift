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
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let addressLabel: UILabel = {
        let address = UILabel()
        address.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        address.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        address.font = UIFont.systemFont(ofSize: 17)
        address.textAlignment = .natural
        address.translatesAutoresizingMaskIntoConstraints = false
        return address
    }()
  
    private let phoneTextView: UITextView = {
        let phone = UITextView()
        phone.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        phone.textColor = .link
        phone.font = UIFont.systemFont(ofSize: 17)
        phone.textAlignment = .natural
        phone.dataDetectorTypes = [.phoneNumber]
        phone.translatesAutoresizingMaskIntoConstraints = false
        return phone
    }()
    
    private let hoursLabel: UILabel = {
        let hours = UILabel()
        hours.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        hours.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hours.font = UIFont.systemFont(ofSize: 17)
        hours.textAlignment = .natural
        hours.numberOfLines = 0
        hours.translatesAutoresizingMaskIntoConstraints = false
        return hours
    }()

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
        mapView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
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
            print(error) // TODO: error handling
        }
        if numberOfMatches == 0 { // so far, only a phone number and a "closed for construction" message has been here
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
