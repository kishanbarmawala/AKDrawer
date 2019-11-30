import Foundation
import CoreGraphics
import UIKit
import QuartzCore

@objc public class IQPreviousNextView: UIView { }

open class IQTitleBarButtonItem: IQBarButtonItem {
    
    @objc open var titleFont: UIFont? {
        
        didSet {
            if let unwrappedFont = titleFont {
                titleButton?.titleLabel?.font = unwrappedFont
            } else {
                titleButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
    
    @objc override open var title: String? {
        didSet {
            titleButton?.setTitle(title, for: .normal)
        }
    }
    
    @objc open var titleColor: UIColor? {
        
        didSet {
            
            if let color = titleColor {
                titleButton?.setTitleColor(color, for: .disabled)
            } else {
                titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
            }
        }
    }
    
    @objc open var selectableTitleColor: UIColor? {
        
        didSet {
            
            if let color = selectableTitleColor {
                titleButton?.setTitleColor(color, for: .normal)
            } else {
                titleButton?.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: .normal)
            }
        }
    }
    
    @objc override open var invocation: IQInvocation? {
        
        didSet {
            
            if let target = invocation?.target, let action = invocation?.action {
                self.isEnabled = true
                titleButton?.isEnabled = true
                titleButton?.addTarget(target, action: action, for: .touchUpInside)
            } else {
                self.isEnabled = false
                titleButton?.isEnabled = false
                titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
            }
        }
    }
    
    internal var titleButton: UIButton?
    private var _titleView: UIView?
    
    override init() {
        super.init()
    }
    
    @objc public convenience init(title: String?) {
        
        self.init(title: nil, style: .plain, target: nil, action: nil)
        
        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clear
        
        titleButton = UIButton(type: .system)
        titleButton?.isEnabled = false
        titleButton?.titleLabel?.numberOfLines = 3
        titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        titleButton?.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: .normal)
        titleButton?.backgroundColor = UIColor.clear
        titleButton?.titleLabel?.textAlignment = .center
        titleButton?.setTitle(title, for: .normal)
        titleFont = UIFont.systemFont(ofSize: 13.0)
        titleButton?.titleLabel?.font = self.titleFont
        _titleView?.addSubview(titleButton!)
        
        #if swift(>=3.2)
        if #available(iOS 11, *) {
            
            var layoutDefaultLowPriority: UILayoutPriority
            var layoutDefaultHighPriority: UILayoutPriority
            
            #if swift(>=4.0)
            let layoutPriorityLowValue = UILayoutPriority.defaultLow.rawValue-1
            let layoutPriorityHighValue = UILayoutPriority.defaultHigh.rawValue-1
            layoutDefaultLowPriority = UILayoutPriority(rawValue: layoutPriorityLowValue)
            layoutDefaultHighPriority = UILayoutPriority(rawValue: layoutPriorityHighValue)
            #else
            layoutDefaultLowPriority = UILayoutPriorityDefaultLow-1
            layoutDefaultHighPriority = UILayoutPriorityDefaultHigh-1
            #endif
            
            _titleView?.translatesAutoresizingMaskIntoConstraints = false
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)
            
            titleButton?.translatesAutoresizingMaskIntoConstraints = false
            titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)
            
            let top = NSLayoutConstraint.init(item: titleButton!, attribute: .top, relatedBy: .equal, toItem: _titleView, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint.init(item: titleButton!, attribute: .bottom, relatedBy: .equal, toItem: _titleView, attribute: .bottom, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint.init(item: titleButton!, attribute: .leading, relatedBy: .equal, toItem: _titleView, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint.init(item: titleButton!, attribute: .trailing, relatedBy: .equal, toItem: _titleView, attribute: .trailing, multiplier: 1, constant: 0)
            
            _titleView?.addConstraints([top, bottom, leading, trailing])
        } else {
            _titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            titleButton?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        #else
        _titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleButton?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        #endif
        
        customView = _titleView
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        customView = nil
        titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
        _titleView = nil
        titleButton = nil
    }
}

open class IQBarButtonItem: UIBarButtonItem {
    
    private static var _classInitialize: Void = classInitialize()
    
    @objc public override init() {
        _ = IQBarButtonItem._classInitialize
        super.init()
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        _ = IQBarButtonItem._classInitialize
        super.init(coder: aDecoder)
    }
    
    private class func classInitialize() {
        
        let  appearanceProxy = self.appearance()
        
        #if swift(>=4.2)
        let states: [UIControl.State]
        #else
        let states: [UIControlState]
        #endif
        
        states = [.normal, .highlighted, .disabled, .selected, .application, .reserved]
        
        for state in states {
            
            appearanceProxy.setBackgroundImage(nil, for: state, barMetrics: .default)
            appearanceProxy.setBackgroundImage(nil, for: state, style: .done, barMetrics: .default)
            appearanceProxy.setBackgroundImage(nil, for: state, style: .plain, barMetrics: .default)
            appearanceProxy.setBackButtonBackgroundImage(nil, for: state, barMetrics: .default)
        }
        
        appearanceProxy.setTitlePositionAdjustment(UIOffset(), for: .default)
        appearanceProxy.setBackgroundVerticalPositionAdjustment(0, for: .default)
        appearanceProxy.setBackButtonBackgroundVerticalPositionAdjustment(0, for: .default)
    }
    
    @objc override open var tintColor: UIColor? {
        didSet {
            
            #if swift(>=4.2)
            var textAttributes = [NSAttributedString.Key: Any]()
            let foregroundColorKey = NSAttributedString.Key.foregroundColor
            #elseif swift(>=4)
            var textAttributes = [NSAttributedStringKey: Any]()
            let foregroundColorKey = NSAttributedStringKey.foregroundColor
            #else
            var textAttributes = [String: Any]()
            let foregroundColorKey = NSForegroundColorAttributeName
            #endif
            
            textAttributes[foregroundColorKey] = tintColor
            
            #if swift(>=4)
            
            if let attributes = titleTextAttributes(for: .normal) {
                
                for (key, value) in attributes {
                    #if swift(>=4.2)
                    textAttributes[key] = value
                    #else
                    textAttributes[NSAttributedStringKey.init(key)] = value
                    #endif
                }
            }
            
            #else
            
            if let attributes = titleTextAttributes(for: .normal) {
                textAttributes = attributes
            }
            #endif
            
            setTitleTextAttributes(textAttributes, for: .normal)
        }
    }
    
    @objc internal var isSystemItem = false
    
    @objc open func setTarget(_ target: AnyObject?, action: Selector?) {
        if let target = target, let action = action {
            invocation = IQInvocation(target, action)
        } else {
            invocation = nil
        }
    }
    
    @objc open var invocation: IQInvocation?
    
    deinit {
        target = nil
        invocation = nil
    }
}

open class IQToolbar: UIToolbar, UIInputViewAudioFeedback {
    
    private static var _classInitialize: Void = classInitialize()
    
    private class func classInitialize() {
        
        let  appearanceProxy = self.appearance()
        
        appearanceProxy.barTintColor = nil
        
        let positions: [UIBarPosition] = [.any, .bottom, .top, .topAttached]
        
        for position in positions {
            
            appearanceProxy.setBackgroundImage(nil, forToolbarPosition: position, barMetrics: .default)
            appearanceProxy.setShadowImage(nil, forToolbarPosition: .any)
        }
        
        appearanceProxy.backgroundColor = nil
    }
    
    private var privatePreviousBarButton: IQBarButtonItem?
    @objc open var previousBarButton: IQBarButtonItem {
        get {
            if privatePreviousBarButton == nil {
                privatePreviousBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
                privatePreviousBarButton?.accessibilityLabel = "Previous"
            }
            return privatePreviousBarButton!
        }
        
        set (newValue) {
            privatePreviousBarButton = newValue
        }
    }
    
    private var privateNextBarButton: IQBarButtonItem?
    @objc open var nextBarButton: IQBarButtonItem {
        get {
            if privateNextBarButton == nil {
                privateNextBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
                privateNextBarButton?.accessibilityLabel = "Next"
            }
            return privateNextBarButton!
        }
        
        set (newValue) {
            privateNextBarButton = newValue
        }
    }
    
    private var privateTitleBarButton: IQTitleBarButtonItem?
    @objc open var titleBarButton: IQTitleBarButtonItem {
        get {
            if privateTitleBarButton == nil {
                privateTitleBarButton = IQTitleBarButtonItem(title: nil)
                privateTitleBarButton?.accessibilityLabel = "Title"
            }
            return privateTitleBarButton!
        }
        
        set (newValue) {
            privateTitleBarButton = newValue
        }
    }
    
    private var privateDoneBarButton: IQBarButtonItem?
    @objc open var doneBarButton: IQBarButtonItem {
        get {
            if privateDoneBarButton == nil {
                privateDoneBarButton = IQBarButtonItem(title: nil, style: .done, target: nil, action: nil)
                privateDoneBarButton?.accessibilityLabel = "Done"
            }
            return privateDoneBarButton!
        }
        
        set (newValue) {
            privateDoneBarButton = newValue
        }
    }
    
    private var privateFixedSpaceBarButton: IQBarButtonItem?
    @objc open var fixedSpaceBarButton: IQBarButtonItem {
        get {
            if privateFixedSpaceBarButton == nil {
                privateFixedSpaceBarButton = IQBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            }
            privateFixedSpaceBarButton!.isSystemItem = true
            
            if #available(iOS 10, *) {
                privateFixedSpaceBarButton!.width = 6
            } else {
                privateFixedSpaceBarButton!.width = 20
            }
            
            return privateFixedSpaceBarButton!
        }
        
        set (newValue) {
            privateFixedSpaceBarButton = newValue
        }
    }
    
    override init(frame: CGRect) {
        _ = IQToolbar._classInitialize
        super.init(frame: frame)
        
        sizeToFit()
        
        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        _ = IQToolbar._classInitialize
        super.init(coder: aDecoder)
        
        sizeToFit()
        
        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
    }
    
    @objc override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }
    
    @objc override open var tintColor: UIColor! {
        
        didSet {
            if let unwrappedItems = items {
                for item in unwrappedItems {
                    item.tintColor = tintColor
                }
            }
        }
    }
    
    @objc override open var barStyle: UIBarStyle {
        didSet {
            
            if titleBarButton.selectableTitleColor == nil {
                if barStyle == .default {
                    titleBarButton.titleButton?.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: .normal)
                } else {
                    titleBarButton.titleButton?.setTitleColor(UIColor.yellow, for: .normal)
                }
            }
        }
    }
    
    @objc override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        #if swift(>=3.2)
        
        if #available(iOS 11, *) {
            return
        } else if let customTitleView = titleBarButton.customView {
            var leftRect = CGRect.null
            var rightRect = CGRect.null
            var isTitleBarButtonFound = false
            
            let sortedSubviews = self.subviews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in
                if view1.frame.minX != view2.frame.minX {
                    return view1.frame.minX < view2.frame.minX
                } else {
                    return view1.frame.minY < view2.frame.minY
                }
            })
            
            for barButtonItemView in sortedSubviews {
                
                if isTitleBarButtonFound == true {
                    rightRect = barButtonItemView.frame
                    break
                } else if barButtonItemView === customTitleView {
                    isTitleBarButtonFound = true
                    //If it's UIToolbarButton or UIToolbarTextButton (which actually UIBarButtonItem)
                } else if barButtonItemView.isKind(of: UIControl.self) == true {
                    leftRect = barButtonItemView.frame
                }
            }
            
            let titleMargin: CGFloat = 16
            
            let maxWidth: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
            let maxHeight = self.frame.height
            
            let sizeThatFits = customTitleView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            
            var titleRect: CGRect
            
            if sizeThatFits.width > 0 && sizeThatFits.height > 0 {
                let width = min(sizeThatFits.width, maxWidth)
                let height = min(sizeThatFits.height, maxHeight)
                
                var xPosition: CGFloat
                
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX + ((maxWidth - width)/2)
                } else {
                    xPosition = titleMargin
                }
                
                let yPosition = (maxHeight - height)/2
                
                titleRect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            } else {
                
                var xPosition: CGFloat
                
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX
                } else {
                    xPosition = titleMargin
                }
                
                let width: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
                
                titleRect = CGRect(x: xPosition, y: 0, width: width, height: maxHeight)
            }
            
            customTitleView.frame = titleRect
        }
        
        #else
        if let customTitleView = titleBarButton.customView {
            var leftRect = CGRect.null
            var rightRect = CGRect.null
            var isTitleBarButtonFound = false
            
            let sortedSubviews = self.subviews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in
                if view1.frame.minX != view2.frame.minX {
                    return view1.frame.minX < view2.frame.minX
                } else {
                    return view1.frame.minY < view2.frame.minY
                }
            })
            
            for barButtonItemView in sortedSubviews {
                
                if isTitleBarButtonFound == true {
                    rightRect = barButtonItemView.frame
                    break
                } else if barButtonItemView === titleBarButton.customView {
                    isTitleBarButtonFound = true
                    //If it's UIToolbarButton or UIToolbarTextButton (which actually UIBarButtonItem)
                } else if barButtonItemView.isKind(of: UIControl.self) == true {
                    leftRect = barButtonItemView.frame
                }
            }
            
            let titleMargin: CGFloat = 16
            let maxWidth: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
            let maxHeight = self.frame.height
            
            let sizeThatFits = customTitleView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
            
            var titleRect: CGRect
            
            if sizeThatFits.width > 0 && sizeThatFits.height > 0 {
                let width = min(sizeThatFits.width, maxWidth)
                let height = min(sizeThatFits.height, maxHeight)
                
                var xPosition: CGFloat
                
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX + ((maxWidth - width)/2)
                } else {
                    xPosition = titleMargin
                }
                
                let yPosition = (maxHeight - height)/2
                
                titleRect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            } else {
                
                var xPosition: CGFloat
                
                if leftRect.isNull == false {
                    xPosition = titleMargin + leftRect.maxX
                } else {
                    xPosition = titleMargin
                }
                
                let width: CGFloat = self.frame.width - titleMargin*2 - (leftRect.isNull ? 0 : leftRect.maxX) - (rightRect.isNull ? 0 : self.frame.width - rightRect.minX)
                
                titleRect = CGRect(x: xPosition, y: 0, width: width, height: maxHeight)
            }
            
            customTitleView.frame = titleRect
        }
        #endif
    }
    
    @objc open var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    deinit {
        
        items = nil
        privatePreviousBarButton = nil
        privateNextBarButton = nil
        privateTitleBarButton = nil
        privateDoneBarButton = nil
        privateFixedSpaceBarButton = nil
    }
}

private var kIQShouldHideToolbarPlaceholder = "kIQShouldHideToolbarPlaceholder"
private var kIQToolbarPlaceholder           = "kIQToolbarPlaceholder"

private var kIQKeyboardToolbar              = "kIQKeyboardToolbar"

@objc public class IQBarButtonItemConfiguration: NSObject {
    
    #if swift(>=4.2)
    @objc public init(barButtonSystemItem: UIBarButtonItem.SystemItem, action: Selector) {
        self.barButtonSystemItem = barButtonSystemItem
        self.image = nil
        self.title = nil
        self.action = action
        super.init()
    }
    #else
    @objc public init(barButtonSystemItem: UIBarButtonSystemItem, action: Selector) {
        self.barButtonSystemItem = barButtonSystemItem
        self.image = nil
        self.title = nil
        self.action = action
        super.init()
    }
    #endif
    
    @objc public init(image: UIImage, action: Selector) {
        self.barButtonSystemItem = nil
        self.image = image
        self.title = nil
        self.action = action
        super.init()
    }
    
    @objc public init(title: String, action: Selector) {
        self.barButtonSystemItem = nil
        self.image = nil
        self.title = title
        self.action = action
        super.init()
    }
    
    #if swift(>=4.2)
    public let barButtonSystemItem: UIBarButtonItem.SystemItem?    //System Item to be used to instantiate bar button.
    #else
    public let barButtonSystemItem: UIBarButtonSystemItem?    //System Item to be used to instantiate bar button.
    #endif
    
    @objc public let image: UIImage?    //Image to show on bar button item if it's not a system item.
    
    @objc public let title: String?     //Title to show on bar button item if it's not a system item.
    
    @objc public let action: Selector?  //action for bar button item. Usually 'doneAction:(IQBarButtonItem*)item'.
}

@objc public extension UIImage {
    
    @objc static func keyboardPreviousiOS9Image() -> UIImage? {
        
        struct Static {
            static var keyboardPreviousiOS9Image: UIImage?
        }
        
        if Static.keyboardPreviousiOS9Image == nil {
            // Get the top level "bundle" which may actually be the framework
            var bundle = Bundle(for: IQKeyboardManager.self)
            
            if let resourcePath = bundle.path(forResource: "IQKeyboardManager", ofType: "bundle") {
                if let resourcesBundle = Bundle(path: resourcePath) {
                    bundle = resourcesBundle
                }
            }
            
            Static.keyboardPreviousiOS9Image = UIImage(named: "IQButtonBarArrowLeft", in: bundle, compatibleWith: nil)
            
            //Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
            if #available(iOS 9, *) {
                Static.keyboardPreviousiOS9Image = Static.keyboardPreviousiOS9Image?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        
        return Static.keyboardPreviousiOS9Image
    }
    
    @objc static func keyboardNextiOS9Image() -> UIImage? {
        
        struct Static {
            static var keyboardNextiOS9Image: UIImage?
        }
        
        if Static.keyboardNextiOS9Image == nil {
            // Get the top level "bundle" which may actually be the framework
            var bundle = Bundle(for: IQKeyboardManager.self)
            
            if let resourcePath = bundle.path(forResource: "IQKeyboardManager", ofType: "bundle") {
                if let resourcesBundle = Bundle(path: resourcePath) {
                    bundle = resourcesBundle
                }
            }
            
            Static.keyboardNextiOS9Image = UIImage(named: "IQButtonBarArrowRight", in: bundle, compatibleWith: nil)
            
            if #available(iOS 9, *) {
                Static.keyboardNextiOS9Image = Static.keyboardNextiOS9Image?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        
        return Static.keyboardNextiOS9Image
    }
    
    @objc static func keyboardPreviousiOS10Image() -> UIImage? {
        
        struct Static {
            static var keyboardPreviousiOS10Image: UIImage?
        }
        
        if Static.keyboardPreviousiOS10Image == nil {
            // Get the top level "bundle" which may actually be the framework
            var bundle = Bundle(for: IQKeyboardManager.self)
            
            if let resourcePath = bundle.path(forResource: "IQKeyboardManager", ofType: "bundle") {
                if let resourcesBundle = Bundle(path: resourcePath) {
                    bundle = resourcesBundle
                }
            }
            
            Static.keyboardPreviousiOS10Image = UIImage(named: "IQButtonBarArrowUp", in: bundle, compatibleWith: nil)
            
            //Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
            if #available(iOS 9, *) {
                Static.keyboardPreviousiOS10Image = Static.keyboardPreviousiOS10Image?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        
        return Static.keyboardPreviousiOS10Image
    }
    
    @objc static func keyboardNextiOS10Image() -> UIImage? {
        
        struct Static {
            static var keyboardNextiOS10Image: UIImage?
        }
        
        if Static.keyboardNextiOS10Image == nil {
            // Get the top level "bundle" which may actually be the framework
            var bundle = Bundle(for: IQKeyboardManager.self)
            
            if let resourcePath = bundle.path(forResource: "IQKeyboardManager", ofType: "bundle") {
                if let resourcesBundle = Bundle(path: resourcePath) {
                    bundle = resourcesBundle
                }
            }
            
            Static.keyboardNextiOS10Image = UIImage(named: "IQButtonBarArrowDown", in: bundle, compatibleWith: nil)
            
            //Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
            if #available(iOS 9, *) {
                Static.keyboardNextiOS10Image = Static.keyboardNextiOS10Image?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
        
        return Static.keyboardNextiOS10Image
    }
    
    @objc static func keyboardPreviousImage() -> UIImage? {
        
        if #available(iOS 10, *) {
            return keyboardPreviousiOS10Image()
        } else {
            return keyboardPreviousiOS9Image()
        }
    }
    
    @objc static func keyboardNextImage() -> UIImage? {
        
        if #available(iOS 10, *) {
            return keyboardNextiOS10Image()
        } else {
            return keyboardNextiOS9Image()
        }
    }
}

@objc public extension UIView {
    
    @objc var keyboardToolbar: IQToolbar {
        var toolbar = inputAccessoryView as? IQToolbar
        
        if toolbar == nil {
            toolbar = objc_getAssociatedObject(self, &kIQKeyboardToolbar) as? IQToolbar
        }
        
        if let unwrappedToolbar = toolbar {
            
            return unwrappedToolbar
            
        } else {
            
            let newToolbar = IQToolbar()
            
            objc_setAssociatedObject(self, &kIQKeyboardToolbar, newToolbar, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return newToolbar
        }
    }
    
    @objc var shouldHideToolbarPlaceholder: Bool {
        get {
            let aValue = objc_getAssociatedObject(self, &kIQShouldHideToolbarPlaceholder) as Any?
            
            if let unwrapedValue = aValue as? Bool {
                return unwrapedValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldHideToolbarPlaceholder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.keyboardToolbar.titleBarButton.title = self.drawingToolbarPlaceholder
        }
    }
    
    @objc var toolbarPlaceholder: String? {
        get {
            let aValue = objc_getAssociatedObject(self, &kIQToolbarPlaceholder) as? String
            
            return aValue
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQToolbarPlaceholder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.keyboardToolbar.titleBarButton.title = self.drawingToolbarPlaceholder
        }
    }
    
    @objc var drawingToolbarPlaceholder: String? {
        
        if self.shouldHideToolbarPlaceholder {
            return nil
        } else if self.toolbarPlaceholder?.isEmpty == false {
            return self.toolbarPlaceholder
        } else if self.responds(to: #selector(getter: UITextField.placeholder)) {
            
            if let textField = self as? UITextField {
                return textField.placeholder
            } else if let textView = self as? IQTextView {
                return textView.placeholder
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private static func flexibleBarButtonItem () -> IQBarButtonItem {
        
        struct Static {
            
            static let nilButton = IQBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        Static.nilButton.isSystemItem = true
        return Static.nilButton
    }
    
    @objc func addKeyboardToolbarWithTarget(target: AnyObject?, titleText: String?, rightBarButtonConfiguration: IQBarButtonItemConfiguration?, previousBarButtonConfiguration: IQBarButtonItemConfiguration? = nil, nextBarButtonConfiguration: IQBarButtonItemConfiguration? = nil) {
        
        //If can't set InputAccessoryView. Then return
        if self.responds(to: #selector(setter: UITextField.inputAccessoryView)) {
            
            //  Creating a toolBar for phoneNumber keyboard
            let toolbar = self.keyboardToolbar
            
            var items: [IQBarButtonItem] = []
            
            if let prevConfig = previousBarButtonConfiguration {
                
                var prev = toolbar.previousBarButton
                
                if prevConfig.barButtonSystemItem == nil && prev.isSystemItem == false {
                    prev.title = prevConfig.title
                    prev.image = prevConfig.image
                    prev.target = target
                    prev.action = prevConfig.action
                } else {
                    if let systemItem = prevConfig.barButtonSystemItem {
                        prev = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: prevConfig.action)
                        prev.isSystemItem = true
                    } else if let image = prevConfig.image {
                        prev = IQBarButtonItem(image: image, style: .plain, target: target, action: prevConfig.action)
                    } else {
                        prev = IQBarButtonItem(title: prevConfig.title, style: .plain, target: target, action: prevConfig.action)
                    }
                    
                    prev.invocation = toolbar.previousBarButton.invocation
                    prev.accessibilityLabel = toolbar.previousBarButton.accessibilityLabel
                    prev.isEnabled = toolbar.previousBarButton.isEnabled
                    prev.tag = toolbar.previousBarButton.tag
                    toolbar.previousBarButton = prev
                }
                
                items.append(prev)
            }
            
            if previousBarButtonConfiguration != nil && nextBarButtonConfiguration != nil {
                
                items.append(toolbar.fixedSpaceBarButton)
            }
            
            if let nextConfig = nextBarButtonConfiguration {
                
                var next = toolbar.nextBarButton
                
                if nextConfig.barButtonSystemItem == nil && next.isSystemItem == false {
                    next.title = nextConfig.title
                    next.image = nextConfig.image
                    next.target = target
                    next.action = nextConfig.action
                } else {
                    if let systemItem = nextConfig.barButtonSystemItem {
                        next = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: nextConfig.action)
                        next.isSystemItem = true
                    } else if let image = nextConfig.image {
                        next = IQBarButtonItem(image: image, style: .plain, target: target, action: nextConfig.action)
                    } else {
                        next = IQBarButtonItem(title: nextConfig.title, style: .plain, target: target, action: nextConfig.action)
                    }
                    
                    next.invocation = toolbar.nextBarButton.invocation
                    next.accessibilityLabel = toolbar.nextBarButton.accessibilityLabel
                    next.isEnabled = toolbar.nextBarButton.isEnabled
                    next.tag = toolbar.nextBarButton.tag
                    toolbar.nextBarButton = next
                }
                
                items.append(next)
            }
            
            //Title bar button item
            do {
                //Flexible space
                items.append(UIView.flexibleBarButtonItem())
                
                //Title button
                toolbar.titleBarButton.title = titleText
                
                #if swift(>=3.2)
                if #available(iOS 11, *) {} else {
                    toolbar.titleBarButton.customView?.frame = CGRect.zero
                }
                #else
                toolbar.titleBarButton.customView?.frame = CGRect.zero
                #endif
                
                items.append(toolbar.titleBarButton)
                
                //Flexible space
                items.append(UIView.flexibleBarButtonItem())
            }
            
            if let rightConfig = rightBarButtonConfiguration {
                
                var done = toolbar.doneBarButton
                
                if rightConfig.barButtonSystemItem == nil && done.isSystemItem == false {
                    done.title = rightConfig.title
                    done.image = rightConfig.image
                    done.target = target
                    done.action = rightConfig.action
                } else {
                    if let systemItem = rightConfig.barButtonSystemItem {
                        done = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: rightConfig.action)
                        done.isSystemItem = true
                    } else if let image = rightConfig.image {
                        done = IQBarButtonItem(image: image, style: .plain, target: target, action: rightConfig.action)
                    } else {
                        done = IQBarButtonItem(title: rightConfig.title, style: .plain, target: target, action: rightConfig.action)
                    }
                    
                    done.invocation = toolbar.doneBarButton.invocation
                    done.accessibilityLabel = toolbar.doneBarButton.accessibilityLabel
                    done.isEnabled = toolbar.doneBarButton.isEnabled
                    done.tag = toolbar.doneBarButton.tag
                    toolbar.doneBarButton = done
                }
                
                items.append(done)
            }
            
            //  Adding button to toolBar.
            toolbar.items = items
            
            //  Setting toolbar to keyboard.
            if let textField = self as? UITextField {
                textField.inputAccessoryView = toolbar
                
                switch textField.keyboardAppearance {
                case .dark:
                    toolbar.barStyle = UIBarStyle.black
                default:
                    toolbar.barStyle = UIBarStyle.default
                }
            } else if let textView = self as? UITextView {
                textView.inputAccessoryView = toolbar
                
                switch textView.keyboardAppearance {
                case .dark:
                    toolbar.barStyle = UIBarStyle.black
                default:
                    toolbar.barStyle = UIBarStyle.default
                }
            }
        }
    }
    
    @objc func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        
        addDoneOnKeyboardWithTarget(target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: action)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    
    @objc func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        
        addRightButtonOnKeyboardWithImage(image, target: target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(image: image, action: action)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    
    @objc func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false) {
        
        addRightButtonOnKeyboardWithText(text, target: target, action: action, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(title: text, action: action)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }
    
    @objc func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addCancelDoneOnKeyboardWithTarget(target, cancelAction: cancelAction, doneAction: doneAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addRightLeftOnKeyboardWithTarget(target, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addRightLeftOnKeyboardWithTarget(target, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, titleText: String?) {
        
        let leftConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .cancel, action: cancelAction)
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?) {
        
        let leftConfiguration = IQBarButtonItemConfiguration(title: leftButtonTitle, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    
    @objc func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?) {
        
        let leftConfiguration = IQBarButtonItemConfiguration(image: leftButtonImage, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }
    
    @objc func addPreviousNextDoneOnKeyboardWithTarget (_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addPreviousNextDoneOnKeyboardWithTarget(target, previousAction: previousAction, nextAction: nextAction, doneAction: doneAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonImage: rightButtonImage, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false) {
        
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonTitle: rightButtonTitle, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: (shouldShowPlaceholder ? self.drawingToolbarPlaceholder: nil))
    }
    
    @objc func addPreviousNextDoneOnKeyboardWithTarget (_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
    
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
    
    @objc func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?) {
        
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)
        
        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
}

@objc public class IQInvocation: NSObject {
    @objc public weak var target: AnyObject?
    @objc public var action: Selector
    
    @objc public init(_ target: AnyObject, _ action: Selector) {
        self.target = target
        self.action = action
    }
    
    @objc public func invoke(from: Any) {
        if let target = target {
            UIApplication.shared.sendAction(action, to: target, from: from, for: UIEvent())
        }
    }
    
    deinit {
        target = nil
    }
}


@objc public enum IQAutoToolbarManageBehaviour: Int {
    case bySubviews
    case byTag
    case byPosition
}

@objc public enum IQPreviousNextDisplayMode: Int {
    case `default`
    case alwaysHide
    case alwaysShow
}

@objc public enum IQEnableMode: Int {
    case `default`
    case enabled
    case disabled
}

@objc public class IQKeyboardManager: NSObject, UIGestureRecognizerDelegate {
    
    private static let  kIQDoneButtonToolbarTag         =   -1002
    private static let  kIQPreviousNextButtonToolbarTag =   -1005
    private static let  kIQCGPointInvalid = CGPoint.init(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)

    private var registeredClasses  = [UIView.Type]()
    
    @objc public var enable = false {
        
        didSet {
            //If not enable, enable it.
            if enable == true &&
                oldValue == false {
                //If keyboard is currently showing. Sending a fake notification for keyboardWillHide to retain view's original position.
                if let notification = _kbShowNotification {
                    keyboardWillShow(notification)
                }
                showLog("Enabled")
            } else if enable == false &&
                oldValue == true {   //If not disable, desable it.
                keyboardWillHide(nil)
                showLog("Disabled")
            }
        }
    }
    
    private func privateIsEnabled() -> Bool {
        
        var isEnabled = enable
        
        if let textFieldViewController = _textFieldView?.viewContainingController() {
            
            if isEnabled == false {
                
                //If viewController is kind of enable viewController class, then assuming it's enabled.
                for enabledClass in enabledDistanceHandlingClasses {
                    
                    if textFieldViewController.isKind(of: enabledClass) {
                        isEnabled = true
                        break
                    }
                }
            }
            
            if isEnabled == true {
                
                //If viewController is kind of disabled viewController class, then assuming it's disabled.
                for disabledClass in disabledDistanceHandlingClasses {
                    
                    if textFieldViewController.isKind(of: disabledClass) {
                        isEnabled = false
                        break
                    }
                }
                
                //Special Controllers
                if isEnabled == true {
                    
                    let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                    
                    //_UIAlertControllerTextFieldViewController
                    if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                        isEnabled = false
                    }
                }
            }
        }
        //        }
        
        return isEnabled
    }
    
    @objc public var keyboardDistanceFromTextField: CGFloat {
        
        set {
            _privateKeyboardDistanceFromTextField =  max(0, newValue)
            showLog("keyboardDistanceFromTextField: \(_privateKeyboardDistanceFromTextField)")
        }
        get {
            return _privateKeyboardDistanceFromTextField
        }
    }
    
    @objc public var keyboardShowing: Bool {
        
        return _privateIsKeyboardShowing
    }
    
    @objc public var movedDistance: CGFloat {
        
        return _privateMovedDistance
    }

    @objc public class var shared: IQKeyboardManager {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let kbManager = IQKeyboardManager()
        }
        
        /** @return Returns the default singleton instance. */
        return Static.kbManager
    }
    
    @objc public var enableAutoToolbar = true {
        
        didSet {

            privateIsEnableAutoToolbar() ? addToolbarIfRequired() : removeToolbarIfRequired()

            let enableToolbar = enableAutoToolbar ? "Yes" : "NO"

            showLog("enableAutoToolbar: \(enableToolbar)")
        }
    }
    
    private func privateIsEnableAutoToolbar() -> Bool {
        
        var enableToolbar = enableAutoToolbar
        
        if let textFieldViewController = _textFieldView?.viewContainingController() {
            
            if enableToolbar == false {
                
                //If found any toolbar enabled classes then return.
                for enabledClass in enabledToolbarClasses {
                    
                    if textFieldViewController.isKind(of: enabledClass) {
                        enableToolbar = true
                        break
                    }
                }
            }
            
            if enableToolbar == true {
                
                //If found any toolbar disabled classes then return.
                for disabledClass in disabledToolbarClasses {
                    
                    if textFieldViewController.isKind(of: disabledClass) {
                        enableToolbar = false
                        break
                    }
                }
                
                //Special Controllers
                if enableToolbar == true {
                    
                    let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                    
                    //_UIAlertControllerTextFieldViewController
                    if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                        enableToolbar = false
                    }
                }
            }
        }

        return enableToolbar
    }

    @objc public var toolbarManageBehaviour = IQAutoToolbarManageBehaviour.bySubviews
    @objc public var shouldToolbarUsesTextFieldTintColor = false
    @objc public var toolbarTintColor: UIColor?
    @objc public var toolbarBarTintColor: UIColor?
    @objc public var previousNextDisplayMode = IQPreviousNextDisplayMode.default
    @objc public var toolbarPreviousBarButtonItemImage: UIImage?
    @objc public var toolbarNextBarButtonItemImage: UIImage?
    @objc public var toolbarDoneBarButtonItemImage: UIImage?
    @objc public var toolbarPreviousBarButtonItemText: String?
    @objc public var toolbarNextBarButtonItemText: String?
    @objc public var toolbarDoneBarButtonItemText: String?
    @objc public var shouldShowToolbarPlaceholder = true
    @objc public var placeholderFont: UIFont?
    @objc public var placeholderColor: UIColor?
    @objc public var placeholderButtonColor: UIColor?
    private var startingTextViewContentInsets = UIEdgeInsets()
    private var startingTextViewScrollIndicatorInsets = UIEdgeInsets()
    private var isTextViewContentInsetChanged = false
    @objc public var overrideKeyboardAppearance = false
    @objc public var keyboardAppearance = UIKeyboardAppearance.default
    @objc public var shouldResignOnTouchOutside = false {
        
        didSet {
            resignFirstResponderGesture.isEnabled = privateShouldResignOnTouchOutside()
            
            let shouldResign = shouldResignOnTouchOutside ? "Yes" : "NO"
            
            showLog("shouldResignOnTouchOutside: \(shouldResign)")
        }
    }
    @objc lazy public var resignFirstResponderGesture: UITapGestureRecognizer = {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self

        return tapGesture
    }()
    
    private func privateShouldResignOnTouchOutside() -> Bool {
        
        var shouldResign = shouldResignOnTouchOutside
        
        let enableMode = _textFieldView?.shouldResignOnTouchOutsideMode
        
        if enableMode == .enabled {
            shouldResign = true
        } else if enableMode == .disabled {
            shouldResign = false
        } else {
            if let textFieldViewController = _textFieldView?.viewContainingController() {
                
                if shouldResign == false {
                    
                    //If viewController is kind of enable viewController class, then assuming shouldResignOnTouchOutside is enabled.
                    for enabledClass in enabledTouchResignedClasses {
                        
                        if textFieldViewController.isKind(of: enabledClass) {
                            shouldResign = true
                            break
                        }
                    }
                }
                
                if shouldResign == true {
                    
                    //If viewController is kind of disable viewController class, then assuming shouldResignOnTouchOutside is disable.
                    for disabledClass in disabledTouchResignedClasses {
                        
                        if textFieldViewController.isKind(of: disabledClass) {
                            shouldResign = false
                            break
                        }
                    }
                    
                    //Special Controllers
                    if shouldResign == true {
                        
                        let classNameString = NSStringFromClass(type(of: textFieldViewController.self))
                        
                        //_UIAlertControllerTextFieldViewController
                        if classNameString.contains("UIAlertController") && classNameString.hasSuffix("TextFieldViewController") {
                            shouldResign = false
                        }
                    }
                }
            }
        }
        
        return shouldResign
    }
    
    @objc @discardableResult public func resignFirstResponder() -> Bool {
        
        if let textFieldRetain = _textFieldView {
            
            //Resigning first responder
            let isResignFirstResponder = textFieldRetain.resignFirstResponder()
            
            //  If it refuses then becoming it as first responder again.    (Bug ID: #96)
            if isResignFirstResponder == false {
                //If it refuses to resign then becoming it first responder again for getting notifications callback.
                textFieldRetain.becomeFirstResponder()
                
                showLog("Refuses to resign first responder: \(textFieldRetain)")
            }
            
            return isResignFirstResponder
        }
        
        return false
    }
    
    @objc public var canGoPrevious: Bool {
        //Getting all responder view's.
        if let textFields = responderViews() {
            if let  textFieldRetain = _textFieldView {
                
                //Getting index of current textField.
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    
                    //If it is not first textField. then it's previous object canBecomeFirstResponder.
                    if index > 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @objc public var canGoNext: Bool {
        //Getting all responder view's.
        if let textFields = responderViews() {
            if let  textFieldRetain = _textFieldView {
                //Getting index of current textField.
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    
                    //If it is not first textField. then it's previous object canBecomeFirstResponder.
                    if index < textFields.count-1 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @objc @discardableResult public func goPrevious() -> Bool {
        
        //Getting all responder view's.
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                //Getting index of current textField.
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    
                    //If it is not first textField. then it's previous object becomeFirstResponder.
                    if index > 0 {
                        
                        let nextTextField = textFields[index-1]
                        
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        
                        //  If it refuses then becoming previous textFieldView as first responder again.    (Bug ID: #96)
                        if isAcceptAsFirstResponder == false {
                            //If next field refuses to become first responder then restoring old textField as first responder.
                            textFieldRetain.becomeFirstResponder()
                            
                            showLog("Refuses to become first responder: \(nextTextField)")
                        }
                        
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }
        
        return false
    }
    
    @objc @discardableResult public func goNext() -> Bool {

        //Getting all responder view's.
        if let  textFieldRetain = _textFieldView {
            if let textFields = responderViews() {
                //Getting index of current textField.
                if let index = textFields.firstIndex(of: textFieldRetain) {
                    //If it is not last textField. then it's next object becomeFirstResponder.
                    if index < textFields.count-1 {
                        
                        let nextTextField = textFields[index+1]
                        
                        let isAcceptAsFirstResponder = nextTextField.becomeFirstResponder()
                        
                        //  If it refuses then becoming previous textFieldView as first responder again.    (Bug ID: #96)
                        if isAcceptAsFirstResponder == false {
                            //If next field refuses to become first responder then restoring old textField as first responder.
                            textFieldRetain.becomeFirstResponder()
                            
                            showLog("Refuses to become first responder: \(nextTextField)")
                        }
                        
                        return isAcceptAsFirstResponder
                    }
                }
            }
        }

        return false
    }
    
    @objc internal func previousAction (_ barButton: IQBarButtonItem) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if canGoPrevious == true {
            
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goPrevious()
                
                var invocation = barButton.invocation
                var sender = textFieldRetain

                //Handling search bar special case
                do {
                    if let searchBar = textFieldRetain.textFieldSearchBar() {
                        invocation = searchBar.keyboardToolbar.previousBarButton.invocation
                        sender = searchBar
                    }
                }

                if isAcceptAsFirstResponder {
                    invocation?.invoke(from: sender)
                }
            }
        }
    }
    
    @objc internal func nextAction (_ barButton: IQBarButtonItem) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if canGoNext == true {
            
            if let textFieldRetain = _textFieldView {
                let isAcceptAsFirstResponder = goNext()
                
                var invocation = barButton.invocation
                var sender = textFieldRetain

                //Handling search bar special case
                do {
                    if let searchBar = textFieldRetain.textFieldSearchBar() {
                        invocation = searchBar.keyboardToolbar.nextBarButton.invocation
                        sender = searchBar
                    }
                }

                if isAcceptAsFirstResponder {
                    invocation?.invoke(from: sender)
                }
            }
        }
    }
    
    @objc internal func doneAction (_ barButton: IQBarButtonItem) {
        
        //If user wants to play input Click sound.
        if shouldPlayInputClicks == true {
            //Play Input Click Sound.
            UIDevice.current.playInputClick()
        }
        
        if let textFieldRetain = _textFieldView {
            //Resign textFieldView.
            let isResignedFirstResponder = resignFirstResponder()
            
            var invocation = barButton.invocation
            var sender = textFieldRetain

            //Handling search bar special case
            do {
                if let searchBar = textFieldRetain.textFieldSearchBar() {
                    invocation = searchBar.keyboardToolbar.doneBarButton.invocation
                    sender = searchBar
                }
            }

            if isResignedFirstResponder {
                invocation?.invoke(from: sender)
            }
        }
    }
    
    @objc internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == .ended {

            //Resigning currently responder textField.
            resignFirstResponder()
        }
    }
    
    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)    (Bug ID: #145)
        
        for ignoreClass in touchResignedGestureIgnoreClasses {
            
            if touch.view?.isKind(of: ignoreClass) == true {
                return false
            }
        }

        return true
    }
    
    @objc public var shouldPlayInputClicks = true
    @objc public var layoutIfNeededOnUpdate = false
    @objc public var disabledDistanceHandlingClasses  = [UIViewController.Type]()
    @objc public var enabledDistanceHandlingClasses  = [UIViewController.Type]()
    @objc public var disabledToolbarClasses  = [UIViewController.Type]()
    @objc public var enabledToolbarClasses  = [UIViewController.Type]()
    @objc public var toolbarPreviousNextAllowedClasses  = [UIView.Type]()
    @objc public var disabledTouchResignedClasses  = [UIViewController.Type]()
    @objc public var enabledTouchResignedClasses  = [UIViewController.Type]()
    @objc public var touchResignedGestureIgnoreClasses  = [UIView.Type]()
    @objc public func registerTextFieldViewClass(_ aClass: UIView.Type, didBeginEditingNotificationName: String, didEndEditingNotificationName: String) {
        
        registeredClasses.append(aClass)

        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidBeginEditing(_:)), name: Notification.Name(rawValue: didBeginEditingNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidEndEditing(_:)), name: Notification.Name(rawValue: didEndEditingNotificationName), object: nil)
    }
    
    @objc public func unregisterTextFieldViewClass(_ aClass: UIView.Type, didBeginEditingNotificationName: String, didEndEditingNotificationName: String) {
        
        if let index = registeredClasses.firstIndex(where: { element in
            return element == aClass.self
        }) {
            registeredClasses.remove(at: index)
        }

        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: didBeginEditingNotificationName), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: didEndEditingNotificationName), object: nil)
    }
    
    private weak var    _textFieldView: UIView?
    private var         _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
    private weak var    _rootViewControllerWhilePopGestureRecognizerActive: UIViewController?
    private var         _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid
    private weak var    _rootViewController: UIViewController?
    private weak var    _lastScrollView: UIScrollView?
    private var         _startingContentOffset = CGPoint.zero
    private var         _startingScrollIndicatorInsets = UIEdgeInsets()
    private var         _startingContentInsets = UIEdgeInsets()
    private var         _kbShowNotification: Notification?
    private var         _kbFrame = CGRect.zero
    private var         _animationDuration: TimeInterval = 0.25
    #if swift(>=4.2)
    private var         _animationCurve: UIView.AnimationOptions = .curveEaseOut
    #else
    private var         _animationCurve: UIViewAnimationOptions = .curveEaseOut
    #endif

    private var         _privateIsKeyboardShowing = false
    private var         _privateMovedDistance: CGFloat = 0.0
    private var         _privateKeyboardDistanceFromTextField: CGFloat = 10.0
    private var         _privateHasPendingAdjustRequest = false

    override init() {
        
        super.init()

        self.registerAllNotifications()

        resignFirstResponderGesture.isEnabled = shouldResignOnTouchOutside
        
        let textField = UITextField()
        textField.addDoneOnKeyboardWithTarget(nil, action: #selector(self.doneAction(_:)))
        textField.addPreviousNextDoneOnKeyboardWithTarget(nil, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(self.nextAction(_:)), doneAction: #selector(self.doneAction(_:)))
        
        disabledDistanceHandlingClasses.append(UITableViewController.self)
        disabledDistanceHandlingClasses.append(UIAlertController.self)
        disabledToolbarClasses.append(UIAlertController.self)
        disabledTouchResignedClasses.append(UIAlertController.self)
        toolbarPreviousNextAllowedClasses.append(UITableView.self)
        toolbarPreviousNextAllowedClasses.append(UICollectionView.self)
        toolbarPreviousNextAllowedClasses.append(IQPreviousNextView.self)
        touchResignedGestureIgnoreClasses.append(UIControl.self)
        touchResignedGestureIgnoreClasses.append(UINavigationBar.self)
    }
    
    deinit {
        //  Disable the keyboard manager.
        enable = false

        //Removing notification observers on dealloc.
        NotificationCenter.default.removeObserver(self)
    }
    
    /** Getting keyWindow. */
    private func keyWindow() -> UIWindow? {
        
        if let keyWindow = _textFieldView?.window {
            return keyWindow
        } else {
            
            struct Static {
                /** @abstract   Save keyWindow object for reuse.
                @discussion Sometimes [[UIApplication sharedApplication] keyWindow] is returning nil between the app.   */
                static weak var keyWindow: UIWindow?
            }

            //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
            if let originalKeyWindow = UIApplication.shared.keyWindow,
                (Static.keyWindow == nil || Static.keyWindow != originalKeyWindow) {
                Static.keyWindow = originalKeyWindow
            }

            return Static.keyWindow
        }
    }

    private func optimizedAdjustPosition() {
        if _privateHasPendingAdjustRequest == false {
            _privateHasPendingAdjustRequest = true
            OperationQueue.main.addOperation {
                self.adjustPosition()
                self._privateHasPendingAdjustRequest = false
            }
        }
    }

    private func adjustPosition() {
        
        //  We are unable to get textField object while keyboard showing on UIWebView's textField.  (Bug ID: #11)
        if _privateHasPendingAdjustRequest == true,
            let textFieldView = _textFieldView,
            let rootController = textFieldView.parentContainerViewController(),
            let window = keyWindow(),
            let textFieldViewRectInWindow = textFieldView.superview?.convert(textFieldView.frame, to: window),
            let textFieldViewRectInRootSuperview = textFieldView.superview?.convert(textFieldView.frame, to: rootController.view?.superview) {
            let startTime = CACurrentMediaTime()
            showLog("****** \(#function) started ******", indentation: 1)
            
            //  Getting RootViewOrigin.
            var rootViewOrigin = rootController.view.frame.origin
            
            //Maintain keyboardDistanceFromTextField
            var specialKeyboardDistanceFromTextField = textFieldView.keyboardDistanceFromTextField
            
            if let searchBar = textFieldView.textFieldSearchBar() {
                
                specialKeyboardDistanceFromTextField = searchBar.keyboardDistanceFromTextField
            }
            
            let newKeyboardDistanceFromTextField = (specialKeyboardDistanceFromTextField == kIQUseDefaultKeyboardDistance) ? keyboardDistanceFromTextField : specialKeyboardDistanceFromTextField

            var kbSize = _kbFrame.size

            do {
                var kbFrame = _kbFrame

                kbFrame.origin.y -= newKeyboardDistanceFromTextField
                kbFrame.size.height += newKeyboardDistanceFromTextField

                let intersectRect = kbFrame.intersection(window.frame)
                
                if intersectRect.isNull {
                    kbSize = CGSize(width: kbFrame.size.width, height: 0)
                } else {
                    kbSize = intersectRect.size
                }
            }

            let statusBarHeight : CGFloat
            
            #if swift(>=5.1)
            if #available(iOS 13, *) {
                statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            #else
            statusBarHeight = UIApplication.shared.statusBarFrame.height
            #endif

            let navigationBarAreaHeight: CGFloat = statusBarHeight + ( rootController.navigationController?.navigationBar.frame.height ?? 0)
            let layoutAreaHeight: CGFloat = rootController.view.layoutMargins.bottom

            let topLayoutGuide: CGFloat = max(navigationBarAreaHeight, layoutAreaHeight) + 5
            let bottomLayoutGuide: CGFloat = (textFieldView is UITextView) ? 0 : rootController.view.layoutMargins.bottom
            var move: CGFloat = min(textFieldViewRectInRootSuperview.minY-(topLayoutGuide), textFieldViewRectInWindow.maxY-(window.frame.height-kbSize.height)+bottomLayoutGuide)
            
            showLog("Need to move: \(move)")
            
            var superScrollView: UIScrollView?
            var superView = textFieldView.superviewOfClassType(UIScrollView.self) as? UIScrollView
            
            //Getting UIScrollView whose scrolling is enabled.    //  (Bug ID: #285)
            while let view = superView {
                
                if view.isScrollEnabled && view.shouldIgnoreScrollingAdjustment == false {
                    superScrollView = view
                    break
                } else {
                    //  Getting it's superScrollView.   //  (Enhancement ID: #21, #24)
                    superView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
                }
            }
            
            //If there was a lastScrollView.    //  (Bug ID: #34)
            if let lastScrollView = _lastScrollView {
                //If we can't find current superScrollView, then setting lastScrollView to it's original form.
                if superScrollView == nil {
                    
                    if lastScrollView.contentInset != self._startingContentInsets {
                        showLog("Restoring contentInset to: \(_startingContentInsets)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            
                            lastScrollView.contentInset = self._startingContentInsets
                            lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                        })
                    }
                    
                    if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(_startingContentOffset) == false {
                        showLog("Restoring contentOffset to: \(_startingContentOffset)")
                        
                        var animatedContentOffset = false   //  (Bug ID: #1365, #1508, #1541)

                        if #available(iOS 9, *) {
                            animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                        }

                        if animatedContentOffset {
                            lastScrollView.setContentOffset(_startingContentOffset, animated: UIView.areAnimationsEnabled)
                        } else {
                            lastScrollView.contentOffset = _startingContentOffset
                        }
                    }
                    
                    _startingContentInsets = UIEdgeInsets()
                    _startingScrollIndicatorInsets = UIEdgeInsets()
                    _startingContentOffset = CGPoint.zero
                    _lastScrollView = nil
                } else if superScrollView != lastScrollView {
                    if lastScrollView.contentInset != self._startingContentInsets {
                        showLog("Restoring contentInset to: \(_startingContentInsets)")
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            
                            lastScrollView.contentInset = self._startingContentInsets
                            lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                        })
                    }
                    
                    if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(_startingContentOffset) == false {
                        showLog("Restoring contentOffset to: \(_startingContentOffset)")
                        
                        var animatedContentOffset = false   //  (Bug ID: #1365, #1508, #1541)
                        
                        if #available(iOS 9, *) {
                            animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                        }
                        
                        if animatedContentOffset {
                            lastScrollView.setContentOffset(_startingContentOffset, animated: UIView.areAnimationsEnabled)
                        } else {
                            lastScrollView.contentOffset = _startingContentOffset
                        }
                    }
                    
                    _lastScrollView = superScrollView
                    if let scrollView = superScrollView {
                        _startingContentInsets = scrollView.contentInset
                        _startingContentOffset = scrollView.contentOffset

                        #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            _startingScrollIndicatorInsets = scrollView.verticalScrollIndicatorInsets
                        } else {
                            _startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                        }
                        #else
                        _startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                        #endif
                    }
                    
                    showLog("Saving ScrollView New contentInset: \(_startingContentInsets) and contentOffset: \(_startingContentOffset)")
                }
            } else if let unwrappedSuperScrollView = superScrollView {
                _lastScrollView = unwrappedSuperScrollView
                _startingContentInsets = unwrappedSuperScrollView.contentInset
                _startingContentOffset = unwrappedSuperScrollView.contentOffset

                #if swift(>=5.1)
                if #available(iOS 11.1, *) {
                    _startingScrollIndicatorInsets = unwrappedSuperScrollView.verticalScrollIndicatorInsets
                } else {
                    _startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
                }
                #else
                _startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
                #endif

                showLog("Saving ScrollView contentInset: \(_startingContentInsets) and contentOffset: \(_startingContentOffset)")
            }
            
            if let lastScrollView = _lastScrollView {
                //Saving
                var lastView = textFieldView
                var superScrollView = _lastScrollView
                
                while let scrollView = superScrollView {
                    
                    var shouldContinue = false
                    
                    if move > 0 {
                        shouldContinue =  move > (-scrollView.contentOffset.y - scrollView.contentInset.top)

                    } else if let tableView = scrollView.superviewOfClassType(UITableView.self) as? UITableView {

                        shouldContinue = scrollView.contentOffset.y > 0
                        
                        if shouldContinue == true, let tableCell = textFieldView.superviewOfClassType(UITableViewCell.self) as? UITableViewCell, let indexPath = tableView.indexPath(for: tableCell), let previousIndexPath = tableView.previousIndexPath(of: indexPath) {
                            
                            let previousCellRect = tableView.rectForRow(at: previousIndexPath)
                            if previousCellRect.isEmpty == false {
                                let previousCellRectInRootSuperview = tableView.convert(previousCellRect, to: rootController.view.superview)
                                
                                move = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                            }
                        }
                    } else if let collectionView = scrollView.superviewOfClassType(UICollectionView.self) as? UICollectionView {
                        
                        shouldContinue = scrollView.contentOffset.y > 0
                        
                        if shouldContinue == true, let collectionCell = textFieldView.superviewOfClassType(UICollectionViewCell.self) as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: collectionCell), let previousIndexPath = collectionView.previousIndexPath(of: indexPath), let attributes = collectionView.layoutAttributesForItem(at: previousIndexPath) {

                            let previousCellRect = attributes.frame
                            if previousCellRect.isEmpty == false {
                                let previousCellRectInRootSuperview = collectionView.convert(previousCellRect, to: rootController.view.superview)
                                
                                move = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                            }
                        }
                    } else {
                        
                        shouldContinue = textFieldViewRectInRootSuperview.origin.y < topLayoutGuide

                        if shouldContinue {
                            move = min(0, textFieldViewRectInRootSuperview.origin.y - topLayoutGuide)
                        }
                    }
                    
                    if shouldContinue {
                        
                        var tempScrollView = scrollView.superviewOfClassType(UIScrollView.self) as? UIScrollView
                        var nextScrollView: UIScrollView?
                        while let view = tempScrollView {
                            
                            if view.isScrollEnabled && view.shouldIgnoreScrollingAdjustment == false {
                                nextScrollView = view
                                break
                            } else {
                                tempScrollView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
                            }
                        }
                        
                        //Getting lastViewRect.
                        if let lastViewRect = lastView.superview?.convert(lastView.frame, to: scrollView) {
                            
                            //Calculating the expected Y offset from move and scrollView's contentOffset.
                            var shouldOffsetY = scrollView.contentOffset.y - min(scrollView.contentOffset.y, -move)
                            
                            shouldOffsetY = min(shouldOffsetY, lastViewRect.origin.y)
                            
                            if textFieldView is UITextView == true &&
                                nextScrollView == nil &&
                                shouldOffsetY >= 0 {
                                
                                //  Converting Rectangle according to window bounds.
                                if let currentTextFieldViewRect = textFieldView.superview?.convert(textFieldView.frame, to: window) {
                                    
                                    let expectedFixDistance = currentTextFieldViewRect.minY - topLayoutGuide
                                    
                                    shouldOffsetY = min(shouldOffsetY, scrollView.contentOffset.y + expectedFixDistance)
                                    
                                    move = 0
                                } else {
                                    move -= (shouldOffsetY-scrollView.contentOffset.y)
                                }
                            } else {
                                move -= (shouldOffsetY-scrollView.contentOffset.y)
                            }
                            
                            let newContentOffset = CGPoint(x: scrollView.contentOffset.x, y: shouldOffsetY)
                            
                            if scrollView.contentOffset.equalTo(newContentOffset) == false {

                                showLog("old contentOffset: \(scrollView.contentOffset) new contentOffset: \(newContentOffset)")
                                self.showLog("Remaining Move: \(move)")

                                UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                                    
                                    var animatedContentOffset = false   //  (Bug ID: #1365, #1508, #1541)
                                    
                                    if #available(iOS 9, *) {
                                        animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: scrollView) != nil
                                    }

                                    if animatedContentOffset {
                                        scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                                    } else {
                                        scrollView.contentOffset = newContentOffset
                                    }
                                }) { _ in
                                    
                                    if scrollView is UITableView || scrollView is UICollectionView {
                                        //This will update the next/previous states
                                        self.addToolbarIfRequired()
                                    }
                                }
                            }
                        }
                        
                        lastView = scrollView
                        superScrollView = nextScrollView
                    } else {
                        move = 0
                        break
                    }
                }
                
                if let lastScrollViewRect = lastScrollView.superview?.convert(lastScrollView.frame, to: window) {
                    
                    let bottom: CGFloat = (kbSize.height-newKeyboardDistanceFromTextField)-(window.frame.height-lastScrollViewRect.maxY)
                    
                    var movedInsets = lastScrollView.contentInset
                    
                    movedInsets.bottom = max(_startingContentInsets.bottom, bottom)
                    
                    if lastScrollView.contentInset != movedInsets {
                        showLog("old ContentInset: \(lastScrollView.contentInset) new ContentInset: \(movedInsets)")

                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            lastScrollView.contentInset = movedInsets
                            
                            var newInset : UIEdgeInsets
                            
                            #if swift(>=5.1)
                            if #available(iOS 11.1, *) {
                                newInset = lastScrollView.verticalScrollIndicatorInsets
                            } else {
                                newInset = lastScrollView.scrollIndicatorInsets
                            }
                            #else
                            newInset = lastScrollView.scrollIndicatorInsets
                            #endif

                            newInset.bottom = movedInsets.bottom
                            lastScrollView.scrollIndicatorInsets = newInset
                        })
                    }
                }
            }
            if let textView = textFieldView as? UITextView {
                
                let keyboardYPosition = window.frame.height - (kbSize.height-newKeyboardDistanceFromTextField)
                var rootSuperViewFrameInWindow = window.frame
                if let rootSuperview = rootController.view.superview {
                    rootSuperViewFrameInWindow = rootSuperview.convert(rootSuperview.bounds, to: window)
                }
                
                let keyboardOverlapping = rootSuperViewFrameInWindow.maxY - keyboardYPosition
                
                let textViewHeight = min(textView.frame.height, rootSuperViewFrameInWindow.height-topLayoutGuide-keyboardOverlapping)
                
                if textView.frame.size.height-textView.contentInset.bottom>textViewHeight {
                    if self.isTextViewContentInsetChanged == false {
                        self.startingTextViewContentInsets = textView.contentInset
                        
                        #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            self.startingTextViewScrollIndicatorInsets = textView.verticalScrollIndicatorInsets
                        } else {
                            self.startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                        }
                        #else
                        self.startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                        #endif
                    }

                    self.isTextViewContentInsetChanged = true

                    var newContentInset = textView.contentInset
                    newContentInset.bottom = textView.frame.size.height-textViewHeight

                    if textView.contentInset != newContentInset {
                        self.showLog("\(textFieldView) Old UITextView.contentInset: \(textView.contentInset) New UITextView.contentInset: \(newContentInset)")

                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            
                            textView.contentInset = newContentInset
                            textView.scrollIndicatorInsets = newContentInset
                        }, completion: { (_) -> Void in })
                    }
                }
            }
            
            if move >= 0 {
                
                rootViewOrigin.y = max(rootViewOrigin.y - move, min(0, -(kbSize.height-newKeyboardDistanceFromTextField)))

                if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                    showLog("Moving Upward")
                    
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        
                        var rect = rootController.view.frame
                        rect.origin = rootViewOrigin
                        rootController.view.frame = rect
                        
                        if self.layoutIfNeededOnUpdate == true {
                            //Animating content (Bug ID: #160)
                            rootController.view.setNeedsLayout()
                            rootController.view.layoutIfNeeded()
                        }
                        
                        self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                    })
                }
                
                _privateMovedDistance = (_topViewBeginOrigin.y-rootViewOrigin.y)
            } else {
                let disturbDistance: CGFloat = rootViewOrigin.y-_topViewBeginOrigin.y
                
                if disturbDistance <= 0 {
                    
                    rootViewOrigin.y -= max(move, disturbDistance)
                    
                    if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                        showLog("Moving Downward")
                        
                        UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                            
                            var rect = rootController.view.frame
                            rect.origin = rootViewOrigin
                            rootController.view.frame = rect
                            
                            if self.layoutIfNeededOnUpdate == true {
                                //Animating content (Bug ID: #160)
                                rootController.view.setNeedsLayout()
                                rootController.view.layoutIfNeeded()
                            }
                            self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                        })
                    }
                    _privateMovedDistance = (_topViewBeginOrigin.y-rootViewOrigin.y)
                }
            }
            let elapsedTime = CACurrentMediaTime() - startTime
            showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
        }
    }

    private func restorePosition() {
        
        _privateHasPendingAdjustRequest = false
        
        if _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false {
            
            if let rootViewController = _rootViewController {
                
                if rootViewController.view.frame.origin.equalTo(self._topViewBeginOrigin) == false {
                    //Used UIViewAnimationOptionBeginFromCurrentState to minimize strange animations.
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        
                        self.showLog("Restoring \(rootViewController) origin to: \(self._topViewBeginOrigin)")
                        
                        var rect = rootViewController.view.frame
                        rect.origin = self._topViewBeginOrigin
                        rootViewController.view.frame = rect
                        
                        if self.layoutIfNeededOnUpdate == true {
                            rootViewController.view.setNeedsLayout()
                            rootViewController.view.layoutIfNeeded()
                        }
                    })
                }
                
                self._privateMovedDistance = 0
                
                if rootViewController.navigationController?.interactivePopGestureRecognizer?.state == .began {
                    self._rootViewControllerWhilePopGestureRecognizerActive = rootViewController
                    self._topViewBeginOriginWhilePopGestureRecognizerActive = self._topViewBeginOrigin
                }
                
                _rootViewController = nil
            }
        }
    }

    @objc public func reloadLayoutIfNeeded() {

        if privateIsEnabled() == true {
            if _privateIsKeyboardShowing == true,
                _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                optimizedAdjustPosition()
            }
        }
    }
    @objc internal func keyboardWillShow(_ notification: Notification?) {
        
        _kbShowNotification = notification

        //  Boolean to know keyboard is showing/hiding
        _privateIsKeyboardShowing = true
        
        let oldKBFrame = _kbFrame

        if let info = notification?.userInfo {
            
            #if swift(>=4.2)
            let curveUserInfoKey    = UIResponder.keyboardAnimationCurveUserInfoKey
            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            #else
            let curveUserInfoKey    = UIKeyboardAnimationCurveUserInfoKey
            let durationUserInfoKey = UIKeyboardAnimationDurationUserInfoKey
            let frameEndUserInfoKey = UIKeyboardFrameEndUserInfoKey
            #endif

            if let curve = info[curveUserInfoKey] as? UInt {
                _animationCurve = .init(rawValue: curve)
            } else {
                _animationCurve = .curveEaseOut
            }
            
            if let duration = info[durationUserInfoKey] as? TimeInterval {
                
                if duration != 0.0 {
                    _animationDuration = duration
                }
            } else {
                _animationDuration = 0.25
            }
            
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                _kbFrame = kbFrame
                showLog("UIKeyboard Frame: \(_kbFrame)")
            }
        }

        if privateIsEnabled() == false {
            return
        }
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        if let textFieldView = _textFieldView, _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == true {
            
            _rootViewController = textFieldView.parentContainerViewController()
            if let controller = _rootViewController {
                
                if _rootViewControllerWhilePopGestureRecognizerActive == controller {
                    _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive
                } else {
                    _topViewBeginOrigin = controller.view.frame.origin
                }

                _rootViewControllerWhilePopGestureRecognizerActive = nil
                _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid
                
                self.showLog("Saving \(controller) beginning origin: \(self._topViewBeginOrigin)")
            }
        }
        if _kbFrame.equalTo(oldKBFrame) == false {
            
            if _privateIsKeyboardShowing == true,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                
                optimizedAdjustPosition()
            }
        }
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    
    @objc internal func keyboardDidShow(_ notification: Notification?) {
        
        if privateIsEnabled() == false {
            return
        }
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        
        if let textFieldView = _textFieldView,
            let parentController = textFieldView.parentContainerViewController(), (parentController.modalPresentationStyle == UIModalPresentationStyle.formSheet || parentController.modalPresentationStyle == UIModalPresentationStyle.pageSheet),
            textFieldView.isAlertViewTextField() == false {
            
            self.optimizedAdjustPosition()
        }
        
        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }

    @objc internal func keyboardWillHide(_ notification: Notification?) {
        
        if notification != nil {
            _kbShowNotification = nil
        }
    
        _privateIsKeyboardShowing = false
        
        if let info = notification?.userInfo {
            
            #if swift(>=4.2)
            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
            #else
            let durationUserInfoKey = UIKeyboardAnimationDurationUserInfoKey
            #endif

            //  Getting keyboard animation duration
            if let duration =  info[durationUserInfoKey] as? TimeInterval {
                if duration != 0 {
                    _animationDuration = duration
                }
            }
        }
        
        if privateIsEnabled() == false {
            return
        }
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        if let lastScrollView = _lastScrollView {
            
            UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                
                if lastScrollView.contentInset != self._startingContentInsets {
                    self.showLog("Restoring contentInset to: \(self._startingContentInsets)")
                    lastScrollView.contentInset = self._startingContentInsets
                    lastScrollView.scrollIndicatorInsets = self._startingScrollIndicatorInsets
                }
                
                if lastScrollView.shouldRestoreScrollViewContentOffset == true && lastScrollView.contentOffset.equalTo(self._startingContentOffset) == false {
                    self.showLog("Restoring contentOffset to: \(self._startingContentOffset)")
                    
                    var animatedContentOffset = false   //  (Bug ID: #1365, #1508, #1541)
                    
                    if #available(iOS 9, *) {
                        animatedContentOffset = self._textFieldView?.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil
                    }
                    
                    if animatedContentOffset {
                        lastScrollView.setContentOffset(self._startingContentOffset, animated: UIView.areAnimationsEnabled)
                    } else {
                        lastScrollView.contentOffset = self._startingContentOffset
                    }
                }
                
                var superScrollView: UIScrollView? = lastScrollView
                
                while let scrollView = superScrollView {
                    
                    let contentSize = CGSize(width: max(scrollView.contentSize.width, scrollView.frame.width), height: max(scrollView.contentSize.height, scrollView.frame.height))
                    
                    let minimumY = contentSize.height - scrollView.frame.height
                    
                    if minimumY < scrollView.contentOffset.y {
                        
                        let newContentOffset = CGPoint(x: scrollView.contentOffset.x, y: minimumY)
                        if scrollView.contentOffset.equalTo(newContentOffset) == false {
                            
                            var animatedContentOffset = false   //  (Bug ID: #1365, #1508, #1541)
                            
                            if #available(iOS 9, *) {
                                animatedContentOffset = self._textFieldView?.superviewOfClassType(UIStackView.self, belowView: scrollView) != nil
                            }
                            
                            if animatedContentOffset {
                                scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                            } else {
                                scrollView.contentOffset = newContentOffset
                            }
                            
                            self.showLog("Restoring contentOffset to: \(self._startingContentOffset)")
                        }
                    }
                    
                    superScrollView = scrollView.superviewOfClassType(UIScrollView.self) as? UIScrollView
                }
            })
        }
        
        restorePosition()
        
        _lastScrollView = nil
        _kbFrame = CGRect.zero
        _startingContentInsets = UIEdgeInsets()
        _startingScrollIndicatorInsets = UIEdgeInsets()
        _startingContentOffset = CGPoint.zero

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }

    @objc internal func keyboardDidHide(_ notification: Notification) {

        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        
        _topViewBeginOrigin = IQKeyboardManager.kIQCGPointInvalid
        
        _kbFrame = CGRect.zero

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    
    @objc internal func textFieldViewDidBeginEditing(_ notification: Notification) {

        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        _textFieldView = notification.object as? UIView
        
        if overrideKeyboardAppearance == true {
            
            if let textFieldView = _textFieldView as? UITextField {
                if textFieldView.keyboardAppearance != keyboardAppearance {
                    textFieldView.keyboardAppearance = keyboardAppearance
                    textFieldView.reloadInputViews()
                }
            } else if  let textFieldView = _textFieldView as? UITextView {
                if textFieldView.keyboardAppearance != keyboardAppearance {
                    textFieldView.keyboardAppearance = keyboardAppearance
                    textFieldView.reloadInputViews()
                }
            }
        }

        if privateIsEnableAutoToolbar() == true {

            if let textView = _textFieldView as? UITextView,
                textView.inputAccessoryView == nil {
                
                UIView.animate(withDuration: 0.00001, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in

                    self.addToolbarIfRequired()
                    
                    }, completion: { (_) -> Void in
                        textView.reloadInputViews()
                })
            } else {
                addToolbarIfRequired()
            }
        } else {
            removeToolbarIfRequired()
        }

        resignFirstResponderGesture.isEnabled = privateShouldResignOnTouchOutside()
        _textFieldView?.window?.addGestureRecognizer(resignFirstResponderGesture)

        if privateIsEnabled() == true {
            if _topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == true {
                
                _rootViewController = _textFieldView?.parentContainerViewController()

                if let controller = _rootViewController {
                    
                    if _rootViewControllerWhilePopGestureRecognizerActive == controller {
                        _topViewBeginOrigin = _topViewBeginOriginWhilePopGestureRecognizerActive
                    } else {
                        _topViewBeginOrigin = controller.view.frame.origin
                    }
                    
                    _rootViewControllerWhilePopGestureRecognizerActive = nil
                    _topViewBeginOriginWhilePopGestureRecognizerActive = IQKeyboardManager.kIQCGPointInvalid

                    self.showLog("Saving \(controller) beginning origin: \(self._topViewBeginOrigin)")
                }
            }
            
            if _privateIsKeyboardShowing == true,
                let textFieldView = _textFieldView,
                textFieldView.isAlertViewTextField() == false {
                optimizedAdjustPosition()
            }
        }

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    
    @objc internal func textFieldViewDidEndEditing(_ notification: Notification) {
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        _textFieldView?.window?.removeGestureRecognizer(resignFirstResponderGesture)
        
        if let textView = _textFieldView as? UITextView {

            if isTextViewContentInsetChanged == true {
                self.isTextViewContentInsetChanged = false

                if textView.contentInset != self.startingTextViewContentInsets {
                    self.showLog("Restoring textView.contentInset to: \(self.startingTextViewContentInsets)")
                    
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        
                        textView.contentInset = self.startingTextViewContentInsets
                        textView.scrollIndicatorInsets = self.startingTextViewScrollIndicatorInsets
                        
                    }, completion: { (_) -> Void in })
                }
            }
        }
        _textFieldView = nil

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }

    @objc internal func willChangeStatusBarOrientation(_ notification: Notification) {

        let currentStatusBarOrientation : UIInterfaceOrientation
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            currentStatusBarOrientation = keyWindow()?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.unknown
        } else {
            currentStatusBarOrientation = UIApplication.shared.statusBarOrientation
        }
        #else
        currentStatusBarOrientation = UIApplication.shared.statusBarOrientation
        #endif

        #if swift(>=4.2)
        let statusBarUserInfoKey    = UIApplication.statusBarOrientationUserInfoKey
        #else
        let statusBarUserInfoKey    = UIApplicationStatusBarOrientationUserInfoKey
        #endif

        guard let statusBarOrientation = notification.userInfo?[statusBarUserInfoKey] as? Int, currentStatusBarOrientation.rawValue != statusBarOrientation else {
            return
        }
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)
        
        //If textViewContentInsetChanged is saved then restore it.
        if let textView = _textFieldView as? UITextView {
            
            if isTextViewContentInsetChanged == true {

                self.isTextViewContentInsetChanged = false

                if textView.contentInset != self.startingTextViewContentInsets {
                    UIView.animate(withDuration: _animationDuration, delay: 0, options: _animationCurve.union(.beginFromCurrentState), animations: { () -> Void in
                        
                        self.showLog("Restoring textView.contentInset to: \(self.startingTextViewContentInsets)")
                        
                        textView.contentInset = self.startingTextViewContentInsets
                        textView.scrollIndicatorInsets = self.startingTextViewScrollIndicatorInsets
                        
                    }, completion: { (_) -> Void in })
                }
            }
        }
        restorePosition()

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    private func responderViews() -> [UIView]? {
        
        var superConsideredView: UIView?

        for disabledClass in toolbarPreviousNextAllowedClasses {
            
            superConsideredView = _textFieldView?.superviewOfClassType(disabledClass)
            
            if superConsideredView != nil {
                break
            }
        }
    
        if let view = superConsideredView {
            return view.deepResponderViews()
        } else {
            
            if let textFields = _textFieldView?.responderSiblings() {
                
                switch toolbarManageBehaviour {
                case IQAutoToolbarManageBehaviour.bySubviews:   return textFields
                case IQAutoToolbarManageBehaviour.byTag:    return textFields.sortedArrayByTag()
                case IQAutoToolbarManageBehaviour.byPosition:    return textFields.sortedArrayByPosition()
                }
            } else {
                return nil
            }
        }
    }
    private func addToolbarIfRequired() {
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        if let siblings = responderViews(), !siblings.isEmpty {
            
            showLog("Found \(siblings.count) responder sibling(s)")
            
            if let textField = _textFieldView {
                if textField.responds(to: #selector(setter: UITextField.inputAccessoryView)) {
                    
                    if textField.inputAccessoryView == nil ||
                        textField.inputAccessoryView?.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag ||
                        textField.inputAccessoryView?.tag == IQKeyboardManager.kIQDoneButtonToolbarTag {
                        
                        let rightConfiguration: IQBarButtonItemConfiguration
                        
                        if let doneBarButtonItemImage = toolbarDoneBarButtonItemImage {
                            rightConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.doneAction(_:)))
                        } else if let doneBarButtonItemText = toolbarDoneBarButtonItemText {
                            rightConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.doneAction(_:)))
                        } else {
                            rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: #selector(self.doneAction(_:)))
                        }
                        
                        if (siblings.count == 1 && previousNextDisplayMode == .default) || previousNextDisplayMode == .alwaysHide {
                            
                            textField.addKeyboardToolbarWithTarget(target: self, titleText: (shouldShowToolbarPlaceholder ? textField.drawingToolbarPlaceholder: nil), rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: nil, nextBarButtonConfiguration: nil)

                            textField.inputAccessoryView?.tag = IQKeyboardManager.kIQDoneButtonToolbarTag //  (Bug ID: #78)
                            
                        } else if (siblings.count > 1 && previousNextDisplayMode == .default) || previousNextDisplayMode == .alwaysShow {
                            
                            let prevConfiguration: IQBarButtonItemConfiguration
                            
                            if let doneBarButtonItemImage = toolbarPreviousBarButtonItemImage {
                                prevConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.previousAction(_:)))
                            } else if let doneBarButtonItemText = toolbarPreviousBarButtonItemText {
                                prevConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.previousAction(_:)))
                            } else {
                                prevConfiguration = IQBarButtonItemConfiguration(image: (UIImage.keyboardPreviousImage() ?? UIImage()), action: #selector(self.previousAction(_:)))
                            }

                            let nextConfiguration: IQBarButtonItemConfiguration
                            
                            if let doneBarButtonItemImage = toolbarNextBarButtonItemImage {
                                nextConfiguration = IQBarButtonItemConfiguration(image: doneBarButtonItemImage, action: #selector(self.nextAction(_:)))
                            } else if let doneBarButtonItemText = toolbarNextBarButtonItemText {
                                nextConfiguration = IQBarButtonItemConfiguration(title: doneBarButtonItemText, action: #selector(self.nextAction(_:)))
                            } else {
                                nextConfiguration = IQBarButtonItemConfiguration(image: (UIImage.keyboardNextImage() ?? UIImage()), action: #selector(self.nextAction(_:)))
                            }

                            textField.addKeyboardToolbarWithTarget(target: self, titleText: (shouldShowToolbarPlaceholder ? textField.drawingToolbarPlaceholder: nil), rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)

                            textField.inputAccessoryView?.tag = IQKeyboardManager.kIQPreviousNextButtonToolbarTag //  (Bug ID: #78)
                        }

                        let toolbar = textField.keyboardToolbar

                        if let textField = textField as? UITextField {
                            
                            switch textField.keyboardAppearance {
                                
                            case .dark:
                                toolbar.barStyle = UIBarStyle.black
                                toolbar.tintColor = UIColor.white
                                toolbar.barTintColor = nil
                            default:
                                toolbar.barStyle = UIBarStyle.default
                                toolbar.barTintColor = toolbarBarTintColor
                                
                                if shouldToolbarUsesTextFieldTintColor {
                                    toolbar.tintColor = textField.tintColor
                                } else if let tintColor = toolbarTintColor {
                                    toolbar.tintColor = tintColor
                                } else {
                                    toolbar.tintColor = UIColor.black
                                }
                            }
                        } else if let textView = textField as? UITextView {
                            
                            switch textView.keyboardAppearance {
                                
                            case .dark:
                                toolbar.barStyle = UIBarStyle.black
                                toolbar.tintColor = UIColor.white
                                toolbar.barTintColor = nil
                            default:
                                toolbar.barStyle = UIBarStyle.default
                                toolbar.barTintColor = toolbarBarTintColor

                                if shouldToolbarUsesTextFieldTintColor {
                                    toolbar.tintColor = textView.tintColor
                                } else if let tintColor = toolbarTintColor {
                                    toolbar.tintColor = tintColor
                                } else {
                                    toolbar.tintColor = UIColor.black
                                }
                            }
                        }

                        if shouldShowToolbarPlaceholder == true &&
                            textField.shouldHideToolbarPlaceholder == false {
                            
                            if toolbar.titleBarButton.title == nil ||
                                toolbar.titleBarButton.title != textField.drawingToolbarPlaceholder {
                                toolbar.titleBarButton.title = textField.drawingToolbarPlaceholder
                            }
                            
                            if let font = placeholderFont {
                                toolbar.titleBarButton.titleFont = font
                            }

                            if let color = placeholderColor {
                                toolbar.titleBarButton.titleColor = color
                            }
                            
                            if let color = placeholderButtonColor {
                                toolbar.titleBarButton.selectableTitleColor = color
                            }

                        } else {
                            
                            toolbar.titleBarButton.title = nil
                        }
                        
                        if siblings.first == textField {
                            if siblings.count == 1 {
                                textField.keyboardToolbar.previousBarButton.isEnabled = false
                                textField.keyboardToolbar.nextBarButton.isEnabled = false
                            } else {
                                textField.keyboardToolbar.previousBarButton.isEnabled = false
                                textField.keyboardToolbar.nextBarButton.isEnabled = true
                            }
                        } else if siblings.last  == textField {   //	If lastTextField then next should not be enaled.
                            textField.keyboardToolbar.previousBarButton.isEnabled = true
                            textField.keyboardToolbar.nextBarButton.isEnabled = false
                        } else {
                            textField.keyboardToolbar.previousBarButton.isEnabled = true
                            textField.keyboardToolbar.nextBarButton.isEnabled = true
                        }
                    }
                }
            }
        }

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    
    private func removeToolbarIfRequired() {
        
        let startTime = CACurrentMediaTime()
        showLog("****** \(#function) started ******", indentation: 1)

        if let siblings = responderViews() {
            
            showLog("Found \(siblings.count) responder sibling(s)")

            for view in siblings {
                
                if let toolbar = view.inputAccessoryView as? IQToolbar {

                    if view.responds(to: #selector(setter: UITextField.inputAccessoryView)) &&
                        (toolbar.tag == IQKeyboardManager.kIQDoneButtonToolbarTag || toolbar.tag == IQKeyboardManager.kIQPreviousNextButtonToolbarTag) {
                        
                        if let textField = view as? UITextField {
                            textField.inputAccessoryView = nil
                            textField.reloadInputViews()
                        } else if let textView = view as? UITextView {
                            textView.inputAccessoryView = nil
                            textView.reloadInputViews()
                        }
                    }
                }
            }
        }

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("****** \(#function) ended: \(elapsedTime) seconds ******", indentation: -1)
    }
    
    @objc public func reloadInputViews() {
        
        if privateIsEnableAutoToolbar() == true {
            self.addToolbarIfRequired()
        } else {
            self.removeToolbarIfRequired()
        }
    }
    @objc public var enableDebugging = false

    @objc public func registerAllNotifications() {

        #if swift(>=4.2)
        let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
        let UIKeyboardDidShow   = UIResponder.keyboardDidShowNotification
        let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
        let UIKeyboardDidHide   = UIResponder.keyboardDidHideNotification
        
        let UITextFieldTextDidBeginEditing  = UITextField.textDidBeginEditingNotification
        let UITextFieldTextDidEndEditing    = UITextField.textDidEndEditingNotification
        
        let UITextViewTextDidBeginEditing   = UITextView.textDidBeginEditingNotification
        let UITextViewTextDidEndEditing     = UITextView.textDidEndEditingNotification
        
        let UIApplicationWillChangeStatusBarOrientation = UIApplication.willChangeStatusBarOrientationNotification
        #else
        let UIKeyboardWillShow  = Notification.Name.UIKeyboardWillShow
        let UIKeyboardDidShow   = Notification.Name.UIKeyboardDidShow
        let UIKeyboardWillHide  = Notification.Name.UIKeyboardWillHide
        let UIKeyboardDidHide   = Notification.Name.UIKeyboardDidHide
        
        let UITextFieldTextDidBeginEditing  = Notification.Name.UITextFieldTextDidBeginEditing
        let UITextFieldTextDidEndEditing    = Notification.Name.UITextFieldTextDidEndEditing
        
        let UITextViewTextDidBeginEditing   = Notification.Name.UITextViewTextDidBeginEditing
        let UITextViewTextDidEndEditing     = Notification.Name.UITextViewTextDidEndEditing
        
        let UIApplicationWillChangeStatusBarOrientation = Notification.Name.UIApplicationWillChangeStatusBarOrientation
        #endif

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIKeyboardDidHide, object: nil)
        
        registerTextFieldViewClass(UITextField.self, didBeginEditingNotificationName: UITextFieldTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextFieldTextDidEndEditing.rawValue)
        
        registerTextFieldViewClass(UITextView.self, didBeginEditingNotificationName: UITextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextViewTextDidEndEditing.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willChangeStatusBarOrientation(_:)), name: UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
    }

    @objc public func unregisterAllNotifications() {
        
        #if swift(>=4.2)
        let UIKeyboardWillShow  = UIResponder.keyboardWillShowNotification
        let UIKeyboardDidShow   = UIResponder.keyboardDidShowNotification
        let UIKeyboardWillHide  = UIResponder.keyboardWillHideNotification
        let UIKeyboardDidHide   = UIResponder.keyboardDidHideNotification
        
        let UITextFieldTextDidBeginEditing  = UITextField.textDidBeginEditingNotification
        let UITextFieldTextDidEndEditing    = UITextField.textDidEndEditingNotification
        
        let UITextViewTextDidBeginEditing   = UITextView.textDidBeginEditingNotification
        let UITextViewTextDidEndEditing     = UITextView.textDidEndEditingNotification
        
        let UIApplicationWillChangeStatusBarOrientation = UIApplication.willChangeStatusBarOrientationNotification
        #else
        let UIKeyboardWillShow  = Notification.Name.UIKeyboardWillShow
        let UIKeyboardDidShow   = Notification.Name.UIKeyboardDidShow
        let UIKeyboardWillHide  = Notification.Name.UIKeyboardWillHide
        let UIKeyboardDidHide   = Notification.Name.UIKeyboardDidHide
        
        let UITextFieldTextDidBeginEditing  = Notification.Name.UITextFieldTextDidBeginEditing
        let UITextFieldTextDidEndEditing    = Notification.Name.UITextFieldTextDidEndEditing
        
        let UITextViewTextDidBeginEditing   = Notification.Name.UITextViewTextDidBeginEditing
        let UITextViewTextDidEndEditing     = Notification.Name.UITextViewTextDidEndEditing
        
        let UIApplicationWillChangeStatusBarOrientation = Notification.Name.UIApplicationWillChangeStatusBarOrientation
        #endif

        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIKeyboardDidHide, object: nil)

        unregisterTextFieldViewClass(UITextField.self, didBeginEditingNotificationName: UITextFieldTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextFieldTextDidEndEditing.rawValue)
        
        unregisterTextFieldViewClass(UITextView.self, didBeginEditingNotificationName: UITextViewTextDidBeginEditing.rawValue, didEndEditingNotificationName: UITextViewTextDidEndEditing.rawValue)
        
        NotificationCenter.default.removeObserver(self, name: UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
    }

    private func showLog(_ logString: String, indentation: Int = 0) {
        
        struct Static {
            static var indentation = 0
        }

        if indentation < 0 {
            Static.indentation = max(0, Static.indentation + indentation)
        }

        if enableDebugging {

            var preLog = "IQKeyboardManager"

            for _ in 0 ... Static.indentation {
                preLog += "|\t"
            }
            print(preLog + logString)
        }

        if indentation > 0 {
            Static.indentation += indentation
        }
    }
}

private class IQTextFieldViewInfoModal: NSObject {
    
    fileprivate weak var textFieldDelegate: UITextFieldDelegate?
    fileprivate weak var textViewDelegate: UITextViewDelegate?
    fileprivate weak var textFieldView: UIView?
    fileprivate var originalReturnKeyType = UIReturnKeyType.default
    
    init(textFieldView: UIView?, textFieldDelegate: UITextFieldDelegate?, textViewDelegate: UITextViewDelegate?, originalReturnKeyType: UIReturnKeyType = .default) {
        self.textFieldView = textFieldView
        self.textFieldDelegate = textFieldDelegate
        self.textViewDelegate = textViewDelegate
        self.originalReturnKeyType = originalReturnKeyType
    }
}

public class IQKeyboardReturnKeyHandler: NSObject, UITextFieldDelegate, UITextViewDelegate {
    
    @objc public weak var delegate: (UITextFieldDelegate & UITextViewDelegate)?
    
    @objc public var lastTextFieldReturnKeyType: UIReturnKeyType = UIReturnKeyType.default {
        
        didSet {
            
            for modal in textFieldInfoCache {
                
                if let view = modal.textFieldView {
                    updateReturnKeyTypeOnTextField(view)
                }
            }
        }
    }
    
    @objc public override init() {
        super.init()
    }
    
    @objc public init(controller: UIViewController) {
        super.init()
        
        addResponderFromView(controller.view)
    }
    
    deinit {
        
        for modal in textFieldInfoCache {
            
            if let textField = modal.textFieldView as? UITextField {
                textField.returnKeyType = modal.originalReturnKeyType
                
                textField.delegate = modal.textFieldDelegate
                
            } else if let textView = modal.textFieldView as? UITextView {
                
                textView.returnKeyType = modal.originalReturnKeyType
                
                textView.delegate = modal.textViewDelegate
            }
        }
        
        textFieldInfoCache.removeAll()
    }
    
    private var textFieldInfoCache          =   [IQTextFieldViewInfoModal]()
    
    private func textFieldViewCachedInfo(_ textField: UIView) -> IQTextFieldViewInfoModal? {
        
        for modal in textFieldInfoCache {
            
            if let view = modal.textFieldView {
                
                if view == textField {
                    return modal
                }
            }
        }
        
        return nil
    }
    
    private func updateReturnKeyTypeOnTextField(_ view: UIView) {
        var superConsideredView: UIView?
        
        for disabledClass in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {
            
            superConsideredView = view.superviewOfClassType(disabledClass)
            
            if superConsideredView != nil {
                break
            }
        }
        
        var textFields = [UIView]()
        
        if let unwrappedTableView = superConsideredView {     //   (Enhancement ID: #22)
            textFields = unwrappedTableView.deepResponderViews()
        } else {
            textFields = view.responderSiblings()
            
            switch IQKeyboardManager.shared.toolbarManageBehaviour {
            case .byTag:        textFields = textFields.sortedArrayByTag()
            case .byPosition:   textFields = textFields.sortedArrayByPosition()
            default:    break
            }
        }
        
        if let lastView = textFields.last {
            
            if let textField = view as? UITextField {
                
                textField.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            } else if let textView = view as? UITextView {
                
                textView.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            }
        }
    }
    
    @objc public func addTextFieldView(_ view: UIView) {
        
        let modal = IQTextFieldViewInfoModal(textFieldView: view, textFieldDelegate: nil, textViewDelegate: nil)
        
        if let textField = view as? UITextField {
            
            modal.originalReturnKeyType = textField.returnKeyType
            modal.textFieldDelegate = textField.delegate
            textField.delegate = self
            
        } else if let textView = view as? UITextView {
            
            modal.originalReturnKeyType = textView.returnKeyType
            modal.textViewDelegate = textView.delegate
            textView.delegate = self
        }
        
        textFieldInfoCache.append(modal)
    }
    
    @objc public func removeTextFieldView(_ view: UIView) {
        
        if let modal = textFieldViewCachedInfo(view) {
            
            if let textField = view as? UITextField {
                
                textField.returnKeyType = modal.originalReturnKeyType
                textField.delegate = modal.textFieldDelegate
            } else if let textView = view as? UITextView {
                
                textView.returnKeyType = modal.originalReturnKeyType
                textView.delegate = modal.textViewDelegate
            }
            
            if let index = textFieldInfoCache.firstIndex(where: { $0.textFieldView == view}) {
                
                textFieldInfoCache.remove(at: index)
            }
        }
    }
    
    @objc public func addResponderFromView(_ view: UIView) {
        
        let textFields = view.deepResponderViews()
        
        for textField in textFields {
            
            addTextFieldView(textField)
        }
    }
    
    @objc public func removeResponderFromView(_ view: UIView) {
        
        let textFields = view.deepResponderViews()
        
        for textField in textFields {
            
            removeTextFieldView(textField)
        }
    }
    
    @discardableResult private func goToNextResponderOrResign(_ view: UIView) -> Bool {
        
        var superConsideredView: UIView?
        
        for disabledClass in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {
            
            superConsideredView = view.superviewOfClassType(disabledClass)
            
            if superConsideredView != nil {
                break
            }
        }
        
        var textFields = [UIView]()
        
        if let unwrappedTableView = superConsideredView {     //   (Enhancement ID: #22)
            textFields = unwrappedTableView.deepResponderViews()
        } else {  //Otherwise fetching all the siblings
            
            textFields = view.responderSiblings()
            
            switch IQKeyboardManager.shared.toolbarManageBehaviour {
            case .byTag:        textFields = textFields.sortedArrayByTag()
            case .byPosition:   textFields = textFields.sortedArrayByPosition()
            default:
                break
            }
        }
        
        if let index = textFields.firstIndex(of: view) {
            if index < (textFields.count - 1) {
                
                let nextTextField = textFields[index+1]
                nextTextField.becomeFirstResponder()
                return false
            } else {
                
                view.resignFirstResponder()
                return true
            }
        } else {
            return true
        }
    }
    
    @objc public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) {
                    return unwrapDelegate.textFieldShouldBeginEditing?(textField) == true
                }
            }
        }
        
        return true
    }
    
    @objc public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) {
                    return unwrapDelegate.textFieldShouldEndEditing?(textField) == true
                }
            }
        }
        
        return true
    }
    
    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateReturnKeyTypeOnTextField(textField)
        
        var aDelegate: UITextFieldDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        
        aDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    @objc public func textFieldDidEndEditing(_ textField: UITextField) {
        
        var aDelegate: UITextFieldDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        
        aDelegate?.textFieldDidEndEditing?(textField)
    }
    
    #if swift(>=4.2)
    @available(iOS 10.0, *)
    @objc public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        var aDelegate: UITextFieldDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        
        aDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    #else
    @available(iOS 10.0, *)
    @objc public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        var aDelegate: UITextFieldDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        
        aDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    #endif
    
    @objc public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) {
                    return unwrapDelegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == true
                }
            }
        }
        return true
    }
    
    @objc public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) {
                    return unwrapDelegate.textFieldShouldClear?(textField) == true
                }
            }
        }
        
        return true
    }
    
    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var shouldReturn = true
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) {
                    shouldReturn = unwrapDelegate.textFieldShouldReturn?(textField) == true
                }
            }
        }
        
        if shouldReturn == true {
            goToNextResponderOrResign(textField)
            return true
        } else {
            return goToNextResponderOrResign(textField)
        }
    }
    
    @objc public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textViewShouldBeginEditing(_:))) {
                    return unwrapDelegate.textViewShouldBeginEditing?(textView) == true
                }
            }
        }
        
        return true
    }
    
    @objc public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textViewShouldEndEditing(_:))) {
                    return unwrapDelegate.textViewShouldEndEditing?(textView) == true
                }
            }
        }
        
        return true
    }
    
    @objc public func textViewDidBeginEditing(_ textView: UITextView) {
        updateReturnKeyTypeOnTextField(textView)
        
        var aDelegate: UITextViewDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        
        aDelegate?.textViewDidBeginEditing?(textView)
    }
    
    @objc public func textViewDidEndEditing(_ textView: UITextView) {
        
        var aDelegate: UITextViewDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        
        aDelegate?.textViewDidEndEditing?(textView)
    }
    
    @objc public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var shouldReturn = true
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) {
                    shouldReturn = (unwrapDelegate.textView?(textView, shouldChangeTextIn: range, replacementText: text)) == true
                }
            }
        }
        
        if shouldReturn == true && text == "\n" {
            shouldReturn = goToNextResponderOrResign(textView)
        }
        
        return shouldReturn
    }
    
    @objc public func textViewDidChange(_ textView: UITextView) {
        
        var aDelegate: UITextViewDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        
        aDelegate?.textViewDidChange?(textView)
    }
    
    @objc public func textViewDidChangeSelection(_ textView: UITextView) {
        
        var aDelegate: UITextViewDelegate? = delegate
        
        if aDelegate == nil {
            
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        
        aDelegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: URL, in: characterRange, interaction: interaction) == true
                }
            }
        }
        
        return true
    }
    
    @available(iOS 10.0, *)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) == true
                }
            }
        }
        
        return true
    }
    
    @available(iOS, deprecated: 10.0)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, URL, NSRange) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: URL, in: characterRange) == true
                }
            }
        }
        
        return true
    }
    
    @available(iOS, deprecated: 10.0)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        
        if delegate == nil {
            
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange) == true
                }
            }
        }
        
        return true
    }
}

open class IQTextView: UITextView {
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        #if swift(>=4.2)
        let UITextViewTextDidChange = UITextView.textDidChangeNotification
        #else
        let UITextViewTextDidChange = Notification.Name.UITextViewTextDidChange
        #endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextViewTextDidChange, object: self)
    }
    
    @objc override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        #if swift(>=4.2)
        let notificationName = UITextView.textDidChangeNotification
        #else
        let notificationName = Notification.Name.UITextViewTextDidChange
        #endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: notificationName, object: self)
    }
    
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        
        #if swift(>=4.2)
        let UITextViewTextDidChange = UITextView.textDidChangeNotification
        #else
        let UITextViewTextDidChange = Notification.Name.UITextViewTextDidChange
        #endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextViewTextDidChange, object: self)
    }
    
    deinit {
        placeholderLabel.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    private var placeholderInsets: UIEdgeInsets {
        return UIEdgeInsets(top: self.textContainerInset.top, left: self.textContainerInset.left + self.textContainer.lineFragmentPadding, bottom: self.textContainerInset.bottom, right: self.textContainerInset.right + self.textContainer.lineFragmentPadding)
    }
    
    private var placeholderExpectedFrame: CGRect {
        let placeholderInsets = self.placeholderInsets
        let maxWidth = self.frame.width-placeholderInsets.left-placeholderInsets.right
        let expectedSize = placeholderLabel.sizeThatFits(CGSize(width: maxWidth, height: self.frame.height-placeholderInsets.top-placeholderInsets.bottom))
        
        return CGRect(x: placeholderInsets.left, y: placeholderInsets.top, width: maxWidth, height: expectedSize.height)
    }
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        label.textAlignment = self.textAlignment
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.alpha = 0
        self.addSubview(label)
        
        return label
    }()
    
    @IBInspectable open var placeholderTextColor: UIColor? {
        
        get {
            return placeholderLabel.textColor
        }
        
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    @IBInspectable open var placeholder: String? {
        
        get {
            return placeholderLabel.text
        }
        
        set {
            placeholderLabel.text = newValue
            refreshPlaceholder()
        }
    }
    
    open var attributedPlaceholder: NSAttributedString? {
        get {
            return placeholderLabel.attributedText
        }
        
        set {
            placeholderLabel.attributedText = newValue
            refreshPlaceholder()
        }
    }
    
    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel.frame = placeholderExpectedFrame
    }
    
    @objc internal func refreshPlaceholder() {
        
        if !text.isEmpty || !attributedText.string.isEmpty {
            placeholderLabel.alpha = 0
        } else {
            placeholderLabel.alpha = 1
        }
    }
    
    @objc override open var text: String! {
        
        didSet {
            refreshPlaceholder()
        }
    }
    
    open override var attributedText: NSAttributedString! {
        
        didSet {
            refreshPlaceholder()
        }
    }
    
    @objc override open var font: UIFont? {
        
        didSet {
            
            if let unwrappedFont = font {
                placeholderLabel.font = unwrappedFont
            } else {
                placeholderLabel.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    @objc override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    @objc override open var delegate: UITextViewDelegate? {
        
        get {
            refreshPlaceholder()
            return super.delegate
        }
        
        set {
            super.delegate = newValue
        }
    }
    
    @objc override open var intrinsicContentSize: CGSize {
        guard !hasText else {
            return super.intrinsicContentSize
        }
        
        var newSize = super.intrinsicContentSize
        let placeholderInsets = self.placeholderInsets
        newSize.height = placeholderExpectedFrame.height + placeholderInsets.top + placeholderInsets.bottom
        
        return newSize
    }
}

private var kIQShouldIgnoreScrollingAdjustment      = "kIQShouldIgnoreScrollingAdjustment"
private var kIQShouldRestoreScrollViewContentOffset = "kIQShouldRestoreScrollViewContentOffset"

@objc public extension UIScrollView {
    
    @objc var shouldIgnoreScrollingAdjustment: Bool {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQShouldIgnoreScrollingAdjustment) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldIgnoreScrollingAdjustment, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc var shouldRestoreScrollViewContentOffset: Bool {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

internal extension UITableView {
    
    func previousIndexPath(of indexPath: IndexPath) -> IndexPath? {
        var previousRow = indexPath.row - 1
        var previousSection = indexPath.section
        
        //Fixing indexPath
        if previousRow < 0 {
            previousSection -= 1
            
            if previousSection >= 0 {
                previousRow = self.numberOfRows(inSection: previousSection) - 1
            }
        }
        
        if previousRow >= 0 && previousSection >= 0 {
            return IndexPath(row: previousRow, section: previousSection)
        } else {
            return nil
        }
    }
}

internal extension UICollectionView {
    
    func previousIndexPath(of indexPath: IndexPath) -> IndexPath? {
        var previousRow = indexPath.row - 1
        var previousSection = indexPath.section
        
        //Fixing indexPath
        if previousRow < 0 {
            previousSection -= 1
            
            if previousSection >= 0 {
                previousRow = self.numberOfItems(inSection: previousSection) - 1
            }
        }
        
        if previousRow >= 0 && previousSection >= 0 {
            return IndexPath(item: previousRow, section: previousSection)
        } else {
            return nil
        }
    }
}

private var kIQLayoutGuideConstraint = "kIQLayoutGuideConstraint"

@objc public extension UIViewController {
    
    @available(*, deprecated, message: "Due to change in core-logic of handling distance between textField and keyboard distance, this layout contraint tweak is no longer needed and things will just work out of the box regardless of constraint pinned with safeArea/layoutGuide/superview.")
    @IBOutlet @objc var IQLayoutGuideConstraint: NSLayoutConstraint? {
        get {
            
            return objc_getAssociatedObject(self, &kIQLayoutGuideConstraint) as? NSLayoutConstraint
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &kIQLayoutGuideConstraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public let kIQUseDefaultKeyboardDistance = CGFloat.greatestFiniteMagnitude

private var kIQKeyboardDistanceFromTextField = "kIQKeyboardDistanceFromTextField"
private var kIQShouldResignOnTouchOutsideMode = "kIQShouldResignOnTouchOutsideMode"
private var kIQIgnoreSwitchingByNextPrevious = "kIQIgnoreSwitchingByNextPrevious"

@objc public extension UIView {
    
    @objc var keyboardDistanceFromTextField: CGFloat {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQKeyboardDistanceFromTextField) as? CGFloat {
                return aValue
            } else {
                return kIQUseDefaultKeyboardDistance
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQKeyboardDistanceFromTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc var ignoreSwitchingByNextPrevious: Bool {
        get {
            
            if let aValue = objc_getAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc var shouldResignOnTouchOutsideMode: IQEnableMode {
        get {
            
            if let savedMode = objc_getAssociatedObject(self, &kIQShouldResignOnTouchOutsideMode) as? IQEnableMode {
                return savedMode
            } else {
                return .default
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldResignOnTouchOutsideMode, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@objc public extension UIView {
    
    @objc func viewContainingController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    @objc func topMostController() -> UIViewController? {
        
        var controllersHierarchy = [UIViewController]()
        
        if var topController = window?.rootViewController {
            controllersHierarchy.append(topController)
            
            while let presented = topController.presentedViewController {
                
                topController = presented
                
                controllersHierarchy.append(presented)
            }
            
            var matchController: UIResponder? = viewContainingController()
            
            while let mController = matchController as? UIViewController, controllersHierarchy.contains(mController) == false {
                
                repeat {
                    matchController = matchController?.next
                    
                } while matchController != nil && matchController is UIViewController == false
            }
            
            return matchController as? UIViewController
            
        } else {
            return viewContainingController()
        }
    }
    
    @objc func parentContainerViewController() -> UIViewController? {
        
        var matchController = viewContainingController()
        var parentContainerViewController: UIViewController?
        
        if var navController = matchController?.navigationController {
            
            while let parentNav = navController.navigationController {
                navController = parentNav
            }
            
            var parentController: UIViewController = navController
            
            while let parent = parentController.parent,
                (parent.isKind(of: UINavigationController.self) == false &&
                    parent.isKind(of: UITabBarController.self) == false &&
                    parent.isKind(of: UISplitViewController.self) == false) {
                        
                        parentController = parent
            }
            
            if navController == parentController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = parentController
            }
        } else if let tabController = matchController?.tabBarController {
            
            if let navController = tabController.selectedViewController as? UINavigationController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = tabController.selectedViewController
            }
        } else {
            while let parentController = matchController?.parent,
                (parentController.isKind(of: UINavigationController.self) == false &&
                    parentController.isKind(of: UITabBarController.self) == false &&
                    parentController.isKind(of: UISplitViewController.self) == false) {
                        
                        matchController = parentController
            }
            
            parentContainerViewController = matchController
        }
        
        let finalController = parentContainerViewController?.parentIQContainerViewController() ?? parentContainerViewController
        
        return finalController
        
    }
    
    @objc func superviewOfClassType(_ classType: UIView.Type, belowView: UIView? = nil) -> UIView? {
        
        var superView = superview
        
        while let unwrappedSuperView = superView {
            
            if unwrappedSuperView.isKind(of: classType) {
                
                if unwrappedSuperView.isKind(of: UIScrollView.self) {
                    
                    let classNameString = NSStringFromClass(type(of: unwrappedSuperView.self))
                    
                    if unwrappedSuperView.superview?.isKind(of: UITableView.self) == false &&
                        unwrappedSuperView.superview?.isKind(of: UITableViewCell.self) == false &&
                        classNameString.hasPrefix("_") == false {
                        return superView
                    }
                } else {
                    return superView
                }
            } else if unwrappedSuperView == belowView {
                return nil
            }
            
            superView = unwrappedSuperView.superview
        }
        
        return nil
    }
    
    internal func responderSiblings() -> [UIView] {
        
        var tempTextFields = [UIView]()
        
        if let siblings = superview?.subviews {
            
            for textField in siblings {
                
                if (textField == self || textField.ignoreSwitchingByNextPrevious == false) && textField.IQcanBecomeFirstResponder() == true {
                    tempTextFields.append(textField)
                }
            }
        }
        
        return tempTextFields
    }
    
    internal func deepResponderViews() -> [UIView] {
        var textfields = [UIView]()
        
        for textField in subviews {
            
            if (textField == self || textField.ignoreSwitchingByNextPrevious == false) && textField.IQcanBecomeFirstResponder() == true {
                textfields.append(textField)
            }
            
            if textField.subviews.count != 0  && isUserInteractionEnabled == true && isHidden == false && alpha != 0.0 {
                for deepView in textField.deepResponderViews() {
                    textfields.append(deepView)
                }
            }
        }
        return textfields.sorted(by: { (view1: UIView, view2: UIView) -> Bool in
            
            let frame1 = view1.convert(view1.bounds, to: self)
            let frame2 = view2.convert(view2.bounds, to: self)
            
            if frame1.minY != frame2.minY {
                return frame1.minY < frame2.minY
            } else {
                return frame1.minX < frame2.minX
            }
        })
    }
    
    private func IQcanBecomeFirstResponder() -> Bool {
        
        var IQcanBecomeFirstResponder = false
        
        if let textField = self as? UITextField {
            IQcanBecomeFirstResponder = textField.isEnabled
        } else if let textView = self as? UITextView {
            IQcanBecomeFirstResponder = textView.isEditable
        }
        
        if IQcanBecomeFirstResponder == true {
            IQcanBecomeFirstResponder = isUserInteractionEnabled == true && isHidden == false && alpha != 0.0 && isAlertViewTextField() == false && textFieldSearchBar() == nil
        }
        
        return IQcanBecomeFirstResponder
    }
    
    internal func textFieldSearchBar() -> UISearchBar? {
        
        var responder: UIResponder? = self.next
        
        while let bar = responder {
            
            if let searchBar = bar as? UISearchBar {
                return searchBar
            } else if bar is UIViewController {
                break
            }
            
            responder = bar.next
        }
        
        return nil
    }
    
    internal func isAlertViewTextField() -> Bool {
        
        var alertViewController: UIResponder? = viewContainingController()
        
        var isAlertViewTextField = false
        
        while let controller = alertViewController, isAlertViewTextField == false {
            
            if controller.isKind(of: UIAlertController.self) {
                isAlertViewTextField = true
                break
            }
            
            alertViewController = controller.next
        }
        
        return isAlertViewTextField
    }
    
    private func depth() -> Int {
        var depth: Int = 0
        
        if let superView = superview {
            depth = superView.depth()+1
        }
        
        return depth
    }
    
}

@objc public extension UIViewController {
    
    func parentIQContainerViewController() -> UIViewController? {
        return self
    }
}

extension NSObject {
    
    internal func _IQDescription() -> String {
        return "<\(self) \(Unmanaged.passUnretained(self).toOpaque())>"
    }
}

internal extension Array where Element: UIView {
    
    func sortedArrayByTag() -> [Element] {
        
        return sorted(by: { (obj1: Element, obj2: Element) -> Bool in
            
            return (obj1.tag < obj2.tag)
        })
    }
    
    func sortedArrayByPosition() -> [Element] {
        
        return sorted(by: { (obj1: Element, obj2: Element) -> Bool in
            if obj1.frame.minY != obj2.frame.minY {
                return obj1.frame.minY < obj2.frame.minY
            } else {
                return obj1.frame.minX < obj2.frame.minX
            }
        })
    }
}
