//
//  ContentView.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameManager = GameManager()
    var body: some View {
        ZStack {
            BackgroundView()
            GameView(gameManager: gameManager)
         }
    }
}
