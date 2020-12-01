//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 31.08.15.
//
//  Updated by Antoine Lessard on 1.12.2020
//

import UIKit

@objcMembers
open class FullScreenSlideshowViewController: UIViewController {

    open var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.zoomEnabled = true
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        // turns off the timer
        slideshow.slideshowInterval = 0
        slideshow.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        return slideshow
    }()

    /// Close button 
    open var closeButton = UIButton()

    /// Delete button
    open var deleteButton = UIButton()
    
    /// Set as main button
    open var setAsMainButton = UIButton()

    /// Closure called on page selection
    open var pageSelected: ((_ page: Int) -> Void)?

    /// Index of initial image
    open var initialPage: Int = 0

    /// Input sources to 
    open var inputs: [InputSource]?

    /// Background color
    open var backgroundColor = UIColor.black

    /// Enables/disable zoom
    open var zoomEnabled = true {
        didSet {
            slideshow.zoomEnabled = zoomEnabled
        }
    }

    /// Delegate
    open weak var delegate: FullScreenSlideshowViewControllerDelegate?

    fileprivate var isInit = true

    convenience init() {
        self.init(nibName:nil, bundle:nil)

        if #available(iOS 13.0, *) {
            self.modalPresentationStyle = .fullScreen
            // Use KVC to set the value to preserve backwards compatiblity with Xcode < 11
            self.setValue(true, forKey: "modalInPresentation")
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        slideshow.backgroundColor = backgroundColor

        if let inputs = inputs {
            slideshow.setImageInputs(inputs)
        }

        view.addSubview(slideshow)

        closeButton.setImage(UIImage(named: "ic_back", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        closeButton.sizeToFit()
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), for: UIControlEvents.touchUpInside)
        view.addSubview(closeButton)

        deleteButton.setImage(UIImage(named: "ic_delete", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        deleteButton.sizeToFit()
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.deleteCurrentPhoto), for: .touchUpInside)
        view.addSubview(deleteButton)
        
        setMainButton.setImage(UIImage(named: "ic_star", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        setMainButton.sizeToFit()
        setMainButton.tintColor = .white
        setMainButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.setAsMainPhoto), for: .touchUpInside)
        view.addSubview(setMainButton)

    }

    override open var prefersStatusBarHidden: Bool {
        return true
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isInit {
            isInit = false
            slideshow.setCurrentPage(initialPage, animated: false)
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        slideshow.slideshowItems.forEach { $0.cancelPendingLoad() }
    }

    open override func viewDidLayoutSubviews() {
        if !isBeingDismissed {
            let safeAreaInsets: UIEdgeInsets
            if #available(iOS 11.0, *) {
                safeAreaInsets = view.safeAreaInsets
            } else {
                safeAreaInsets = UIEdgeInsets.zero
            }
            
            closeButton.frame = CGRect(x: max(24, safeAreaInsets.left), y: max(24, safeAreaInsets.top), width: closeButton.frame.width, height: closeButton.frame.height)

            let deleteButtonMinX =  view.frame.width - closeButton.frame.minX - deleteButton.frame.width
            deleteButton.frame = CGRect(x: deleteButtonMinX, y: closeButton.frame.minY, width: deleteButton.frame.width, height: deleteButton.frame.height)
            
            let setMainButtonMinX = deleteButtonMinX - deleteButton.frame.width - setMainButton.frame.width
            setMainButton.frame = CGRect(x: setMainButtonMinX, y: closeButton.frame.minY, width: setMainButton.frame.width, height: setMainButton.frame.height)

        }

        slideshow.frame = view.frame
    }

    @objc func close() {
        // if pageSelected closure set, send call it with current page
        if let pageSelected = pageSelected {
            pageSelected(slideshow.currentPage)
        }

        dismiss(animated: true, completion: nil)
    }

    @objc func deleteCurrentPhoto() {
        delegate?.fullScreenSlideshowViewControllerDidTapDeletePhoto(self, photoIndex: slideshow.currentPage)
        dismiss(animated: true)
    }
    
    @objc func setAsMainPhoto(){
        delegate?.fullScreenSlideshowViewControllerDidTapSetAsMainPhoto(self, photoIndex: slideshow.currentPage)
        dismiss(animated: true)
    }
}
