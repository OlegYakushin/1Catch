//
//  GameScene.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameManager: GameManager
    var playerBottom: SKSpriteNode!
    var playerBottomTouch: UITouch?
    var scoreLabel: SKLabelNode!
    var score = 0
    var lives: [SKSpriteNode] = []
    var isGameOver = false
    
    init(size: CGSize, gameManager: GameManager, isPaused: Bool) {
        self.gameManager = gameManager
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        physicsWorld.contactDelegate = self
        setupUI()
        setupLives()
        dropObjects()
    }
    
    func setupUI() {
        // Score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 20  * sizeScreen()
        scoreLabel.position = CGPoint(x: frame.midX + 100 * sizeScreen(), y: frame.maxY - 40 * sizeScreen())
        addChild(scoreLabel)
        
        // Bottom player
        let playerBottomTexture = SKTexture(imageNamed: "playerBottom")
        playerBottom = SKSpriteNode(texture: playerBottomTexture, size: CGSize(width: 108 * sizeScreen(), height: 71 * sizeScreen()))
        playerBottom.position = CGPoint(x: frame.midX, y: playerBottom.size.height / 2 + 20 * sizeScreen())
        playerBottom.physicsBody = SKPhysicsBody(rectangleOf: playerBottom.size)
        playerBottom.physicsBody?.categoryBitMask = PhysicsCategory.Player
        playerBottom.physicsBody?.contactTestBitMask = PhysicsCategory.Fruit
        playerBottom.physicsBody?.isDynamic = false
        addChild(playerBottom)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategory.Fruit | PhysicsCategory.Player {
            score += 1
            gameManager.updateCurrenrScore(score: score)
            scoreLabel.text = "Score: \(score)" // Обновляем текст счета
            print("Score: \(score)")
            if let fruit = contact.bodyA.node as? Fruit {
               fruit.removeFromParent()
            } else if let fruit = contact.bodyB.node as? Fruit {
                fruit.removeFromParent()
            }
        } else if contactMask == PhysicsCategory.Bomb | PhysicsCategory.Player {
            loseLife()
        }
    }

    func setupLives() {
        let heartTexture = SKTexture(imageNamed: "heart")
        let initialX = frame.midX - CGFloat((3 - 1) * 30) / 2 - 120 * sizeScreen()
        let yPosition = frame.maxY - 30 * sizeScreen()
        
        for index in 0..<3 {
            let heart = SKSpriteNode(texture: heartTexture, size: CGSize(width: 40 * sizeScreen(), height: 40 * sizeScreen()))
            heart.position = CGPoint(x: initialX + CGFloat(index * 50) * sizeScreen(), y: yPosition)
            addChild(heart)
            lives.append(heart)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let touch = touches.first else { return }
         let touchLocation = touch.location(in: self)
         if playerBottom.frame.contains(touchLocation) {
             playerBottomTouch = touch
         }
     }

     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let touch = touches.first, let playerBottomTouch = playerBottomTouch else { return }
         let touchLocation = touch.location(in: self)
         if touch == playerBottomTouch {
             playerBottom.position.x = touchLocation.x
         }
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         playerBottomTouch = nil
     }
    func loseLife() {
        guard !lives.isEmpty else { return }
        let life = lives.removeLast()
        life.removeFromParent()
        if lives.isEmpty {
            endGame()
        }
    }

    func endGame() {
        guard !isGameOver else { return }
        physicsWorld.speed = 0
        isGameOver = true
        gameManager.endGame(isEnd: true)
        if score > gameManager.game!.maxScore {
            gameManager.updateScore(score: score)
        }
    }

    func dropObjects() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
        
        let fruitAction = SKAction.sequence([
            SKAction.run {
                self.createFruit()
            },
            SKAction.wait(forDuration: 2.0)
        ])
        
        let bombAction = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                self.createBomb()
            },
            SKAction.wait(forDuration: 2.25)
        ])
        
        let checkOutOfBoundsAction = SKAction.run {
            self.enumerateChildNodes(withName: "fruit") { node, _ in
                if node.position.y < 0 {
                    node.removeFromParent()
                    self.loseLife()
                }
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([
            checkOutOfBoundsAction,
            fruitAction,
            checkOutOfBoundsAction,
            bombAction,
            checkOutOfBoundsAction
        ])))
    }

    func createFruit() {
        let fruitTextures = ["apple", "orange", "banana", "pineapple", "corn"].map { SKTexture(imageNamed: $0) }
        let randomIndex = Int.random(in: 0..<fruitTextures.count)
        let fruit = Fruit(texture: fruitTextures[randomIndex], size: CGSize(width: 60 * sizeScreen(), height: 60 * sizeScreen()))
        fruit.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: size.height - 70  * sizeScreen())
        addChild(fruit)
    }

    func createBomb() {
        let bombTexture = SKTexture(imageNamed: "bomb")
        let bomb = Bomb(texture: bombTexture, size: CGSize(width: 60 * sizeScreen(), height: 60 * sizeScreen()))
        bomb.position = CGPoint(x: CGFloat.random(in: 0..<size.width), y: size.height - 70  * sizeScreen())
        addChild(bomb)
    }

}

struct PhysicsCategory {
    static let Ball: UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let Fruit: UInt32 = 0x1 << 2
    static let Bomb: UInt32 = 0x1 << 3
}

class Fruit: SKSpriteNode {
    init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        self.name = "fruit"
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Fruit
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Bomb: SKSpriteNode {
    init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        self.name = "bomb"
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
