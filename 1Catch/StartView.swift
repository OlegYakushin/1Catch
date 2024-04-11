//
//  StartView.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var game = GameManager()
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack{
                    Text("1Catch")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 200 * sizeScreen())
                    NavigationLink(destination: ContentView(gameManager: game).navigationBarBackButtonHidden()) {
                        RoundedRectangle(cornerRadius: 25 * sizeScreen())
                            .frame(width: 150 * sizeScreen(), height: 150 * sizeScreen())
                            .foregroundColor(Color("RedTitle"))
                            .overlay(
                            Text("PLAY")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                            )
                    }
                    .padding()
                    NavigationLink(destination: ScoresView(gameManager: game).navigationBarBackButtonHidden()) {
                        RoundedRectangle(cornerRadius: 25 * sizeScreen())
                            .frame(width: 150 * sizeScreen(), height: 150 * sizeScreen())
                            .foregroundColor(Color("RedTitle"))
                            .overlay(
                            Text("SCORES")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                            )
                    }
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
            .onAppear{
                game.loadGame()
                game.endGame(isEnd: false)
            }
    }
}

#Preview {
    StartView()
}
