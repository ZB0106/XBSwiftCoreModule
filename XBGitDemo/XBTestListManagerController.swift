//
//  XBTestListManagerController.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/15.
//

import UIKit
import SnapKit
import XBSwiftCoreModule



class DataModel: XBDataModelProtocol {
    var dataComponents: XBDataModelComponents = XBDataModelComponents()
    
    var movieUrl: String = ""
    var movieName: String = ""
}

class SectionModel: XBSectionModelProtocol {
    var dataComponents: XBSectionModelComponents = XBSectionModelComponents()
    

    var title = "headerFooter"
}


class XBMovieCell: UITableViewCell, XBCellDataProtocol {
    deinit {
        print(#function,classForCoder)
    }
    func configureData<T>(item: T) {
        guard let item = item as? DataModel else { return }
        self.textLabel?.text = item.movieName
    }
    
    var item: XBDataModelProtocol! {
        didSet {
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class XBMovieSecView: UITableViewHeaderFooterView, XBSectionViewDataProtocol {
    deinit {
        print(#function,classForCoder)
    }
    func configureData<T>(item: T) {
        guard let item = item as? SectionModel else { return }
        textLabel?.text = item.title
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.brown
//        self.addSubview(textLabel)
//        textLabel.backgroundColor = UIColor.red
//        textLabel.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    lazy var textLabel: UILabel = {
//        let lb = UILabel()
//        lb.textColor = UIColor.black
//        return lb
//    }()
}


class XBTestListManagerController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10) {
//            self.listManager.tableView.reloadData()
//        }
       
        
        let v = listManager.listView
        self.view.addSubview(v!)
        v!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        guard let data = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Movies.plist", ofType:nil)!) else {
            return
        }
        
        var movies = [DataModel]()
        for (key, value) in data {
            var movie = DataModel()
            movie.movieName = key as! String
            movie.movieUrl = value as! String
            movie.cellClass = NSStringFromClass(XBMovieCell.self)
            movie.cellSize = CGSize(width: 0, height: 60)
            movies.append(movie)
        }
        var sec = SectionModel()
        sec.isEdit = true
        sec.editSize = CGSize(width: 0, height: 60)
        sec.footerEditSize = CGSize(width: 0, height: 90)
        sec.isClose = false
        sec.isClose = false
        sec.items.append(contentsOf: movies)
        sec.isFooterEdit = true
        sec.headerClass = NSStringFromClass(XBMovieSecView.self)
        sec.footerClass = NSStringFromClass(XBMovieSecView.self)
        sec.footerSize = CGSize(width: 0, height: 30)
        sec.headerSize = CGSize(width: 0, height: 30)

        
        movies.removeAll()
        for (key, value) in data {
            var movie = DataModel()
            movie.movieName = key as! String
            movie.movieUrl = value as! String
            movie.cellClass = NSStringFromClass(XBMovieCell.self)
            movie.cellSize = CGSize(width: 0, height: 60)
            movies.append(movie)
        }
        var sec1 = SectionModel()
        sec1.isClose = true
        sec1.items.append(contentsOf: movies)
        sec1.headerClass = NSStringFromClass(XBMovieSecView.self)
        sec1.footerClass = NSStringFromClass(XBMovieSecView.self)
        sec1.footerSize = CGSize(width: 0, height: 60)
        sec1.headerSize = CGSize(width: 0, height: 60)
        self.listManager.sectionArray = [sec,sec1]
        self.listManager.reloadData()
        
    }
    
    lazy var listManager: XBTableManager = {
        let m = XBTableManager()
        m.delegate = self
        return m
    }()

    deinit {
        print("XBTestListManagerController deinit")
    }
}
extension XBTestListManagerController: XBTableViewManagerDelegate {

    func XBcollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("why hit me")
    }
    func handelCollectionCellEvent(indexPath: IndexPath, eventHandel: Int) {
        print("干嘛打我")
    }
}


//collectionView
class TestCollectionController: UIViewController {
    var secModels = [MovieSecModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        
        var coms0 = XBMenuButtonComponents()
        coms0.titleColor = UIColor.black
        coms0.selTitleColor = UIColor.red
        coms0.downLineSelColor = UIColor.red
        let meneview0 = XBTopMenuView(titles: ["vertical","horizontal"], contentSizeType: .equalToSuper, buttonComponents: coms0)
        self.view.addSubview(meneview0)
        meneview0.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(40)
        }
        meneview0.clickHandle = { tag in
            if tag == 0 {
                self.layout?.scrollDirection = .vertical
            } else if tag == 1 {
                self.layout?.scrollDirection = .horizontal
            }
        }
        
        var coms = XBMenuButtonComponents()
        coms.titleColor = UIColor.black
        coms.selTitleColor = UIColor.red
        coms.downLineSelColor = UIColor.red
        let meneview = XBTopMenuView(titles: ["centerFlow","waterFlow"], contentSizeType: .equalToSuper, buttonComponents: coms)
        self.view.addSubview(meneview)
        meneview.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(meneview0.snp.bottom)
            make.height.equalTo(40)
        }
        meneview.clickHandle = { tag in
            if tag == 0 {
                self.layout?.layoutType = .centerFlow
            } else if tag == 1 {
                self.layout?.layoutType = .waterFlow
            }
        }
        
        self.view.addSubview(self.collectionView)
        
        let btn = UIButton(type: .contactAdd)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(meneview.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(btn.snp.bottom)
        }
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(MovieSecView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieSecView.identifier)
        collectionView.register(MovieSecView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MovieSecView.identifier)
        
        didTap()
    }
    
    
    @objc func didTap() {
        guard let data = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Movies.plist", ofType:nil)!) else {
            return
        }
        
        var movies = [MovieModel]()
        for (key, value) in data {
            var movie = MovieModel()
            movie.movieName = key as! String
            movie.movieUrl = value as! String
            movies.append(movie)
        }
//        movies = Array(movies[0..<6])
        let sec = MovieSecModel(items: movies)
        secModels.append(sec)
        self.collectionView.reloadData()
    }
    
    
    var layout: XBCollectionLayout?
    lazy var collectionView: UICollectionView = {
        let fl = XBCollectionLayout()
        fl.itemColum = 3
        self.layout = fl
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: fl)
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = UIColor.white
        v.delegate = self
        v.dataSource = self
//        v.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        return  v
    }()
    
    deinit {
        print("collecCCCC  deinit")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension TestCollectionController: XBCollectionLayoutDelegate, UICollisionBehaviorDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return secModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return secModels[section].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let element = self.secModels[indexPath.section].items[indexPath.row]
        cell.movie = element
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSecView.identifier, for: indexPath) as! MovieSecView
        var sec = self.secModels[indexPath.section]
        sec.kind = kind
        view.secModel = sec
        return view
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.layout?.scrollDirection == .vertical {
            if self.layout?.layoutType == .waterFlow {
                return CGSize(width: (ScreenBounds.width)/3.0, height: 50+CGFloat(Int.random(in: 0...10))*8)
            } else {
                return CGSize(width: (ScreenBounds.width)/CGFloat(indexPath.row+1)/2.0, height: 40)
            }
            
        } else {
            if self.layout?.layoutType == .waterFlow {
                return CGSize(width: 30+CGFloat(arc4random()%10)*8, height: (ScreenBounds.width)/2.0)
            } else {
                return CGSize(width: 40, height: (ScreenBounds.width)/CGFloat(indexPath.row+1)/2.0)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.layout?.scrollDirection == .vertical {
            return CGSize(width: 0, height: 30.0*CGFloat(section+1))
        } else {
            return CGSize(width: 30.0*CGFloat(section+1), height: 0)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.layout?.scrollDirection == .vertical {
            return CGSize(width: 0, height: 30.0*CGFloat(section+1))
        } else {
            return CGSize(width: 30.0*CGFloat(section+1), height: 0)
        }
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30*CGFloat(section+1), left: 30*CGFloat(section+1), bottom: 30*CGFloat(section+1), right: 30*CGFloat(section+1))
    }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForHeaderAt section: Int) -> UIEdgeInsets {
        return .zero
        return UIEdgeInsets(top: 30*CGFloat(section+1), left: 30*CGFloat(section+1), bottom: 30*CGFloat(section+1), right: 30*CGFloat(section+1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForFooterAt section: Int) -> UIEdgeInsets {
        return .zero
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15*CGFloat(section+1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15*CGFloat(section+1)
    }
}




struct XBMovieModel: XBDataModelProtocol {
    var dataComponents: XBDataModelComponents = XBDataModelComponents()
    static func == (lhs: XBMovieModel, rhs: XBMovieModel) -> Bool {
        return lhs.cellClass == rhs.cellClass && lhs.movieName == rhs.movieName && lhs.cellSize == rhs.cellSize && lhs.movieUrl == rhs.movieUrl
    }
    var movieName = ""
    var movieUrl = ""
}

struct XBMovieSecModel: XBSectionModelProtocol {
    var dataComponents: XBSectionModelComponents = XBSectionModelComponents()
    

    var header = "HeaderFooter"
    var footer = "footer"
    var kind = UICollectionView.elementKindSectionHeader
   
}

class XBCollectionMovieCell: UICollectionViewCell, XBCellDataProtocol {
    deinit {
        print(#function,classForCoder)
    }
    static var identifier = "movieCell"
    
    func configureData<T>(item: T) {
        guard let movie = item as? XBMovieModel else { return }
        self.textLabel.text = movie.movieName
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.orange
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didTap() {
        self.delegate?.handelCellEvent(indexPath: indexPath, item: item, eventID: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var textLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        lb.addGestureRecognizer(tap)
        return lb
    }()
}
class XBCollectionMovieSecView: UICollectionReusableView, XBSectionViewDataProtocol {
    deinit {
        print(#function,classForCoder)
    }
    func configureData<T>(item: T) {
        guard let secModel = item as? XBMovieSecModel else { return }
        if secModel.kind == UICollectionView.elementKindSectionHeader {
            textLabel.text = secModel.header
        } else {
            textLabel.text = secModel.footer
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var textLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        return lb
    }()
}

class XBTestCollectionController: UIViewController {
    var cirview: XBCircleScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        
        
        cirview = XBCircleScrollView(circleViewType: UILabel.self, isUseTimer: true)
        cirview.delegate = self
        cirview.pageControlRightOffSet = 30.0
        view.addSubview(cirview)
        cirview.pageCount = 3
        cirview.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(100)
        }
        
        var com2 = XBMenuButtonComponents()
        com2.titleColor = UIColor.black
        com2.selTitleColor = UIColor.red
        com2.downLineSelColor = UIColor.red
        let meneview2 = XBTopMenuView(titles: ["multiple","single", "count+"], contentSizeType: .equalToSuper, buttonComponents: com2)
        self.view.addSubview(meneview2)
        meneview2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(cirview.snp.bottom)
            make.height.equalTo(40)
        }
        meneview2.clickHandle = { [weak self] tag in
            if tag == 0 {
                self?.cirview.pageType = .multiple()
            } else if tag == 1 {
                self?.cirview.pageType = .single()
            } else if tag == 2 {
                self?.cirview.pageCount += 1
            }
        }
        
        
        var coms0 = XBMenuButtonComponents()
        coms0.titleColor = UIColor.black
        coms0.selTitleColor = UIColor.red
        coms0.downLineSelColor = UIColor.red
        let meneview0 = XBTopMenuView(titles: ["vertical","horizontal"], contentSizeType: .equalToSuper, buttonComponents: coms0)
        self.view.addSubview(meneview0)
        meneview0.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(meneview2.snp.bottom)
            make.height.equalTo(40)
        }
        meneview0.clickHandle = { [weak self] tag in
            if tag == 0 {
                self?.layout.scrollDirection = .vertical
            } else if tag == 1 {
                self?.layout.scrollDirection = .horizontal
            }
        }
        
        var coms = XBMenuButtonComponents()
        coms.titleColor = UIColor.black
        coms.selTitleColor = UIColor.red
        coms.downLineSelColor = UIColor.red
        let meneview = XBTopMenuView(titles: ["centerFlow","waterFlow", "leftFlow"], contentSizeType: .equalToSuper, buttonComponents: coms)
        self.view.addSubview(meneview)
        meneview.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(meneview0.snp.bottom)
            make.height.equalTo(40)
        }
        meneview.clickHandle = { [weak self] tag in
            if tag == 0 {
                self?.layout.layoutType = .centerFlow
            } else if tag == 1 {
                self?.layout.layoutType = .waterFlow
            } else if tag == 2 {
                self?.layout.layoutType = .leftFlow
            }
        }
        
        
        self.view.addSubview(self.listManager.listView)
        
        let btn = UIButton(type: .contactAdd)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(meneview.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        self.listManager.listView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(btn.snp.bottom)
        }
        
        //刷新一次展示空数据
//        self.listManager.reloadData()
//        didTap()
    }
    
    
    @objc func didTap() {
        guard let data = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Movies.plist", ofType:nil)!) else {
            return
        }
        var movies = [XBMovieModel]()
        for (key, value) in data {
            var movie = XBMovieModel()
            movie.movieName = key as! String
            movie.movieUrl = value as! String
            movie.cellClass = NSStringFromClass(XBCollectionMovieCell.self)
            movies.append(movie)
        }
//        movies = Array(movies[0..<6])
        var sec = XBMovieSecModel()
        sec.headerClass = NSStringFromClass(XBCollectionMovieSecView.self)
        sec.footerClass = NSStringFromClass(XBCollectionMovieSecView.self)
        sec.items.append(contentsOf: movies)
        listManager.sectionArray.append(sec)
        self.listManager.reloadData()
    }
    
    lazy var layout: XBCollectionLayout = {
        let fl = XBCollectionLayout()
        fl.itemColum = 3
        return fl
    }()
    lazy var listManager: XBCollectionManager = {
       
        let v = XBCollectionManager(flowLayout: self.layout, emptyManager: XBListEmptyManager())
        v.delegate = self
//        v.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        return  v
    }()
    
    deinit {
        print("collecCCCC  deinit")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension XBTestCollectionController: XBCollectionManagerDelegate {
    
    func XBListEmptyViewDidTap() {
        print("刷新试试")
    }
   
    func handelCellEvent(indexPath: IndexPath?, item: XBDataModelProtocol?, eventID: Int) {
        print("hello  xbing")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.layout.scrollDirection == .vertical {
            if self.layout.layoutType == .waterFlow {
                return CGSize(width: (ScreenBounds.width)/3.0, height: 50+CGFloat(Int.random(in: 0...10))*8)
            } else {
                return CGSize(width: (ScreenBounds.width)/CGFloat(indexPath.row+1)/2.0, height: 40)
            }
            
        } else {
            if self.layout.layoutType == .waterFlow {
                return CGSize(width: 30+CGFloat(arc4random()%10)*8, height: (ScreenBounds.width)/2.0)
            } else {
                return CGSize(width: 40, height: (ScreenBounds.width)/CGFloat(indexPath.row+1)/2.0)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if self.layout.scrollDirection == .vertical {
            return CGSize(width: 0, height: 30.0*CGFloat(section+1))
        } else {
            return CGSize(width: 30.0*CGFloat(section+1), height: 0)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.layout.scrollDirection == .vertical {
            return CGSize(width: 0, height: 30.0*CGFloat(section+1))
        } else {
            return CGSize(width: 30.0*CGFloat(section+1), height: 0)
        }
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30*CGFloat(section+1), left: 30*CGFloat(section+1), bottom: 30*CGFloat(section+1), right: 30*CGFloat(section+1))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15*CGFloat(section+1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15*CGFloat(section+1)
    }
}

extension XBTestCollectionController: XBCircleScrollViewDelegate {
    func XBCircleView(circleView: UIView, configureDataWithIndex index: Int) {
        if let view = circleView as? UILabel {
            view.text = "\(index+1)"
            view.font = UIFont.systemFont(ofSize: 72, weight: .semibold)
            view.textColor = UIColor.orange
            view.textAlignment = .center
        }
    }
}
