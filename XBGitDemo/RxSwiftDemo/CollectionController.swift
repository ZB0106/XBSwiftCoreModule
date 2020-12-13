//
//  CollectionController.swift
//  XBGitDemo
//
//  Created by 苹果兵 on 2020/11/7.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxDataSources
import SnapKit


protocol CellModelProtocol: IdentifiableType, Equatable {
    var cellSize: CGSize {get set}
    var cellClass: AnyClass {get set}
    
}

extension CellModelProtocol {
    
    var cellSize: CGSize {
        set {}
        get {
            CGSize(width: 0, height: 0.01)
        }
    }
    var cellClass: AnyClass {
        set {}
        get {UICollectionViewCell.self}
    }
    
    var identity: String {
           return "CellModelProtocol"
       }
}
protocol SecModelProtocol: AnimatableSectionModelType {
    var secSize: CGSize {get set}
    var secClass: AnyClass {get set}
}

extension SecModelProtocol {
    var cellHeight: CGSize {
        set {}
        get { CGSize(width: 0, height: 0.01) }
    }
    var secClass: AnyClass {
        set {}
        get { UICollectionReusableView.self }
    }
    var identity: String {
           return "SecModelProtocol"
       }
    var items: [Item] {
        set {}
        get {[]}
    }
}

struct MovieModel: CellModelProtocol {
   
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        return lhs.cellClass == rhs.cellClass && lhs.movieName == rhs.movieName && lhs.cellSize == rhs.cellSize && lhs.identity == rhs.identity && lhs.movieUrl == rhs.movieUrl
    }
    var cellSize: CGSize = CGSize(width: 0, height: 0.01)
    var cellClass: AnyClass = UICollectionViewCell.self
    var movieName = ""
    var movieUrl = ""
}

struct MovieSecModel: SecModelProtocol {
    typealias Item = MovieModel
    
  
    var header = "Header"
    var footer = "footer"
    var kind = UICollectionView.elementKindSectionHeader
    var items: [Item]
    var secSize: CGSize = CGSize(width: 0, height: 0.01)
    var secClass: AnyClass = UICollectionReusableView.self
   
}
//需单独写 协议否者初始化会有问题
extension MovieSecModel {
    init(original: MovieSecModel, items: [MovieModel]) {
        self = original
        self.items = items
        
    }
}

extension MovieSecModel {
    
    
}


class MovieCell: UICollectionViewCell {
    deinit {
        print(#function,classForCoder)
    }
    static var identifier = "movieCell"
    var movie: MovieModel! {
        didSet {
            self.textLabel.text = movie.movieName
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
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
class MovieSecView: UICollectionReusableView {
    deinit {
        print(#function,classForCoder)
    }
    static var identifier = "moviewSecView"
    var secModel: MovieSecModel! {
        didSet {
            if secModel.kind == UICollectionView.elementKindSectionHeader {
                textLabel.text = secModel.header
            } else {
                textLabel.text = secModel.footer
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLabel)
        textLabel.backgroundColor = UIColor.red
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
class CollectionController: UIViewController {
    let bag = DisposeBag()
    var dataSource: RxCollectionViewSectionedReloadDataSource<MovieSecModel>!
    var obs: BehaviorSubject<[MovieSecModel]> = BehaviorSubject(value: [MovieSecModel]())
    var secModels = [MovieSecModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        
        let btn = UIButton(type: .contactAdd)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(30)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(btn.snp.bottom)
        }
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(MovieSecView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieSecView.identifier)
        collectionView.register(MovieSecView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MovieSecView.identifier)
        
        
        dataSource = RxCollectionViewSectionedReloadDataSource<MovieSecModel> { (source, view, indexpath, element) -> UICollectionViewCell in
            let cell = view.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexpath) as! MovieCell
            cell.movie = element
            return cell
        } configureSupplementaryView: { (source, view, kind, indexPath) -> UICollectionReusableView in
            let view = view.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSecView.identifier, for: indexPath) as! MovieSecView
            var sec = source.sectionModels[indexPath.section]
            
//            source.model(at: indexPath)
            sec.kind = kind
            view.secModel = sec
            return view
        }
       
        obs.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        collectionView.rx.setDelegate(self)
                    .disposed(by: bag)
       
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
             
            if let model = self?.dataSource[indexPath] {
                print(model.movieName)
            }
        }).disposed(by: bag)
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
        let sec = MovieSecModel(items: movies)
        secModels.append(sec)
        obs.on(.next((self.secModels)))
       
        
    }
    lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .vertical
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: fl)
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = UIColor.blue
//        v.delegate = self
//        v.dataSource = self
        return  v
    }()
    
    deinit {
        print("collecCCCC  deinit")
    }
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenBounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenBounds.width, height: 30.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        

        return CGSize(width: ScreenBounds.width, height: 30.0)
    }
}



let bag = DisposeBag()


public func testRx() {
    
    var voidOb: Observable<Void>
    var boolOb: Observable<Bool>
    var voidOb2: Observable<Void>
    voidOb = Observable.create({ (obser) -> Disposable in
        obser.onNext(())
        obser.onCompleted()
        return Disposables.create()
    })
    //空序列到普通序列转换 Observable<Void>
    boolOb = voidOb.map({ _ -> Bool in
        true
    })
    boolOb = voidOb.flatMap({ _ -> Observable<Bool> in
        Observable.of(true)
    })
    
    
    
    //空序列到空序列转换
    voidOb2 = voidOb.flatMap({ _ -> Observable<Void> in
        Observable.create { (obser) -> Disposable in
            obser.onNext(())
            obser.onCompleted()
            return Disposables.create()
        }
    })
    voidOb2 = voidOb.flatMap({
        Observable.create { (obser) -> Disposable in
            obser.onNext(())
            obser.onCompleted()
            return Disposables.create()
        }
    })
    
    voidOb2 = voidOb.map({ })
    
    
    
    
    
    //无赋值序列转换时默认打开的方法要比赋值转换多一对()
    //无赋值序列转换
    voidOb2.flatMap { _ -> Observable<Bool> in
        return Observable.of(true)
    }
    //不指定类型返回，有返回结果决定
    voidOb2.flatMap { _ in
        return Observable.of(true)
    }
    voidOb2.map { _ in
        true
    }
    //直接返回
    voidOb2.flatMap {return Observable.of(true)}
    
    voidOb2.map { true }
}
