//
//  SpeechDetailViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 12. 3..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit

class SpeechDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var pageDetailActivityIndicator: UIActivityIndicatorView!
    var speech : Speech!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
        loadSpeechDetail()
    }

    func loadWebView() {
        self.webView.loadHTMLString(speech.embed, baseURL: nil)
        self.webView.scrollView.isScrollEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.webView.isLoading {
            return;
        }
        
        self.pageDetailActivityIndicator.stopAnimating()
    }
    
    func loadSpeechDetail() {
        
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
