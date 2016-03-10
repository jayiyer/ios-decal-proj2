//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var displayedWordLabel: UILabel!
    @IBOutlet weak var hangmanImageView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var checkGuessButton: UIButton!
    @IBOutlet weak var userGuessTextField: UITextField!
    @IBOutlet weak var incorrectGuesses: UILabel!
    
    var userGuessedCharacters: [Character]!
    var placeholderCharacter: Character = "-"
    var spaceCharacter: Character = " "
    var currentPhraseVisible: String?
    var finalCorrectPhrase: String?
    
    var numWrongGuesses: Int?
    let maxNumberMistakes = 6
    var gameOver: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareGame()
        self.newGameButton.addTarget(self, action: "prepareGame", forControlEvents: .TouchUpInside)
        self.checkGuessButton.addTarget(self, action: "buttonTapped", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareGame() {
        self.incorrectGuesses.text      = ""
        self.currentPhraseVisible       = ""
        self.userGuessTextField.text    = ""
        self.gameOver                   = false
        self.numWrongGuesses            = 0
        self.hangmanImageView.image     = UIImage(named: "hangman1.gif")
        self.userGuessedCharacters      = [Character]()
        
        let hangmanPhrases = HangmanPhrases()
        var phrase = hangmanPhrases.getRandomPhrase()!
        self.finalCorrectPhrase = phrase.uppercaseString
        print(phrase)
        
        for c in phrase.characters {
            if c == self.spaceCharacter {
                self.currentPhraseVisible?.append(self.spaceCharacter)
            }
            self.currentPhraseVisible?.append(self.placeholderCharacter)
        }
        
        self.displayedWordLabel.text = self.currentPhraseVisible
    }
    
    func buttonTapped() {
        let currentGuessText = self.userGuessTextField.text!.uppercaseString
        
        if self.gameOver! {
            let alert = UIAlertController(title: "You lost the game", message: "Game over. Press 'New Game' to start a new game.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if currentGuessText.characters.count == 0 || currentGuessText.characters.count > 1 {
            let alert = UIAlertController(title: "Invalid Input", message: "Please only guess one character.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.userGuessTextField.text = ""
        } else {
            let userGuessChar = currentGuessText[currentGuessText.startIndex]
            
            if userGuessedCharacters.contains(userGuessChar) {
                let alert = UIAlertController(title: "Pre-existing Guess", message: "You have already selected letter " + String(userGuessChar) + ".", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if (currentGuessText.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) == nil) {
                let alert = UIAlertController(title: "Invalid Character Type", message: "Please use standard English letters.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if self.finalCorrectPhrase!.rangeOfString(currentGuessText) != nil {
                self.GuessIsCorrect(userGuessChar)
            } else {
                self.GuessIsIncorrect(userGuessChar)
            }
            self.userGuessTextField.text = ""
        }
    }
    
    func GuessIsCorrect(userGuessChar: Character) {
        userGuessedCharacters.append(userGuessChar)
        var count                   = 0
        var numUnrevealedCharsLeft  = 0
        var tempString              = ""
        
        for c in self.finalCorrectPhrase!.characters {
            if c == userGuessChar {
                tempString.append(userGuessChar)
            } else {
                tempString.append(self.currentPhraseVisible![currentPhraseVisible!.startIndex.advancedBy(count)])
                if self.currentPhraseVisible![currentPhraseVisible!.startIndex.advancedBy(count)] == self.placeholderCharacter {
                    numUnrevealedCharsLeft += 1
                }
            }

            count += 1
        }
        
        self.currentPhraseVisible      = tempString
        self.displayedWordLabel.text   = self.currentPhraseVisible
        
        if numUnrevealedCharsLeft == 0 {
            gameOver = true
            let alert = UIAlertController(title: "You won!", message: "Congratulations! Press 'New Game' to play a new game.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func GuessIsIncorrect(userGuessChar: Character) {
        numWrongGuesses! += 1
        userGuessedCharacters.append(userGuessChar)
        hangmanImageView.image = UIImage(named: "hangman" + String(numWrongGuesses! + 1) + ".gif")
        
        if incorrectGuesses!.text?.characters.count > 0 {
            incorrectGuesses.text = incorrectGuesses.text! + ", "
        }
        incorrectGuesses.text = incorrectGuesses.text! + String(userGuessChar)
        
        if numWrongGuesses == maxNumberMistakes {
            gameOver = true
            let alert = UIAlertController(title: "You lost.", message: "The game is over. Press 'New Game' to start a new game", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
