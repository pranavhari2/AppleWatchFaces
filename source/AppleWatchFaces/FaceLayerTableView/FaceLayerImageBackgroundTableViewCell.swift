//
//  FaceLayerColorBackgroundTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 5/11/19.
//  Copyright © 2019 Michael Hill. All rights reserved.
//

import UIKit
import SpriteKit

class FaceLayerImageBackgroundTableViewCell: FaceLayerTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var imageSelectionCollectionView: UICollectionView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var filenameLabel: UILabel!
    
    let settingTypeString = "imageBackground"
    
    @IBAction func cameraButtonTapped( sender: UIButton) {
        NotificationCenter.default.post(name: SettingsViewController.settingsGetCameraImageNotificationName, object: nil, userInfo:["layerIndex":myLayerIndex()!])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppUISettings.materialFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsColorCell", for: indexPath) as! ColorSettingCollectionViewCell
        
        //buffer
        let buffer:CGFloat = CGFloat(Int(cell.frame.size.width / 10))
        let corner:CGFloat = CGFloat(Int(buffer / 2))
        cell.circleView.frame = CGRect.init(x: corner, y: corner, width: cell.frame.size.width-buffer, height: cell.frame.size.height-buffer)
        
        if let image = UIImage.init(named: AppUISettings.materialFiles[indexPath.row] ) {
            cell.circleView.layer.cornerRadius = 0
            //TODO: if this idea sticks, resize this on app start and cache them so they arent built on-demand
            let scaledImage = AppUISettings.imageWithImage(image: image, scaledToSize: CGSize.init(width: cell.frame.size.width-buffer, height: cell.frame.size.height-buffer))
            cell.circleView.backgroundColor = SKColor.init(patternImage: scaledImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let faceLayer = myFaceLayer()
        guard let layerOptions = faceLayer.layerOptions as? ImageBackgroundLayerOptions else { return }
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        faceLayer.filenameForImage = "" //clear this out
        
        layerOptions.filename = AppUISettings.materialFiles[indexPath.row]
        filenameLabel.text = layerOptions.filename
        
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:["settingType":settingTypeString,"layerIndex":myLayerIndex()!])
    }
    
    override func setupUIForFaceLayer(faceLayer: FaceLayer) {
        super.setupUIForFaceLayer(faceLayer: faceLayer) // needs title outlet to function
        
        if faceLayer.filenameForImage != "" {
            filenameLabel.text = faceLayer.filenameForImage
        } else {
            guard let layerOptions = faceLayer.layerOptions as? ImageBackgroundLayerOptions else { return }
            if let meterialsIndex = AppUISettings.materialFiles.index(of: layerOptions.filename) {
                filenameLabel.text = layerOptions.filename
                let indexPath = IndexPath.init(row: meterialsIndex, section: 0)
                imageSelectionCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            }
        }
        
    }
    
    
}
