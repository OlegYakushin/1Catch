//
//  GameManager.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var game: Game?

    init() {
           loadGame()
        if game == nil {
                   initializeGame()
               }
       }

    private func saveGame() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(game) {
            UserDefaults.standard.set(encoded, forKey: "game")
        }
    }
    
    func loadGame() {
        if let data = UserDefaults.standard.data(forKey: "game") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Game.self, from: data) {
                game = decoded
            }
        }
    }
    
    func updateScore(score: Int) {
            guard var game = game else { return }
        game.maxScore = score
            self.game = game
            saveGame()
        }
    
    func updateCurrenrScore(score: Int) {
            guard var game = game else { return }
        game.currentScore = score
            self.game = game
            saveGame()
        }
    
    func resetCurrenrScore() {
            guard var game = game else { return }
        game.currentScore = 0
        game.endGame = false
            self.game = game
            saveGame()
        }
    
    func endGame(isEnd: Bool) {
            guard var game = game else { return }
        game.endGame = isEnd
            self.game = game
            saveGame()
        }
    
    private func initializeGame() {
        game = Game(maxScore: 0, currentScore: 0, paused: false, endGame: false, lives: 3)
        saveGame()
    }
}

struct Game: Codable {
    var maxScore: Int
    var currentScore: Int
    var paused: Bool
    var endGame: Bool
    var lives: Int
}
