//
//  PlaylistViewController.swift
//  MusicPlayer210219
//
//  Created by Osamu Miyazawa on 2021/03/04.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player: MPMusicPlayerController!
    var albumCount = 0
    var albumList: [MPMediaItemCollection]!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = MPMusicPlayerController.applicationMusicPlayer
        
        let playlistQ = MPMediaQuery.playlists()
        let playlists = playlistQ.collections
        albumList = playlists
        /*for playlist in playlists!{
            print(playlist.value(forProperty: MPMediaPlaylistPropertyName)!)
            let songs = playlist.items
            for song in songs {
                let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
                print("\t\t", songTitle!)
            }
        }*/
        albumCount = playlists!.count
        player.setQueue(with: playlists![0])
        playButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = albumList[indexPath.row].value(forProperty: MPMediaPlaylistPropertyName) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player.setQueue(with: albumList[indexPath.row])
        playButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
        player.play()
        playButton.isEnabled = true
    }

    
    @IBAction func pushPlay(_ sender: Any) {
        let playStatus = player.playbackState
        switch playStatus {
            case .playing:
                playButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
                player.pause()
            default:
                playButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
                player.play()
        }
    }
    
    @IBAction func pushPrevious(_ sender: Any) {
        let playStatus = player.playbackState
        if playStatus == .playing {
            player.skipToBeginning()
        } else {
            player.skipToPreviousItem()
        }
    }
    
    @IBAction func pushNext(_ sender: Any) {
        player.skipToNextItem()
    }

    @IBAction func pushRepeat(_ sender: Any) {
        let repeatStatus = player.repeatMode
        switch repeatStatus {
            case .all:
                player.repeatMode = .one
                repeatButton.setImage(UIImage(systemName: "repeat.1"), for: UIControl.State.normal)
                repeatButton.backgroundColor = UIColor.cyan
            case .one:
                player.repeatMode = .none
                repeatButton.setImage(UIImage(systemName: "repeat"), for: UIControl.State.normal)
                repeatButton.backgroundColor = UIColor.clear
            default:
                player.repeatMode = .all
                repeatButton.setImage(UIImage(systemName: "repeat"), for: UIControl.State.normal)
                repeatButton.backgroundColor = UIColor.cyan
        }
    }
    
}
