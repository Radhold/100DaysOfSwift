//
//  ViewController.swift
//  Project2
//
//  Created by Yaroslav Fomenko on 08.08.2021.
//

import UIKit

class ViewController: UIViewController {
    var correctAnswer = 0
    var countries = [String]()
    var score = 0
    var numberOfQuestions = 9
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard

        if let savedHS = defaults.object(forKey: "highScore") as? Data {
            if let decodedHS = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedHS) as? Int {
                highScore = decodedHS
            }
        }
        print(highScore)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(buttTapped))
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        countries+=["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title : String?
        
        if sender.tag == correctAnswer {
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "Wrong! That’s the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            if numberOfQuestions != 10 {present(ac, animated: true)}
        }
        
        if numberOfQuestions == 10 {
            numberOfQuestions = 0
            let gameScore = score
            let newAC = UIAlertController(title: "Final score", message: "Your score is \(score). Game Over.", preferredStyle: .alert)
            newAC.addAction(UIAlertAction(title: "Continue", style: .default) {[unowned self] _ in
                if gameScore > self.highScore {
                    self.highScore = gameScore
                    save()
                    let ac = UIAlertController(title: "High score", message: "New high score is \(highScore).", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Yeeeh", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            })
            present(newAC, animated: true)
            score = 0
            
        }
        askQuestion()
         
    }
    @objc func buttTapped() {
        let ac = UIAlertController(title: "Pause", message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Back to game", style: .default, handler: nil))
        present(ac, animated: true)
    }
    func askQuestion(action: UIAlertAction! = nil) {
        numberOfQuestions += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = ("\(countries[correctAnswer].uppercased()). Your score is \(score)")
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: highScore, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        }
    }
   
}

