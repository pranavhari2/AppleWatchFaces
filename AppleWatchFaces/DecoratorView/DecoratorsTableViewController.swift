//
//  DecoratorsTableViewController.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 12/2/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit

class DecoratorsTableViewController: UITableViewController {

    var decoratorPreviewController: DecoratorPreviewController?
    
    func redrawPreview() {
        //tell clock previe to redraw!
        if let dPreviewVC = decoratorPreviewController {
            dPreviewVC.redraw(clockSetting: SettingsViewController.currentClockSetting)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isEditing = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "decoratorEditorID", for: indexPath) as! DecoratorTableViewCell

        if let clockSettings = SettingsViewController.currentClockSetting.clockFaceSettings {
            let ringSetting = clockSettings.ringSettings[indexPath.row]
            cell.rowIndex = indexPath.row
            cell.setupUIForClockRingSetting()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceRow = sourceIndexPath.row;
        let destRow = destinationIndexPath.row;
        
        if nil != SettingsViewController.currentClockSetting.clockFaceSettings {
            let object = SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings[sourceRow]
            SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings.remove(at: sourceRow)
            SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings.insert(object, at: destRow)
        }
        
        redrawPreview()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if nil != SettingsViewController.currentClockSetting.clockFaceSettings {
                let sourceRow = indexPath.row;
                //let trashedSetting = clockSettings.ringSettings[sourceRow]
                SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings.remove(at: sourceRow)
                tableView.deleteRows(at: [indexPath], with: .none)
                
                redrawPreview()
            }
        
        }
    }
    
    func valueForHeader( section: Int) -> String {
        let ringSetting = SettingsViewController.currentClockSetting.clockFaceSettings!.ringSettings[ section ]
        return ringSetting.ringType.rawValue
    }
    
}