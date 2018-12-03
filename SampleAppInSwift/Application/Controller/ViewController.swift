//
//  ViewController.swift
//  SampleAppInSwift
//
//  Created by Akarsh Seggemu on 13/11/2018.
//  Copyright © 2018 Fyber GmbH. All rights reserved.
//

import UIKit
import MessageUI


class ViewController: UIViewController, UITextFieldDelegate, HZAdsDelegate, HZIncentivizedAdDelegate, HZBannerAdDelegate {
    
    // MARK: Buttons and Text Field Declaration
    private var adUnitSegmentedControl: UISegmentedControl?
    private var consoleTextView: UITextView?
    
    private var fetchButton,showButton: UIButton?
    private var mediationTestSuiteButton, availableButton : UIButton?
    private var showBannerButton, hideBannerButton, emailConsoleButton: UIButton?
    private var topButton, bottomButton, clearButton: UIButton?
    
    private var adTagField: UITextField?
    
    private var currentBannerAd: HZBannerAd?

    
    private var bannerControls = [UIButton]()
    // TODO: Add Offerwall Controls
//    private var offerWallControls = [UIButton]()
    private var standardControls = [UIButton]()
    
    // MARK: Button properties
    private let buttonWidth: CGFloat = 80
    private let buttonHeight: CGFloat = 40
    private let xPosition: CGFloat = 15
    private let yPosition: CGFloat = 10
    private let buttonCornerRadius: CGFloat = 4.0
    
    private var scrollView: UIScrollView!
    
    enum adUnitSegment: Int {
        case Interstitial = 0
        case Video = 1
        case Incentivized = 2
        case Banner = 3
        case Offerwall = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the background
        self.view.backgroundColor = UIColor.lightGray
        
        // This function sets up the UI programmatically
        setupUI()
    }
    
    fileprivate func setupUI() {
        // MARK: Scroll View
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: (self.view.frame.height + 100))
        
        // This is for fixing the margins in landscape mode iPhone X
        //        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        if #available(iOS 11, *) {
        //            let guide = view.safeAreaLayoutGuide
        //            NSLayoutConstraint.activate([
        //                scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
        //                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0)
        //                ])
        //
        //        } else if #available(iOS 9, *){
        //            let standardSpacing: CGFloat = 8.0
        //            NSLayoutConstraint.activate([
        //                scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
        //                bottomLayoutGuide.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: standardSpacing)
        //                ])
        //        }
        
        view.addSubview(scrollView)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:))))
        
        
        
        // Setting up buttons to the main storyboard programmatically
        // MARK: Mediation Test Suite Button
        mediationTestSuiteButton = UIButton(type: UIButton.ButtonType.roundedRect)
        mediationTestSuiteButton!.frame = CGRect(x: xPosition, y: (yPosition + 40.0), width: ((buttonWidth * 2) + xPosition), height: buttonHeight)
        mediationTestSuiteButton!.layer.cornerRadius = buttonCornerRadius
        mediationTestSuiteButton!.backgroundColor = UIColor.lightText
        mediationTestSuiteButton!.setTitle("Mediation Test Suite", for: .normal)
        mediationTestSuiteButton!.accessibilityLabel = "Mediation Test Suite"
        mediationTestSuiteButton!.addTarget(self, action: #selector(self.showTestActivity), for: .touchUpInside)
        scrollView.addSubview(mediationTestSuiteButton!)
        
        // MARK: Fetch Button
        fetchButton = UIButton(type: UIButton.ButtonType.roundedRect)
        fetchButton?.frame = CGRect(x: xPosition, y: (mediationTestSuiteButton!.frame.maxY + xPosition), width: buttonWidth, height: buttonHeight)
        fetchButton?.backgroundColor = UIColor.lightText
        fetchButton?.layer.cornerRadius = buttonCornerRadius
        fetchButton?.backgroundColor = UIColor.lightText
        fetchButton?.setTitle("Fetch", for: .normal)
        fetchButton?.setTitleColor(UIColor.white, for: .normal)
        fetchButton?.accessibilityLabel = "fetch"
        fetchButton?.addTarget(self, action: #selector(self.fetchAd(_:)), for: .touchUpInside)
        scrollView.addSubview(fetchButton!)
        
        // MARK: Show Button
        showButton = UIButton(type: UIButton.ButtonType.roundedRect)
        showButton?.frame = CGRect(x: (xPosition + (fetchButton?.frame.maxX)!), y: fetchButton!.frame.minY, width: buttonWidth, height: buttonHeight)
        showButton?.backgroundColor = UIColor.red
        showButton?.layer.cornerRadius = buttonCornerRadius
        showButton?.setTitle("Show", for: .normal)
        showButton?.setTitleColor(UIColor.white, for: .normal)
        showButton?.accessibilityLabel = "show"
        showButton?.addTarget(self, action: #selector(self.showAd(_:)), for: .touchUpInside)
        scrollView.addSubview(showButton!)
        
        // MARK: AdTag Text Field
        adTagField = UITextField(frame: CGRect(x: (showButton!.frame.maxX + xPosition), y: showButton!.frame.minY, width: (buttonWidth * 2), height: buttonHeight))
        adTagField?.borderStyle = .roundedRect
        adTagField?.keyboardType = .default
        adTagField?.placeholder = "Ad Tag"
        adTagField?.textAlignment = .left
        adTagField?.accessibilityLabel = "ad tag"
        adTagField?.autocapitalizationType = .none
        adTagField?.addTarget(self, action: #selector(self.addTagEditingChanged(_:)), for: .editingChanged)
        scrollView.addSubview(adTagField!)
        
        // MARK: Hide banner Button
        hideBannerButton = UIButton(type: .roundedRect)
        hideBannerButton?.frame = fetchButton!.frame
        hideBannerButton?.backgroundColor = UIColor.darkGray
        hideBannerButton?.layer.cornerRadius = 4.0
        hideBannerButton?.setTitle("Hide", for: .normal)
        hideBannerButton?.accessibilityLabel = "hide"
        hideBannerButton?.setTitleColor(UIColor.white, for: .normal)
        hideBannerButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        hideBannerButton?.addTarget(self, action: #selector(self.hideBannerButtonPressed(_:)), for: .touchUpInside)
        hideBannerButton?.isEnabled = false
        scrollView.addSubview(hideBannerButton!)
        
        // MARK: Show banner Button
        showBannerButton = UIButton(type: .roundedRect)
        showBannerButton?.frame = showButton!.frame
        showBannerButton?.backgroundColor = UIColor.green
        showBannerButton?.setTitleColor(UIColor.white, for: .normal)
        showBannerButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        showBannerButton?.layer.cornerRadius = 4.0
        showBannerButton?.setTitle("Show", for: .normal)
        showBannerButton?.accessibilityLabel = "show"
        showBannerButton?.addTarget(self, action: #selector(self.showBannerButtonPressed(_:)), for: .touchUpInside)
        scrollView.addSubview(showBannerButton!)
        
        // MARK: Available Button
        availableButton = UIButton(type: .roundedRect)
        availableButton?.frame = CGRect(x: xPosition, y: (fetchButton!.frame.maxY + yPosition), width: buttonWidth, height: buttonHeight)
        availableButton?.backgroundColor = UIColor.lightText
        availableButton?.layer.cornerRadius = buttonCornerRadius
        availableButton?.setTitle("Available?", for: .normal)
        availableButton?.addTarget(self, action: #selector(self.checkAvailability), for: .touchUpInside)
        scrollView.addSubview(availableButton!)
        
        // MARK: AD Unit Segemented Control
        let items = ["Interstitial", "Video", "Incentivized", "Banner", "OfferWall"]
        adUnitSegmentedControl = UISegmentedControl(items: items)
        adUnitSegmentedControl?.frame = CGRect(x: xPosition, y: (availableButton!.frame.maxY + xPosition), width: (self.view.frame.width - (xPosition * 2)), height: buttonHeight)
        adUnitSegmentedControl?.autoresizingMask = .flexibleWidth
        adUnitSegmentedControl?.selectedSegmentIndex = 0
        adUnitSegmentedControl?.addTarget(self, action: #selector(self.changeColorOfShowButton), for: .valueChanged)
        scrollView.addSubview(adUnitSegmentedControl!)
        
        // MARK: Console Text View
        consoleTextView = UITextView(frame: CGRect(x: xPosition, y: (adUnitSegmentedControl!.frame.maxY + xPosition), width: (self.view.frame.width - (xPosition * 2)), height: (self.view.frame.height * 0.4)))
        consoleTextView?.isEditable = false
        consoleTextView?.autoresizingMask = .flexibleWidth
        consoleTextView?.font = UIFont(name: "Courier", size: 12.0)
        scrollView.addSubview(consoleTextView!)
        
        // MARK: Email Console Button
        emailConsoleButton = UIButton(type: UIButton.ButtonType.roundedRect)
        emailConsoleButton?.frame = CGRect(x: xPosition, y: (consoleTextView!.frame.maxY + yPosition), width: (buttonWidth + yPosition), height: buttonHeight)
        emailConsoleButton?.setTitle("Email Text", for: .normal)
        emailConsoleButton?.backgroundColor = UIColor.lightText
        emailConsoleButton?.layer.cornerRadius = buttonCornerRadius
        emailConsoleButton?.addTarget(self, action: #selector(self.emailConsoleButtionPressed), for: .touchUpInside)
        emailConsoleButton?.autoresizingMask = .flexibleRightMargin
        scrollView.addSubview(emailConsoleButton!)
        
        // MARK: Clear Button
        clearButton = UIButton(type: UIButton.ButtonType.roundedRect)
        clearButton?.frame = CGRect(x: (consoleTextView!.frame.maxX - (xPosition * 18)), y: (consoleTextView!.frame.maxY + yPosition), width: buttonWidth, height: buttonHeight)
        clearButton?.setTitle("Clear", for: .normal)
        clearButton?.layer.cornerRadius = buttonCornerRadius
        clearButton?.backgroundColor = UIColor.lightText
        clearButton?.addTarget(self, action: #selector(self.clearButtonPressed), for: .touchUpInside)
        clearButton?.autoresizingMask = .flexibleLeftMargin
        scrollView.addSubview(clearButton!)
        
        // MARK: Top Button
        topButton = UIButton(type: UIButton.ButtonType.roundedRect)
        topButton?.frame = CGRect(x: (clearButton!.frame.maxX + xPosition), y: (clearButton!.frame.minY), width: buttonWidth, height: buttonHeight)
        topButton?.setTitle("Top", for: .normal)
        topButton?.layer.cornerRadius = buttonCornerRadius
        topButton?.backgroundColor = UIColor.lightText
        topButton?.addTarget(self, action: #selector(self.topButtonPressed), for: .touchUpInside)
        topButton?.autoresizingMask = .flexibleLeftMargin
        scrollView.addSubview(topButton!)
        
        // MARK: Bottom Button
        bottomButton = UIButton(type: UIButton.ButtonType.roundedRect)
        bottomButton?.frame = CGRect(x: (topButton!.frame.maxX + xPosition), y: (topButton!.frame.minY), width: buttonWidth, height: buttonHeight)
        bottomButton?.setTitle("Bottom", for: .normal)
        bottomButton?.layer.cornerRadius = buttonCornerRadius
        bottomButton?.backgroundColor = UIColor.lightText
        bottomButton?.addTarget(self, action: #selector(self.bottomButtonPressed), for: .touchUpInside)
        bottomButton?.autoresizingMask = .flexibleLeftMargin
        scrollView.addSubview(bottomButton!)
        
        bannerControls.append(showBannerButton!)
        bannerControls.append(hideBannerButton!)
        
        standardControls.append(showButton!)
        standardControls.append(fetchButton!)
        standardControls.append(availableButton!)
        
        for i in bannerControls {
            i.isHidden = true
        }
        
        // This approach avoids constant manual adjustment
        var subviewContainingRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            subviewContainingRect = subviewContainingRect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: subviewContainingRect.size.width, height: (subviewContainingRect.size.height + 80))
    }
    
    // TODO: Add button function for top, clear, bottom buttons and remove repetable code
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        sender.view?.endEditing(true)
    }
    
    func log(toConsole consoleString: String?) {
        let format = DateFormatter()
        format.dateFormat = "[h:mm:ss a]"
        consoleTextView!.text = consoleTextView!.text + "\n\n \(format.string(from: Date())) " + consoleString!
        
//        // get around weird bug in iOS 9 - text view scrolling has issues when done directly after updating the text
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC)))) {
//            // FIXME: this might throw error
//            self.bottomButton
//        }
    }
    
    @objc func addTagEditingChanged(_ sender: Any?) {
        changeColorOfShowButton()
    }
    
    func adTagText() -> String? {
        let text = adTagField!.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text == "" {
            return nil
        }
        return text
    }
    
    @objc func changeColorOfShowButton() {
        for i in bannerControls {
            i.isHidden = adUnitSegmentedControl?.selectedSegmentIndex != adUnitSegment.Banner.rawValue
        }
        //        TODO: Add Offerwall controls
//        for j in offerWallControls {
//            j.isHidden = adUnitSegmentedControl?.selectedSegmentIndex != adUnitSegment.Offerwall.rawValue
//        }
        for k in standardControls {
            k.isHidden = adUnitSegmentedControl?.selectedSegmentIndex == adUnitSegment.Banner.rawValue
        }
        
        let adTag = adTagText()
        
        switch adUnitSegmentedControl!.selectedSegmentIndex {
        case adUnitSegment.Interstitial.rawValue:
            setShowButtonOn(HZInterstitialAd.isAvailable(forTag: adTag))
        case adUnitSegment.Video.rawValue:
            setShowButtonOn(HZVideoAd.isAvailable(forTag: adTag))
        case adUnitSegment.Incentivized.rawValue:
            setShowButtonOn(HZIncentivizedAd.isAvailable(forTag: adTag))
        case adUnitSegment.Offerwall.rawValue:
            setShowButtonOn(HZOfferWallAd.isAvailable(forTag: adTag))
        default:
            break
        }
    }
    
    func setShowButtonOn(_ on: Bool) {
        showButton?.backgroundColor = on ? UIColor.green : UIColor.red
    }
    
    // MARK: Button handlers
    @objc func fetchAd(_ sender: Any?) {
        var adTag = adTagText()
        
        if adTag != "" {
            log(toConsole: "Fetching for tag: \(adTag)")
        } else {
            log(toConsole: "Fetching for default tag")
            adTag = nil
        }
        
        let completionBlock: ((Bool, Error?) -> Void)? = { result, err in
            if let anErr = err {
                self.log(toConsole: "Fetch successful? \(result ? "yes" : "no") error: \(anErr)")
            }
        }
        
        switch adUnitSegmentedControl!.selectedSegmentIndex {
        case adUnitSegment.Interstitial.rawValue:
            HZInterstitialAd.fetch(forTag: adTag, withCompletion: completionBlock)
        case adUnitSegment.Video.rawValue:
            HZVideoAd.fetch(forTag: adTag, withCompletion: completionBlock)
        case adUnitSegment.Incentivized.rawValue:
            HZIncentivizedAd.fetch(forTag: adTag, withCompletion: completionBlock)
        case adUnitSegment.Offerwall.rawValue:
            HZOfferWallAd.fetch(forTag: adTag, withCompletion: completionBlock)
        default:
            break
        }
        
    }
    
    @objc func showAd(_ sender: Any?) {
        view.endEditing(true)
        var adTag = adTagText()
        if adTag != "" {
            log(toConsole: "Showing for tag: \(String(describing: adTag))")
        } else {
            log(toConsole: "Showing for default tag")
            adTag = nil
        }
        
        switch adUnitSegmentedControl!.selectedSegmentIndex {
        case adUnitSegment.Interstitial.rawValue:
            print("Showing Interstitial")
            HZInterstitialAd.show(forTag: adTag)
        case adUnitSegment.Video.rawValue:
            print("Showing Video")
            HZVideoAd.show(forTag: adTag)
        case adUnitSegment.Incentivized.rawValue:
            print("Showing Incentivized")
            HZIncentivizedAd.show(forTag: adTag)
        case adUnitSegment.Offerwall.rawValue:
            print("Showing OfferWall")
            HZOfferWallAd.show(forTag: adTag)
        default:
            break
        }
    }
    
    @objc func showBannerButtonPressed(_ sender: Any?) {
        showBannerButton?.isEnabled = true
        
        view.endEditing(true)
        
        let opts = HZBannerAdOptions()
        opts.presentingViewController = self
        opts.tag = adTagText()
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            //            opts.admobBannerSize = HZAdMobBannerSizeFlexibleWidthLandscape
            opts.admobBannerSize = HZAdMobBannerSize.flexibleWidthLandscape
        }
        
        HZBannerAd.placeBanner(in: view, position: HZBannerPosition.bottom, options: opts, success: { (banner) in
//            banner?.delegate = self as? HZBannerAdDelegate
            self.hideBannerButton?.isEnabled = true
            self.currentBannerAd = banner
        }, failure: { (Error) in
            self.showBannerButton?.isEnabled = true
            if let anError = Error {
                self.log(toConsole: "Failed to place banner ad, Error: \(anError)")
            }
        })
    }
    
    @objc func hideBannerButtonPressed(_ sender: Any?) {
        view.endEditing(true)
        currentBannerAd?.removeFromSuperview()
        currentBannerAd = nil
        
        hideBannerButton?.isEnabled = false
        showBannerButton?.isEnabled = true
    }
    
    @objc func clearButtonPressed() {
        consoleTextView!.text = ""
    }
    
    @objc func topButtonPressed() {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        consoleTextView!.scrollRectToVisible(rect, animated: false)
    }
    
    @objc func bottomButtonPressed() {
        let rect = CGRect(x: 0, y: (consoleTextView!.contentSize.height - 1), width: consoleTextView!.frame.size.width, height: consoleTextView!.contentSize.height)
        consoleTextView!.scrollRectToVisible(rect, animated: false)
    }
    
    @objc func emailConsoleButtionPressed() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setSubject("Heyzap SDK Sample App log")
            
            if let anEncoding = consoleTextView!.text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                mail.addAttachmentData(anEncoding, mimeType: "text/plain", fileName: "consoleLog.txt")
            }
            present(mail, animated: true)
        } else {
            UIAlertView(title: "Can't send email", message: "This device is not setup to deliver email.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "").show()
        }
    }
    
    @objc func showTestActivity() {
        HeyzapAds.presentMediationDebugViewController()
    }
    
    @objc func checkAvailability() {
        let adTag = adTagText()
        var adType: String?
        var available = false
        
        switch adUnitSegmentedControl!.selectedSegmentIndex {
        case adUnitSegment.Interstitial.rawValue:
            available = HZInterstitialAd.isAvailable(forTag: adTag)
            adType = "An interstitial"
        case adUnitSegment.Video.rawValue:
            available = HZVideoAd.isAvailable(forTag: adTag)
            adType = "A video"
        case adUnitSegment.Incentivized.rawValue:
            available = HZIncentivizedAd.isAvailable(forTag: adTag)
            adType = "An incentivized"
        case adUnitSegment.Offerwall.rawValue:
            available = HZOfferWallAd.isAvailable(forTag: adTag)
            adType = "An offer wall"
        default:
            break
        }
        
        if adType != "" {
            self.setShowButtonOn(available)
            log(toConsole: "\(adType) ad \(available ? "is" : "is not") available for tag: \(adTag).")
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

