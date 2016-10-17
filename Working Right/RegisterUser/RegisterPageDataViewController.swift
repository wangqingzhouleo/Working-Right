//
//  RegisterPageViewController.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 27/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit
import CoreData

class RegisterPageDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var button: UIButton!
    
    var delegate: MainRegisterViewController!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    let titleForIsStudent = ["Yes", "No"]
    let titleForVisaType = ["Student visa", "Working visa", "Holiday visa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        button.addTarget(self, action: #selector(self.tapButton), forControlEvents: .TouchUpInside)
        let title = delegate.currentPageIndex == delegate.labelText.count - 1 ? "Done" : "Next"
        button.setTitle(title, forState: .Normal)
        label.text = delegate.labelText[delegate.currentPageIndex]
        picker.delegate = self
        picker.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.shouldEnableMainButton), name: UITextFieldTextDidChangeNotification, object: nameTextField)
        shouldEnableMainButton()
        
        showComponent()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapButton()
    {
        switch delegate.currentPageIndex {
        case 0:
            tmpUser[0] = nameTextField.text!
        case 1:
            tmpUser[1] = titleForIsStudent[picker.selectedRowInComponent(0)]
        case 2:
            tmpUser[2] = titleForVisaType[picker.selectedRowInComponent(0)]
        default:
            break
        }
        
        if delegate.currentPageIndex == delegate.labelText.count - 1
        {
            let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObject) as! User
            newUser.name = tmpUser[0]
            newUser.isStudent = tmpUser[1] == "Yes"
            newUser.visaType = tmpUser[2]
            appDelegate.saveContext()
            
            delegate.finishRegister()
        }
        else
        {
            delegate.scrollToNext()
        }
    }
    
    func showComponent()
    {
        picker.hidden = delegate.currentPageIndex != 1 && delegate.currentPageIndex != 2
        nameTextField.hidden = delegate.currentPageIndex != 0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch delegate.currentPageIndex {
        case 1:
            return titleForIsStudent.count
        case 2:
            return titleForVisaType.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch delegate.currentPageIndex {
        case 1:
            return titleForIsStudent[row]
        case 2:
            return titleForVisaType[row]
        default:
            return nil
        }
    }
    
    func shouldEnableMainButton()
    {
        if delegate.currentPageIndex == 0
        {
            button.enabled = nameTextField.text?.characters.count > 0
            button.backgroundColor = button.enabled ? UIColor(red: 0.8471, green: 0, blue: 0.1529, alpha: 1) : UIColor.lightGrayColor()
        }
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
