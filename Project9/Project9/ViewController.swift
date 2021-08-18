//
//  ViewController.swift
//  Project 7
//
//  Created by Yaroslav Fomenko on 16.08.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits () {
        let ac = UIAlertController(title: "Credits", message: "Data provided by the We The People API of whitehouse.gov", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        }
    @objc func filterPetitions() {
           let ac = UIAlertController(title: "Search", message: "Find petitions", preferredStyle: .alert)
           ac.addTextField()
           
           let searchAction = UIAlertAction(title: "Search", style: .default) {
               [weak self, weak ac] item in
               guard let item = ac?.textFields?[0].text else { return }
               self?.submit(item)
           }
           
           ac.addAction(searchAction)
           present(ac, animated: true)
       }

    func submit(_ item: String) {
        // Empty out the filteredPetitions
        filteredPetitions.removeAll()
        
        // Get lowercased version of the search word
        let item = item.lowercased()
        
        // Look through the array of Structs for the term
        // and copy those entries into filteredPetitions
        if item != "" {
            for petition in petitions {
                if petition.title.lowercased().contains(item) || petition.body.lowercased().contains(item) {
                    filteredPetitions.append(petition)
                }
            }
        }
        if filteredPetitions.isEmpty {
            filteredPetitions = petitions
            let ac = UIAlertController(title: "Oops", message: "Nothing found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        // Reload the tableView
        tableView.reloadData()
            
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

