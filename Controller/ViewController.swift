//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Mathieu Dubart on 09/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let notificationName = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: notificationName, object: nil)
        //selector permet de choisir ( avec #selector() ) la méthode à exécuter à la réception d'une notification
        //object agit comme un "flitre"
        
        startNewGame()
        
        //Gestion des gestes
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scorelabel.text = "0/10"
        game.refresh()
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }

    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        //in: méthode dont on veut obtenir la translation
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x,
                                                   y: translation.y)
        //Rotation des cartes
        let screenWidth = UIScreen.main.bounds.width
        let translationPercent = translation.x/(screenWidth/2)
        let rotationAngle = (CGFloat.pi/6) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationTransform)
        
        questionView.transform = transform
        
        //Changement de style
        if translation.x > 0{
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(true)
        case .incorrect:
            game.answerCurrentQuestion(false)
        case .standard:
            break
        }
        
        scorelabel.text = "\(game.score)/10"
        
        //animation cartes
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform  = translationTransform
        }, completion: {(success) in
            success ? self.showQuestionView() : nil
        })
    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game over"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
    }
}

