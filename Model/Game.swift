//
//  Game.swift
//  OpenQuizz
//
//  Created by Mathieu Dubart on 09/07/2023.
//

import Foundation


class Game {
  var score = 0
  var questions:[Question] = []
  enum State {
    case ongoing, over
  }
  var state:State = .ongoing
  private var currentIndex = 0
  var currentQuestion:Question {
    return questions[currentIndex]
  }

  func answerCurrentQuestion(_ answer:Bool) {
    answer == currentQuestion.isCorrect ? score += 1 : nil
    isEnded()
  }

  private func isEnded() {
    if (currentIndex >= questions.count-1) {
      state = .over
    } else  {
      currentIndex += 1
    }
  }
    
  func refresh() {
    score = 0
    currentIndex = 0
    state = .over
    
    QuestionManager.shared.get {(questions) in
      self.questions = questions
      self.state = .ongoing
      
      let name = Notification.Name(rawValue: "QuestionsLoaded")
      let notification = Notification(name: name)
      NotificationCenter.default.post(notification)
    }
  }
  
    
}

