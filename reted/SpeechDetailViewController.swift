//
//  SpeechDetailViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 12. 3..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit

class SpeechDetailViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var speech : Speech!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString(speech.embed, baseURL: nil)
        
        webView.scrollView.isScrollEnabled = false
        webView.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
