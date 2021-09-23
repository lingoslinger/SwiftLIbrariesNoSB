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
        address.backgroundColor = .white
        address.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        address.font = UIFont.systemFont(ofSize: 17)
        address.textAlignment = .natural
        address.translatesAutoresizingMaskIntoConstraints = false
        return address
    }()

    private let phoneLabel: UILabel = {
        let phone = UILabel()
        phone.backgroundColor = .white
        phone.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phone.font = UIFont.systemFont(ofSize: 17)
        phone.textAlignment = .natural
        phone.translatesAutoresizingMaskIntoConstraints = false
        return phone
    }()
    
    private let hoursLabel: UILabel = {
        let hours = UILabel()
        hours.backgroundColor = .white
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
        view.addSubview(phoneLabel)
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
        
        phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        phoneLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        hoursLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 20).isActive = true
        hoursLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        hoursLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 168).isActive = true
    }
    
    private func setupUI() {
        annotateMap()
        title = library?.name
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
        if numberOfMatches == 0 {
            phoneLabel.textColor = #colorLiteral(red: 0.9952842593, green: 0.1894924343, blue: 0.3810988665, alpha: 1)
            phoneLabel.text = phone
        } else {
            phoneLabel.text = "Phone: \(phone)"
        }
    }
    
    private func annotateMap() {
        let latitudeString = library?.location?.latitude ?? ""
        let longitudeString = library?.location?.longitude ?? ""
        let zoomLocation = CLLocationCoordinate2D.init(latitude: Double(latitudeString) ?? 0.0, longitude: Double(longitudeString) ?? 0.0)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = library?.name
        mapView.addAnnotation(point)
        mapView.setRegion(mapView.regionThatFits(viewRegion), animated: true)
    }
}
