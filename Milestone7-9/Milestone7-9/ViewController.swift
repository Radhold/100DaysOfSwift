//
//  ViewController.swift
//  Milestone7-9
//
//  Created by Yaroslav Fomenko on 18.08.2021.
//

import UIKit

class ViewController: UIViewController {
    var mistakeLabel: UILabel!
    var titleLabel: UILabel!
    var letterButtons = [UIButton]()
    var currentAnswer: UITextField!
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var words = [String]()
    var activatedButtons = [UIButton]()
    var word: String = ""
    var usedLetters = [String]()
    var mistakes = 0 {
        didSet {
            mistakeLabel.text = "Mistakes: \(mistakes)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        mistakeLabel = UILabel()
        mistakeLabel.translatesAutoresizingMaskIntoConstraints = false
        mistakeLabel.textAlignment = .right
        mistakeLabel.text = "Mistakes: 0"
        view.addSubview(mistakeLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 44)
        titleLabel.text = "Виселица"
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 34)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        let viewWidth = UIScreen.main.bounds.width - 10
        let viewHeight = UIScreen.main.bounds.height/3
        
        NSLayoutConstraint.activate([
            mistakeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            mistakeLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: mistakeLabel.bottomAnchor, constant: 50),

            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // make the clues label 60% of the width of our layout margins, minus 100
            titleLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentAnswer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: viewWidth),
            buttonsView.heightAnchor.constraint(equalToConstant: viewHeight),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = Int(viewWidth - 10) / 6
        let height = Int(viewHeight - 10) / 5

        // create 20 buttons as a 4x5 grid
        for row in 0..<5 {
            for col in 0..<6 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("?", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        for (index, letter) in letterButtons.enumerated() {
            if index < 24 {
                letter.setTitle(letters[index], for: .normal)
            }
            else if index > 25 && index < 28 {
                letter.setTitle(letters[index-2], for: .normal)
            }
        }
        for button in letterButtons {
                    if button.titleLabel?.text == "?" {
                        button.isHidden = true
                    }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newGame(action:)))
        performSelector(inBackground: #selector(loadWords), with: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text?.lowercased() else { return }
        usedLetters.append(buttonTitle)
        currentAnswer.text! = ""
        if !word.contains(buttonTitle)
        {
            mistakes += 1
        }
        for letter in word {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                currentAnswer.text! += strLetter
            } else {
                currentAnswer.text! += "?"
            }
        }
        activatedButtons.append(sender)
        sender.isHidden = true
        if mistakes == 7 {
            let ac = UIAlertController(title: "Looser", message: "You lose", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Oh shit", style: .default, handler: newGame))
            present(ac, animated: true)
        }
        if !currentAnswer.text!.contains("?")
        {
            let ac = UIAlertController(title: "Well done!", message: "You won!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "I'm God", style: .default, handler: newGame))
            present(ac, animated: true)
        }
    }
    
    @objc func loadWords() {
        if let levelFileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for line in lines {
                    words.append(line)
                }
            }
        }
        performSelector(onMainThread: #selector(newGame), with: nil, waitUntilDone: false)
    }
    @objc func newGame(action: UIAlertAction) {
        currentAnswer.text! = ""
        mistakes = 0
        usedLetters.removeAll()
        for buttons in activatedButtons {
            buttons.isHidden = false
        }
        activatedButtons.removeAll()
        word = words.randomElement()!
        print (word)
        for _ in word {
            currentAnswer.text! += "?"
        }
    }
}

