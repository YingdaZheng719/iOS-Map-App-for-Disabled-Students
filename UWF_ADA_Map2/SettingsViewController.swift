//
//  SettingsViewController.swift
//  UWF_ADA_Map2
//
//  Created by Yingda Zheng on 4/14/16.
//  Copyright © 2016 Yingda Zheng. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	
    // outlet of each switch button
    @IBOutlet weak var satelliteSwitch: UISwitch!
    
    @IBOutlet weak var parkingLocationSwitch: UISwitch!
    
    @IBOutlet weak var elevatorSwitch: UISwitch!
    
    @IBOutlet weak var pathSwitch: UISwitch!
    
    @IBOutlet weak var elevationSwitch: UISwitch!
    
    @IBOutlet weak var buildingSwitch: UISwitch!
    
    var tbc = MapTabController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbc = self.tabBarController as! MapTabController
        
        // add event handler to each switch button respectively
        satelliteSwitch.addTarget(self, action: #selector(SettingsViewController.satelliteSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        
        parkingLocationSwitch.addTarget(self, action: #selector(SettingsViewController.parkingLocationSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        
        elevatorSwitch.addTarget(self, action: #selector(SettingsViewController.elevatorSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        
        pathSwitch.addTarget(self, action: #selector(SettingsViewController.pathSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        
        elevationSwitch.addTarget(self, action: #selector(SettingsViewController.elevationSwitchChanged(_:)), for: UIControlEvents.valueChanged)
        
        buildingSwitch.addTarget(self, action: #selector(SettingsViewController.buildingSwitchChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func satelliteSwitchChanged(_ switchState: UISwitch) {
        tbc.isTypeChanged = true
    }
    
    func parkingLocationSwitchChanged(_ switchState: UISwitch) {
        tbc.isShownParkingLocationChanged = true
    }
    
    func elevatorSwitchChanged(_ switchState: UISwitch) {
        tbc.isShownElevatorChanged = true
    }
    
    func pathSwitchChanged(_ switchState: UISwitch) {
        tbc.isShownPathChanged = true
    }
    
    func elevationSwitchChanged(_ switchState: UISwitch) {
        tbc.isShownElevationChanged = true
    }
    
    func buildingSwitchChanged(_ switchState: UISwitch) {
        tbc.isShownBuildingChanged = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
