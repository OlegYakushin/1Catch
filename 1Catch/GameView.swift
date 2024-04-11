//
//  GameView.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @State private var isPaused = false
    @ObservedObject var gameManager: GameManager
    @State private var isEnd = false
    var body: some View {
        if isEnd == false {
            if UIDevice.current.userInterfaceIdiom == .pad {
                SKViewContainer(scene: GameScene(size: CGSize(width: 1024 * sizeScreen(), height: 1024 * sizeScreen()), gameManager: gameManager, isPaused: isPaused))
                    .frame(width: 1024 * sizeScreen(), height: 1024 * sizeScreen())
            } else {
                SKViewContainer(scene: GameScene(size: CGSize(width: 390 * sizeScreen(), height: 710 * sizeScreen()), gameManager: gameManager, isPaused: isPaused))
                    .frame(width: 390 * sizeScreen(), height: 710 * sizeScreen())
            }
        }
        let endGameResult = gameManager.game?.endGame
        if endGameResult == true {
            EndOverlayView(gameManager: gameManager, isEnd: $isEnd)
                .onDisappear{
                    gameManager.endGame(isEnd: false)
                }
        }
    }
}
struct EndOverlayView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameManager: GameManager
    @Binding var isEnd: Bool
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                RoundedRectangle(cornerRadius: 15 * sizeScreen())
                    .frame(width: 283 * sizeScreen(), height: 339 * sizeScreen())
                    .foregroundColor(Color("RedTitle"))
                    .overlay(
                VStack {
                    Text("End")
                        .foregroundColor(.white)
                        .font(.custom("Inter-ExtraBold", size: 25 * sizeScreen()))
                        .padding()
                    Text("Score: \(gameManager.game?.currentScore ?? 0)")
                        .foregroundColor(.white)
                        .font(.custom("Inter-ExtraBold", size: 25 * sizeScreen()))
                        .padding()

                    RoundedRectangle(cornerRadius: 15 * sizeScreen())
                        .frame(width: 249 * sizeScreen(), height: 50 * sizeScreen())
                        .foregroundColor(Color("GreenOne"))
                        .overlay(
                        Text("Restart")
                            .foregroundColor(.white)
                            .font(.custom("Inter-ExtraBold", size: 20 * sizeScreen()))
                            
                        )
                        .onTapGesture {
                            isEnd = false
                            gameManager.resetCurrenrScore()
                            gameManager.endGame(isEnd: false)
                            }
                        .padding()
                    RoundedRectangle(cornerRadius: 15 * sizeScreen())
                        .frame(width: 249 * sizeScreen(), height: 50 * sizeScreen())
                        .foregroundColor(Color("GreenOne"))
                        .overlay(
                        Text("Exit to menu")
                            .foregroundColor(.white)
                            .font(.custom("Inter-ExtraBold", size: 20 * sizeScreen()))
                            
                        )
                        .padding(.bottom, 70 * sizeScreen())
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                            gameManager.endGame(isEnd: false)
                        }
                }
                    .padding()
                )
            )
            .onAppear{
                isEnd = true
            }
    }
}
struct SKViewContainer: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
    }
}
