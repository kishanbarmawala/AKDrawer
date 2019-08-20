# AKDrawer
 
If you like SideMenu, give it a ★ at the top right of this page.

## SideMenu :-

- SideMenu is an easy-to-use side menu container controller written in Swift 4.
- It can be implemented in storyboard with your own deigned view controller with just very few line of code.
- Fully customizable without needing to write tons of custom code.
- Fully Expandable And Collapsible Sidemenu with Custom View (CollectionView Cell) Design.
- Menus can be presented and dismissed the same as any other view controller.
- Rubber band effect while panning.


## Requirements

    Swift 4.
    iOS 9.0 or higher.

## How to Use?
```swift
var menuVC = SidemenuController()  // Declare View Controller Object you want to Reveal

override viewDidLoad() {
    super.viewDidLoad()

    menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MENU") as! SidemenuController

    // Handle SideMenu Click event from Below Closure Code
    menuVC.menuSelection = { selection in
        print(selection)
    }
}

func sideMenuTapped() {
    // Present Below NavigationView Controller
//  self.view.addSubview(menuVC.view)
// self.addChild(menuVC)

    // Present Over NavigationView Controller
    UIApplication.shared.keyWindow?.addSubview(menuVC.view)
    
    menuVC.view.layoutIfNeeded()
    
    menuVC.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.menuVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }, completion: nil)
    
    menuVC.view.layoutIfNeeded()
}
```


###### Other Modules (How to use will be come soon!):-
  - DropDown
  	1. Android Style DropDown
  	2. Alert Style DropDown
  - Pulse Animation
  - API Calling Class
  - Horizontal Gradient
  - CollectionView FlowLayout with Equal Spacing with Top, Left, Bottom, Right, interItem and minimumLine Spacing 