# AKDrawer
 
If you like SideMenu, give it a ★ at the top right of this page.
You can Give your Reviews and Best Ideas!

## SideMenu :-

- SideMenu is an easy-to-use side menu container controller written in Swift 4.
- It can be implemented in storyboard with your own deigned view controller with just very few line of code.
- Fully customizable without needing to write tons of custom code.
- Fully Expandable And Collapsible Sidemenu with Custom View (CollectionView Cell) Design.
- Menus can be presented and dismissed the same as any other view controller.
- Rubber band effect while panning.


## ScreenShots :-

  Sidemenu Collapsed  |  Sidemenu Expanded  |  DropDown with Search  |  Pulse Animation
:--------------------:|:-------------------:|:----------------------:|:-----------------:
![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/SideMenu%20Collapsed.png)  |  ![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/SideMenu%20Expanded.png)  |  ![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/DropDown%20with%20Search.png)  |  ![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/Pulse%20Animation.png)

  Animated Loader  |  Alert DropDown  |  Equal Spacing CV Cell  
:-----------------:|:----------------:|:-----------------------:
![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/Loader%20With%20Image%20and%20Text.png)  |  ![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/Alert%20DropDown.png)  |  ![](https://github.com/kishanbarmawala/AKDrawer/blob/master/Screenshot/Equal%20Spacing%20CollectionView%20Cell.png)


## Requirements

- Swift 4.
- iOS 9.0 or higher.


## How to Make SideMenu?
```swift
var menuVC = SidemenuController()  // Declare View Controller Object you want to Reveal

override viewDidLoad() {
    super.viewDidLoad()

    menuVC = self.storyboard!.instantiateViewController(withIdentifier: "MENU") as! SidemenuController
    menuVC.SideMenuHeaderArr = ["Home & Loader","Service","Animation, Alert & Calender","CollectionView Flow Layout","Privacy Policy","Education","Other"]
    menuVC.SideMenuDataArr = [[],[],[],[],[],[],["Other-1","Other-2"]]
    
    // Handle SideMenu Click event from Below Closure Code
    menuVC.menuSelection = { selection in
        print(selection)
    }
}

func sideMenuTapped() {
    menuVC.revealSideMenu()
}
```

## How to Use API Calling Class?
- Put ServiceCenter.swift file in your Project
```swift
// Handle HttpResponse, JsonResponse & Error from Closure as Below. 

// Get Method

let yourURL = "https://jsonplaceholder.typicode.com/todos/2"

ServiceCenter.serviceCallGet(urlString: yourURL) { (httpResponse, json, error) in
    if httpResponse.statusCode == 200 {
        print(json)     // Json Response
    }
    else {
        print(error)    // Error
    }
}

// Post Method

let yourURL = ""

ServiceCenter.serviceCallPost(urlString: yourURL, headerKey: "UserId", headerValue: "1") { (httpResponse, json, error) in
    if httpResponse.statusCode == 200 {
        print(json)     // Json Response
    }
    else {
        print(error)    // Error
    }
}

// Upload Image on URL

let yourURL = ""

ServiceCenter.serviceCallImageUpload(url: yourURL, image : UIImage(named: "Test"), imageType: .jpeg) { (httpResponse, error) in
    if httpResponse.statusCode == 200 {
       // do your stuff after get response
    }
    else {
        print(error)    // Error
    } 
}
```

## How to Make Alert Style DropDown?

- Implement Below Code where you wanted to appear DropDown.
- Handle your selected data from selection variable in closure as shown below 
```swift
var dimView = UIView()
var ddTableView : UITableView = {
    let tempdd = UITableView()
    tempdd.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    tempdd.register(ddCell.self, forCellReuseIdentifier: "DDCELL")
    return tempdd   
}()                                                 // DropDown TableView - Closure Approach
var ddDataSource = Array<String>()                  // DropDown Data Source
var ddCellHeight: CGFloat = 40                      // Declare DropDown Each Cell Height
var selectionBtn = UIButton()                       // For Appear DropDown on Perticular Object


override func viewDidLoad() {
    super.viewDidLoad()

    ddTableView.delegate = self
    ddTableView.dataSource = self
}

// To show onClick of Button
@objc func DDTapped(_ sender: UIButton) {
    selectionBtn = sender
    showDD(frames: sender.frame, dataSource: ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"])
}

func showDD(frames: CGRect, dataSource: Array<Any>) {
        
    dimView = UIView()
    dimView.isHidden = false
    dimView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
    self.view.addSubview(dimView)
    
    ddDataSource = dataSource as! [String]
    ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    self.view.addSubview(ddTableView)
    ddTableView.layer.cornerRadius = 8.0
    
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    ddTableView.reloadData()
    
    let ddOutTap = UITapGestureRecognizer(target: self, action: #selector(hideDD))
    dimView.addGestureRecognizer(ddOutTap)
    dimView.alpha = 0
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.dimView.alpha = 0.5
        self.ddTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 4, width: frames.width, height: self.ddCellHeight * CGFloat(self.ddDataSource.count))
    }, completion: nil)
}

@objc func hideDD() {
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.dimView.alpha = 0
        self.ddTableView.frame = CGRect(x: self.selectionBtn.frame.origin.x, y: self.selectionBtn.frame.origin.y + self.selectionBtn.frame.height, width: self.selectionBtn.frame.width, height: 0)
    }, completion: nil)
}

// Use UTableViewDelegate Method
// Implement this method in your Controller

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    btnDD.setTitle(ddDataSource[indexPath.row], for: .normal)
    hideDD()
}
```

## How to Make Alert Style DropDown?

- Change Design of Alert Controller using AlertController.xib
- Implement Below Code where you wanted to appear Alert.
- Handle your selected data from selection variable in closure as shown below 
```swift
let AlertVC = AlertController(nibName: "AlertController", bundle: nil)
AlertVC.view.frame = UIScreen.main.bounds
self.addChild(AlertVC)
self.view.addSubview(AlertVC.view)
didMove(toParent: AlertVC)

AlertVC.addAction(title: "Alert DropDown", dataSource: ["Objective - C","Swift","Java","Kotlin","R Language","Ruby on Rails","JavaScript"] as [AnyObject]) { (selection) in
    print(selection)
}
```

## How to Make Pulse?
- Put PulseAnimation.swift File in Your Project First.
```swift
var dimView = UIView()

func showPulseWithMic()     //Show Pulse Animation with dimView
{
    dimView = UIView()
    dimView.isHidden = false
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    dimView.frame = UIScreen.main.bounds
    dimView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
    
    let imgMic = UIImageView(image: #imageLiteral(resourceName: "mic_icon"))
    imgMic.backgroundColor = .white
    imgMic.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    imgMic.contentMode = .scaleAspectFit
    imgMic.center = dimView.center
    imgMic.layer.cornerRadius = 25.0
    
    let pulse = PulseAnimation(numberOfPulses: Float.infinity, radius: 200, position: dimView.center)
    pulse.animationDuration = 1.0
    pulse.backgroundColor = UIColor(red: 238/255, green: 67/255, blue: 102/255, alpha: 1.0).cgColor
    
    dimView.layer.insertSublayer(pulse, below: imgMic.layer)
    dimView.addSubview(imgMic)
    UIApplication.shared.keyWindow?.addSubview(dimView)
    
    // call hidePulse function for manually stop pulsing
    // And comment below line
    Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hidePulse), userInfo: nil, repeats: false)
}

@objc func hidePulse() {
    dimView.isHidden = true
    dimView.backgroundColor = UIColor.clear
    dimView.removeFromSuperview()
}
```

## How to Apply Horizontal Gradient Color to View?
- make UIView extension in your Swift File
- Use:-
```swift
YourView.addGradient(colors: [UIColor.red.cgColor, UIColor.blue.cgColor], direction: .vertical)

extension UIView {
    enum Direction {
        case horizontal
        case vertical
    }
    func addGradient(colors: [CGColor], direction: Direction) {
        let gradeLayer = CAGradientLayer()
        gradeLayer.colors = colors//[UIColor.red.cgColor, UIColor.blue.cgColor]
        switch direction {
        case .horizontal:
            gradeLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradeLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            gradeLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradeLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        gradeLayer.frame = self.bounds
        self.layer.insertSublayer(gradeLayer, at: 0)
    }
}

```

## How to Set CollectionView Cell Equal Spacing?
```swift
var yourCollectionView: UICollectionView()

var numberOfColumns = Int()
var flowLayout = UICollectionViewFlowLayout()
var spacing = CGFloat()
var marginAndInsets = CGFloat()
    
override func viewDidLoad() {
    super.viewDidLoad()

    flowLayout = yourCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    flowLayout.sectionInset.top = 8                 // CollectionView Top Space
    flowLayout.sectionInset.left = 8                // CollectionView Leading Space
    flowLayout.sectionInset.right = 8               // CollectionView Trailing Space
    flowLayout.sectionInset.bottom = 8              // CollectionView Bottom Space
    flowLayout.minimumLineSpacing = 8               // CollectionView space between Lines
    flowLayout.minimumInteritemSpacing = 8          // CollectionView neighbour cell space
}

// Use UICollectionViewDelegateFlowLayout Method
// Implement this method in your Controller
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if UI_USER_INTERFACE_IDIOM() == .pad {
        numberOfColumns = 3
    } else {
        numberOfColumns = 2
    }
    
    spacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
    marginAndInsets = (flowLayout.sectionInset.left + flowLayout.sectionInset.right) + (spacing * (CGFloat(numberOfColumns) - 1))
    
    let itemWidth : CGFloat = (colCollection.frame.width - marginAndInsets) / CGFloat(numberOfColumns)
    let size = CGSize(width: itemWidth, height: itemWidth)
    
    return size
}
```

## Other Modules:-
```swift
    - Animate ImageView with Infinite Circular Rotation
    - Range Date Selection with Calender View
    - Loader with Custom Text in Circular shape and Image
    - For More ... Download the Project!
```