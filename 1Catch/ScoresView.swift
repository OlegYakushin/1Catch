//
//  ScoresView.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/11/24.
//

import SwiftUI

struct ScoresView: View {
    @ObservedObject var gameManager = GameManager()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            BackgroundView()
            VStack {
                    Text("SCORES")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 200 * sizeScreen())
                RoundedRectangle(cornerRadius: 15 * sizeScreen())
                    .foregroundColor(Color("RedTitle"))
                    .frame(width: 363 * sizeScreen(), height: 49 * sizeScreen())
                    .overlay(
                        Text("RECORD: \(gameManager.game?.maxScore ?? 0)")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                    )
                RoundedRectangle(cornerRadius: 15 * sizeScreen())
                    .foregroundColor(Color("RedTitle"))
                    .frame(width: 363 * sizeScreen(), height: 49 * sizeScreen())
                    .overlay(
                        Text("BACK")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                    )
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.top, 50 * sizeScreen())
            }
        }
    }
}
