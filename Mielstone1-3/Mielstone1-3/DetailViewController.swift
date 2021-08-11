//
//  DetailViewController.swift
//  Mielstone1-3
//
//  Created by Yaroslav Fomenko on 09.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var image: UIImageView!
    var selectedImage: String?
    var selectedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryName.text = selectedCountry
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage {
            image.image  = UIImage(named: imageToLoad)
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @objc func shareTapped() {
        guard let image = image.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image, "It's \(selectedCountry!)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
