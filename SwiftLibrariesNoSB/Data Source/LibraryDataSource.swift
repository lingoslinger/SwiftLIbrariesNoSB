//
//  LibraryDataSource.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 9/28/21.
//

import Foundation
import UIKit

class LibraryDataSource: NSObject {
    var libraryDictionary = Dictionary<String, [Library]>()
    var sectionTitles: [String] {
        get {
            let unsortedLetters = libraryDictionary.keys
            return unsortedLetters.sorted()
        }
        set { }
    }
    
    func getLibraryData(_ completion: @escaping () -> Void) {
        if libraryDictionary.isEmpty {
            newDataRequest(completion)
        }
    }
    
    private func newDataRequest(_ completion: @escaping () -> Void) {
        guard let URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else { return }
        URLSession.shared.dataTask(with: URL) { data, response, error in
            if (error == nil) {
                let decoder = JSONDecoder()
                guard let libraryArray = try? decoder.decode([Library].self, from: data!) else {
                    fatalError("Unable to decode JSON library data")
                }
                self.setupSectionsWithLibraryArray(libraryArray)
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: completion handler to tableview showing error
                    // self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
                }
            }
        }.resume()
    }
    
    private func setupSectionsWithLibraryArray(_ libraryArray: [Library]) {
        for library in libraryArray {
            let firstLetterOfName = String.init(library.name?.first ?? Character.init(""))
            if (libraryDictionary[firstLetterOfName] == nil) {
                let sectionArray = [Library]()
                libraryDictionary[firstLetterOfName] = sectionArray
            }
            libraryDictionary[firstLetterOfName]?.append(library)
        }
    }
    
    func currentLibrary(_ indexPath: IndexPath) -> Library? {
        let sectionTitle = sectionTitles[indexPath.section]
        let sectionArray = libraryDictionary[sectionTitle]
        return sectionArray?[indexPath.row]
    }

}

extension LibraryDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        let sectionArray = libraryDictionary[sectionTitle]
        return sectionArray?.count ?? 0
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath)
        let library = currentLibrary(indexPath)
        cell.textLabel?.text = library?.name
        return cell
    }
}
