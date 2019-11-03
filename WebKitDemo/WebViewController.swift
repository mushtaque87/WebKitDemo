//
//  WebViewController.swift
//  AskCurioMath
//
//  Created by Mushtaque Ahmed on 9/26/19.
//  Copyright © 2019 Mohammad Safad. All rights reserved.
//

import UIKit
import WebKit
import Foundation

protocol StepByDelegate : class {
    func updateUI(enable:Bool)
    
}

enum WebViewOperationType : Int {
    case  load
    case  refresh
}

class WebViewController: UIViewController , UIWebViewDelegate  {
    
   
    weak var  delegate : StepByDelegate?
    var jsonString = String()
    var webViewType : WebViewOperationType = .load

     @IBOutlet weak var iOSInputView: iOSNativeInputView!
    var stepWebView: WKWebView!
    @IBOutlet weak var iOSSumbitButton: UIButton!
    
    
    override func loadView() {
        super.loadView()
       let contentController = WKUserContentController()
               contentController.add(self, name: "sumbitToiOS")
             //  contentController.add(self, name: "endCurrentChat")
               let config = WKWebViewConfiguration()
               config.userContentController = contentController
               self.stepWebView = WKWebView( frame: self.view.bounds, configuration: config)
        
        self.view.addSubview(self.stepWebView)
        self.view.bringSubviewToFront(self.iOSInputView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //createJsonToPass(email: "mushtaque87@gmail.com", firstName: "Mushtaque", lastName: "Ahmed")
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        stepWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
             
        stepWebView.navigationDelegate = self
        stepWebView.load(request)
        
        iOSInputView.sumbitButtonAction = { userdata in
            
            self.createJsonToPass(email: userdata.email , firstName: userdata.username , lastName: userdata.lastname)
            self.stepWebView.evaluateJavaScript("fillDetails('\(self.jsonString)')") { (any, error) in
                               
                print("Error : \(error)")
            }
        }
        
        // self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            jsonString = String(data: jsonData, encoding: .utf8)!
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
            
        } catch {
            print(error.localizedDescription)
        }
        print(jsonString!)
        return jsonString!
    }
    
    func createJsonToPass(email : String , firstName : String = "" , lastName : String = "" ) {
        
        let data = ["email": email ,"firstName": firstName , "lastName": lastName] as [String : Any]
        self.jsonString = createJsonForJavaScript(for: data)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
//    @IBAction func sumbitDataFromiOSToWeb(_ sender: Any) {
//
//        stepWebView.evaluateJavaScript("fillDetails('\(self.jsonString)')") { (any, error) in
//
//                    print(error)
//        }
//    }
    
    
}


//MARK: - Web view delegate methods

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
   
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}

//MARK: - Web view method to handle call backs

extension WebViewController : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        let dict = message.body as? Dictionary<String, String>
        print(dict)
        
        let userdata = UserData((dict?["firstName"])!, (dict?["email"])!, (dict?["lastName"])!)
        
        if message.name == "sumbitToiOS" {
            self.sumbitToiOS(user: userdata)
        }
        
    }
    
    
    func sumbitToiOS(user:UserData){
        //refresh token
        print("sumbitToiOS")
        iOSInputView.webToiOSDataTransfer(data: user)
        
    }
    
    func endCurrentChat(isEnded: Bool){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
