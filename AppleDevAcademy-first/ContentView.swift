//
//  ContentView.swift
//  AppleDevAcademy-first
//
//  Created by 윤범태 on 2023/03/06.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    /*
     @State로 선언한 프로퍼티는 값이 변경되면 뷰 계층 구조의 부분을 업데이트
     @State를 자식 뷰에 전달하면 부모에서 값이 변경될 때마다 자식을 업데이트
     단, 자식 뷰에서 값을 수정하려면, 부모에서 자식으로 Binidng을 전달하여 자식 뷰에서 값을 수정이 가능
     */
    @State var statusText = "Ready to play..."
    @State var isOpenMusicPickerView = false
    @State var mediaTitle = "Select a music..."
    @State var mediaSubtitle = ""
    @State var albumImage: UIImage? = UIImage(named: "Adiemus II")
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    
    var body: some View {
        VStack {
            Spacer()
            // 이미지 사이즈 조정
            Image(uiImage: albumImage ?? UIImage())
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
            
            Group {
                Text(mediaTitle)
                    .font(.system(size: 25, weight: .bold))
                Text(mediaSubtitle)
                    .font(.system(size: 18))
                Spacer()
                Text(statusText)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                isOpenMusicPickerView = true
            } label: {
                Text("Select a music from library...")
            }.sheet(isPresented: $isOpenMusicPickerView) {
                MPMediaPickerControllerRP { metadata in
                    // coordinator에서 밖으로 꺼낸 데이터
                    print("metadata outside:", metadata)
                    mediaTitle = metadata.title
                    mediaSubtitle = "\(metadata.artist) - \(metadata.albumTitle)"
                    albumImage = metadata.albumArtImage
                }
            }
        }
        .padding()
        .onAppear {
            MPMediaLibrary.requestAuthorization { status in
                switch status {
                case .notDetermined:
                    print("status: notDetermined")
                case .denied:
                    print("status: denied")
                case .restricted:
                    print("status: restricted")
                case .authorized:
                    print("status: authorized")
                    
                @unknown default:
                    print("status: unknown default")
                }
            }
        }
    }
}

struct MPMediaPickerControllerRP: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MPMediaPickerController
    typealias MetadataCallback = (MediaMetadata) -> Void
    
    let picker = MPMediaPickerController(mediaTypes: .music)
    var metadataCallback: MetadataCallback
    
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        picker.allowsPickingMultipleItems = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {}
    
    // Representable에서 delegate 사용
    func makeCoordinator() -> Coordinator {
        Coordinator(picker, metadataCallback: metadataCallback)
    }
    
    class Coordinator: NSObject, MPMediaPickerControllerDelegate {
        
        var metadataCallback: MetadataCallback
        
        init(_ viewController: MPMediaPickerController, metadataCallback: @escaping MetadataCallback) {
            self.metadataCallback = metadataCallback
            super.init()
            viewController.delegate = self
        }
        
        // Delegate function
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            let media = mediaItemCollection.items[0]
            let title = media.title ?? "unknown title"
            let artist = media.artist ?? "unknown artist"
            let albumTitle = media.albumTitle ?? "unknown album title"
            let duration = media.playbackDuration
            let albumArtImage = media.artwork?.image(at: .zero)
            let metadata = MediaMetadata(title: title, artist: artist, albumTitle: albumTitle, duration: duration, albumArtImage: albumArtImage)
            
            // 방법 1: system music player로 재생
            let musicPlayer = MPMusicPlayerController.systemMusicPlayer
            musicPlayer.setQueue(with: mediaItemCollection)
            musicPlayer.play()
            
            // 데이터 밖으로 내보내기
            metadataCallback(metadata)
            
            mediaPicker.dismiss(animated: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
