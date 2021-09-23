//
//  LilbraryViewController.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 9/21/21.
//

import UIKit

class LibraryViewController: UIViewController {
    var libraryArray = [Library]()
    var sectionDictionary = Dictionary<String, [Library]>()
    var sectionTitles = [String]()

    let libraryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.dataSource = self
        libraryTableView.delegate = self
        libraryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "libraryCell")
        view.addSubview(libraryTableView)
        libraryTableView.translatesAutoresizingMaskIntoConstraints = false
        setupAutoLayout()
        setupNavigation()
        newDataRequest()
    }

    private func setupAutoLayout() {
        libraryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        libraryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        libraryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        libraryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupNavigation() {
        navigationItem.title = "Chicago Libraries"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func newDataRequest() {
        guard let URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        URLSession.shared.dataTask(with: URL) { data, response, error in
            if (error == nil) {
                let decoder = JSONDecoder()
                guard let libraryArray = try? decoder.decode([Library].self, from: data!) else {
                    fatalError("Unable to decode JSON library data")
                }
                self.libraryArray = libraryArray
                DispatchQueue.main.async {
                    self.setupSectionsWithLibraryArray()
                    self.libraryTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
                }

            }
        }.resume()
    }
    
    private func setupSectionsWithLibraryArray() {
        for library in libraryArray {
            let firstLetterOfName = String.init(library.name?.first ?? Character.init(""))
            if (sectionDictionary[firstLetterOfName] == nil) {
                let sectionArray = [Library]()
                sectionDictionary[firstLetterOfName] = sectionArray
            }
            sectionDictionary[firstLetterOfName]?.append(library)
        }
        let unsortedLetters = sectionDictionary.keys
        sectionTitles = unsortedLetters.sorted()
        
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        let sectionArray = sectionDictionary[sectionTitle]
        return sectionArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath)
        let library = currentLibrary(indexPath)
        cell.textLabel?.text = library?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let library = currentLibrary(indexPath)
        let detail = LibraryDetailViewController()
        detail.library = library
        navigationItem.backButtonTitle = "List"
        navigationController?.pushViewController(detail, animated: true)
    }
    
    private func currentLibrary(_ indexPath: IndexPath) -> Library? {
        let sectionTitle = sectionTitles[indexPath.section]
        let sectionArray = sectionDictionary[sectionTitle]
        return sectionArray?[indexPath.row]
    }
}
