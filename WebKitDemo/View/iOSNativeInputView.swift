//
//  iOSNativeInputView.swift
//  WebKitDemo
//
//  Created by Mushtaque Ahmed on 10/15/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import UIKit




class iOSNativeInputView: UIView  {
    var userData: UserData?
  
    let nibName = "iOSNativeInputView"
    var contentView: UIView?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightBarButton: UIButton!
    var sumbitButtonAction : ((UserData) -> ())?

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var lastnameTxtField: UITextField!
    
    override func awakeFromNib() {
           super.awakeFromNib()
       }
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
           setup()
       }
       
       func setup() {
           guard let view = loadViewFromNib() else { return }
           view.frame = self.bounds
           self.addSubview(view)
           contentView = view
       }
       
       func loadViewFromNib() -> UIView? {
           let bundle = Bundle(for: type(of: self))
           let nib = UINib(nibName: nibName, bundle: bundle)
           return nib.instantiate(withOwner: self, options: nil).first as? UIView
       }
       
    func iOSToWebDataTransfer(data: UserData) {
          
            
      }
      
      func webToiOSDataTransfer(data: UserData) {
        nameTxtField.text = data.username
        emailTxtField.text = data.email
        lastnameTxtField.text = data.lastname
        
      }
    
    @IBAction func submitData(_ sender: Any) {
        guard self.sumbitButtonAction != nil else {
            return
        }
        let userdata = UserData(nameTxtField.text!, emailTxtField.text!, lastnameTxtField.text!)
        self.sumbitButtonAction!(userdata)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
