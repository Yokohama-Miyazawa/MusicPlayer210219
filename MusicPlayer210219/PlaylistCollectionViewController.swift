//
//  PlaylistCollectionViewController.swift
//  MusicPlayer210219
//
//  Created by Osamu Miyazawa on 2021/03/08.
//

import UIKit
import MediaPlayer

class PlaylistCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var player: MPMusicPlayerController!
    var albumCount = 0
    var albumArray: [MPMediaItemCollection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom:15, right:15)
        collectionView.collectionViewLayout = layout
        
        player = MPMusicPlayerController.applicationMusicPlayer
        
        let albumsQ = MPMediaQuery.albums()
        let albums = albumsQ.collections
        albumArray = albums
        albumCount = albums!.count
        player.setQueue(with: albums![0])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .black
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let cellImage: UIImage

        if let artwork = albumArray[indexPath.row].representativeItem?.artwork {
            cellImage = artwork.image(at: (artwork.bounds.size))!
        } else {
            let albumTitle = albumArray[indexPath.row].representativeItem?.albumTitle ?? "No Title"
            cellImage = drawText(drawSize: CGSize(width: 600, height: 600), fontSize: 64, statusStr: albumTitle)
        }
        
        imageView.image = cellImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 20
        let cellPerRow: CGFloat = 2
        let cellSize: CGFloat = self.view.bounds.width / cellPerRow - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        player.setQueue(with: albumArray[indexPath.row])
        player.play()
    }


    func drawText(drawSize: CGSize, fontSize: CGFloat, statusStr: String) -> UIImage {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        UIGraphicsBeginImageContext(drawSize)
        let textRect = CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.center
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        statusStr.draw(in: textRect, withAttributes: textFontAttributes)
        let strImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return strImage!
    }
    
    @IBAction func pushPlay(_ sender: Any) {
        let playStatus = player.playbackState
        switch playStatus {
            case .playing:
                player.pause()
            default:
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
    

}
