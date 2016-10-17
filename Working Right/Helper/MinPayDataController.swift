//
//  MinPayDataControllerViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 15/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

protocol PickerValueChangedDelegate {
    func didChangePickerValue(row: Int)
}

class MinPayDataController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    var labelText = ""
    var pickerData: [String] = []
    var delegate: PickerValueChangedDelegate?
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filterTitle.text = labelText
        picker.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        delegate?.didChangePickerValue(row)
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
