//
//  SpeechDetailViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 12. 3..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

let kBannerAdUnitID = "ca-app-pub-9901818943715840/8091980811"

class SpeechDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var pageDetailActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var banner: GADBannerView!
    
    var speech : Speech!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
        loadSpeechDetail()
        loadAd()
    }

    func loadWebView() {
        let iframeHTMLString = "<iframe src=\"\(speech.embed)\" frameborder=\"0\" scrolling=\"no\"  style=\"width: 100%; height: 60vw\"></iframe>"
        
        self.webView.allowsInlineMediaPlayback = true
        self.webView.loadHTMLString(iframeHTMLString, baseURL: nil)
        self.webView.scrollView.isScrollEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.webView.isLoading {
            return
        }
        
        self.pageDetailActivityIndicator.stopAnimating()
    }
    
    func loadSpeechDetail() {
        self.nameLabel.text = "\(speech.name):"
        self.titleLabel.text = "\(speech.title)"
        self.durationLabel.text = "\(NSLocalizedString("DURATION", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: "")) : \(speech.duration)"
        self.dateLabel.text = "\(NSLocalizedString("FILMED", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: "")) : \(speech.releaseDate)"
        self.rateLabel.text = "\(NSLocalizedString("RATE", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: "")) : \(speech.rated1), \(speech.rated2)"
    }
    
    func loadAd() {
        self.banner.adUnitID = kBannerAdUnitID
        self.banner.rootViewController = self
        self.banner.load(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTappedCopyButton(_ sender: Any) {
        UIPasteboard.general.string = self.speech.embed
        
        let alertController = UIAlertController(title: "", message: NSLocalizedString("ALERT_COPY_HAS_DONE", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
