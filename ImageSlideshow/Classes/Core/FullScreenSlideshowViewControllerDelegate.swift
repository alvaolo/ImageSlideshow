//
//  FullScreenSlideshowViewControllerDelegate.swift
//  ImageSlideshow
//
//  Created by Charles Lambert on 2020-04-09.
//
//  Updated by Antoine Lessard on 1.12.2020
//

import Foundation

@objc
public protocol FullScreenSlideshowViewControllerDelegate: class {
    func fullScreenSlideshowViewControllerDidTapDeletePhoto(_ fullScreenSlideshowViewController: FullScreenSlideshowViewController, photoIndex: Int)

    func fullScreenSlideshowViewControllerDidTapSetAsMainPhoto(_ fullScreenSlideshowViewController: FullScreenSlideshowViewController, photoIndex: Int)
}
