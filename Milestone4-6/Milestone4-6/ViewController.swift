//
//  ViewController.swift
//  Milestone4-6
//
//  Created by Yaroslav Fomenko on 15.08.2021.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping list"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [add, share]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clear))

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] item in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item: item)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func clear() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func submit(item: String) {
        if !shoppingList.contains(item.lowercased()) && item.count > 0 {
            shoppingList.insert(item.lowercased(), at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        else {
            let ac = UIAlertController(title: "Oops", message: "It's already exist or empty line", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
    }
    
    @objc func share() {
            let list = shoppingList.joined(separator: "\n")
            
            let avc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
            avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(avc, animated: true)
        }


}

