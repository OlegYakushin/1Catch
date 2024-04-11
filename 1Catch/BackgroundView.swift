//
//  BackgroundView.swift
//  1Catch
//
//  Created by Oleg Yakushin on 4/10/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack{
            if UIDevice.current.userInterfaceIdiom == .pad {
                Image("backgroundIpadImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }else{
                Image("backgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
