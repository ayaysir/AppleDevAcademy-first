//
//  ContentView.swift
//  AppleDevAccademy-first
//
//  Created by 윤범태 on 2023/03/06.
//

import SwiftUI

struct ContentView: View {
    @State var statusText = "Ready to play..."
    
    var body: some View {
        VStack {
            Spacer()
            // 이미지 사이즈 조정
            Image("Adiemus II")
                .resizable()
                .frame(width: 380, height: 380)
            Spacer()
            
            // 각종 버튼 (HStack)
            HStack {
                Spacer()
                Button {
                    statusText = "Backward"
                } label: {
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
                Spacer()
                Button {
                    statusText = "Play"
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
                Spacer()
                Button {
                    statusText = "Afterward"
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            // Spacer 높이 변경
            Spacer().frame(height: 25)
            Text(statusText)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
