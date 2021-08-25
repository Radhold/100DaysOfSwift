//
//  TableViewController.swift
//  Milestone10-12
//
//  Created by Yaroslav Fomenko on 24.08.2021.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var notes = [Note]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let defaults = UserDefaults.standard

        if let note = defaults.object(forKey: "notes") as? Data {
            if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(note) as? [Note] {
                notes = decodedNotes
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let path = getDocumentsDirectory().appendingPathComponent(note.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        cell.imageView?.layer.borderWidth = 5
        cell.textLabel?.text = note.text

        return cell
    }
    
    @objc func createPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            [weak self, weak ac] item in
            guard let item = ac?.textFields?[0].text else { return }
            let note = Note(text: item, image: imageName)
            self?.notes.append(note)
            self?.tableView.reloadData()
            self?.save()
            
        }))
        present(ac, animated: true)

    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func addNote() {
        createPicker()
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: notes, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            let note = notes[indexPath.row]
            let path = getDocumentsDirectory().appendingPathComponent(note.image)
            vc.selectedImage = path
            vc.text = note.text
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
