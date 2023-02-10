//
//  ViewController.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 09.02.23.
//

import UIKit

class ViewController: UIViewController {
    
    private var shapeData: [Shape] = [] {
        didSet {
            shapeList.reloadData()
        }
    }
    
    private var shapeViews: [UIView] = []
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var shapeList: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        table.register(ShapeTableViewCell.self, forCellReuseIdentifier: "cellID")
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        
        return table
        
    }()
    
    private let persistencyController = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var fetchedShapes: [Figure] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(shapeList)
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            shapeList.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            shapeList.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            shapeList.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            shapeList.widthAnchor.constraint(equalToConstant: view.frame.width * 0.25),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: shapeList.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //fetchDataFromPersistencyController()
        //addViewsAfterFetching()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //updateDataBeforeSaving()
        //saveDataToPersistencyController()
    }
    
    private func updateDataBeforeSaving() {
        for (index,shape) in shapeViews.enumerated() {
            shapeData[index].setRectangle(origin: shape.frame.origin, size: shape.frame.size)
        }
    }
    
    private func saveDataToPersistencyController() {
        for shape in shapeData {
            let figure: Figure = Figure(context: persistencyController)
            figure.title = shape.title
            figure.height = Float(shape.size.height)
            figure.width = Float(shape.size.width)
            figure.pointX = Float(shape.origin.x)
            figure.pointY = Float(shape.origin.y)
            figure.colourRed = Float(shape.colour.components?.first ?? 0)
            figure.colourGreen = Float(shape.colour.components?.last ?? 1)
            figure.colourBlue = 0
        }
        
        do {
            try persistencyController.save()
        } catch {
            print("Saving went wrong")
        }
    }
    
    private func fetchDataFromPersistencyController() {
        do {
            try fetchedShapes = persistencyController.fetch(Figure.fetchRequest())
            
            shapeData = fetchedShapes.map {
                let shapeType: Shapes = Square.convertTitleToType(title: $0.title)
                
                switch shapeType {
                case .square:
                    return Square(title: $0.title, size: .init(width: CGFloat($0.width), height: CGFloat($0.height)), origin: .init(x: CGFloat($0.pointX), y: CGFloat($0.pointY)), type: shapeType, colour: CGColor(red: CGFloat($0.colourRed), green: CGFloat($0.colourGreen), blue: CGFloat($0.colourBlue), alpha: 1))
                case .rectangle:
                    return Rectangle(title: $0.title, size: .init(width: CGFloat($0.width), height: CGFloat($0.height)), origin: .init(x: CGFloat($0.pointX), y: CGFloat($0.pointY)), type: shapeType, colour: CGColor(red: CGFloat($0.colourRed), green: CGFloat($0.colourGreen), blue: CGFloat($0.colourBlue), alpha: 1))
                case .triangle:
                    return Triangle(title: $0.title, size: .init(width: CGFloat($0.width), height: CGFloat($0.height)), origin: .init(x: CGFloat($0.pointX), y: CGFloat($0.pointY)), type: shapeType, colour: CGColor(red: CGFloat($0.colourRed), green: CGFloat($0.colourGreen), blue: CGFloat($0.colourBlue), alpha: 1))
                }
            }
        } catch {
            print("Fetching went wrong")
        }
    }
    
    private func addViewsAfterFetching() {
        
        var shapeView: UIView = UIView()
        
        for shape in shapeData {
            if shape.type == .triangle {
                shapeView = TriangleView()
            }
            contentView.addSubview(shapeView)
            shapeView.frame = .init(x: shape.origin.x, y: shape.origin.y, width: shape.size.width, height: shape.size.height)
            shapeView.center = contentView.center
            shapeView.setBackgroundColour(to: UIColor(cgColor: shape.colour))
            
            addPinchGesture(to: shapeView, data: shape)
            addRotationGesture(to: shapeView)
            addPanGesture(to: shapeView)
            
            shapeViews.append(shapeView)
        }
    }
    
    private func addShape() {
        let types : [Shapes] = [.square, .triangle, .rectangle]
        let type: Shapes = types.randomElement()!
        
        let colours: [CGColor] = [UIColor.red.cgColor, UIColor.gray.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.systemPink.cgColor, UIColor.orange.cgColor]
        let colour: CGColor = colours.randomElement()!
        
        var shape: UIView = UIView()
        
        var data: Shape
        
        switch type {
        case .square:
            
            let side: Int = (100...Int(contentView.frame.width/2)).randomElement()!
            data = Square(title: Shapes.square.rawValue, size: .init(width: side, height: side), origin: contentView.center ,colour: colour)
            
        case .rectangle:
            
            let height: Int = (100...Int(contentView.frame.height/2)).randomElement()!
            let width: Int = (100...Int(contentView.frame.width/2)).randomElement()!
            data = Rectangle(title: Shapes.rectangle.rawValue, size: .init(width: width, height: height), origin: contentView.center , colour: colour)
            
        case .triangle:
            
            shape = TriangleView()
            
            let height: Int = (100...Int(contentView.frame.height/2)).randomElement()!
            let width: Int = (100...Int(contentView.frame.width/2)).randomElement()!
            data = Triangle(title: Shapes.triangle.rawValue, size: .init(width: width, height: height), origin: contentView.center , colour: colour)
        }
        
        contentView.addSubview(shape)
        shape.frame = .init(x: data.origin.x, y: data.origin.y, width: data.size.width, height: data.size.height)
        shape.center = contentView.center
        shape.setBackgroundColour(to: UIColor(cgColor: data.colour))
        
        addPinchGesture(to: shape, data: data)
        addRotationGesture(to: shape)
        addPanGesture(to: shape)
        
        shapeViews.append(shape)
        shapeData.append(data)
        
        //saveDataToPersistencyController()
    }
    
    private func addPinchGesture(to shape: UIView, data: Shape) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_ :)))
        pinchGesture.delegate = self
        shape.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        guard let shape = gesture.view else { return }
        
        shape.transform = shape.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
    
    private func addRotationGesture(to shape: UIView) {
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_ :)))
        rotationGesture.delegate = self
        shape.addGestureRecognizer(rotationGesture)
    }
    
    @objc private func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard let shape = gesture.view else { return }
        
        shape.transform = shape.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    private func addPanGesture(to shape: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDrag(_ :)))
        panGesture.delegate = self
        shape.addGestureRecognizer(panGesture)
    }
    
    @objc private func didDrag(_ gesture: UIPanGestureRecognizer) {
        guard let shape = gesture.view else { return }
        let translation = gesture.translation(in: gesture.view)
        shape.transform = shape.transform.translatedBy(x: translation.x, y: translation.y)
        print (translation.x)
        print(translation.y)
        gesture.setTranslation(.zero, in: shape)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shapeData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? ShapeTableViewCell
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ShapeTableViewCell else {return}
        
        cell.selectionStyle = .none
        cell.hidePlusButton()
        cell.title = ""
        
        if indexPath.item == shapeData.count {
            cell.showPlusButton()
            return
        }
        cell.title = shapeData[indexPath.item].title
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == shapeData.count {
            addShape()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.item == shapeData.count {
            return UISwipeActionsConfiguration()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,_ in
            guard let self = self else {return}
            self.shapeViews[indexPath.item].removeFromSuperview()
            self.shapeViews.remove(at: indexPath.item)
            self.shapeData.remove(at: indexPath.item)
            if !self.fetchedShapes.isEmpty {
                self.persistencyController.delete(self.fetchedShapes[indexPath.item])
                do {
                    try self.persistencyController.save()
                } catch {
                    print("Deleting went wrong")
                }
            }
        }
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
