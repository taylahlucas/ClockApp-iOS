import UIKit
//import PlaygroundSupport

var str = "Hello, playground"

class ContentViewController: UIViewController {
    
    // MARK: - UI
    
    private let contentView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        
        return view
    }()
    
//    private let squareView: UIView = {
//        let view: UIView = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.blue
//
//        return view
//    }()
    
    private lazy var testButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    @objc func buttonAction(sender: UIButton!) {
        print("button tapped")
    }
    
//    // MARK: - Initialization
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all subviews as required
        view.addSubview(contentView)
        //contentView.addSubview(squareView)
        contentView.addSubview(testButton)

        
        // Call layout method
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        //
        //view.safeAreaInsets
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
//        NSLayoutConstraint.activate([
//            squareView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            squareView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
//            squareView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
//            squareView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
//        ])
        
        NSLayoutConstraint.activate([
            testButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            testButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            testButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            testButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}

//let viewController: ContentViewController = ContentViewController()
//viewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 536)

//PlaygroundPage.current.liveView = viewController.view
