//
//  ScanLabel.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 3/5/23.
//
import Vision
import UIKit

class ScanLabel : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let scrollView = UIScrollView()
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        let textView = UITextView(frame: CGRect(x: 50, y: 525, width: 300, height: 225))
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.text = IngredientList.text
        PhotoIcon.frame = CGRect (
           x: 80,
           y: 125,
           width: 40,
           height: 40)
        
        let scrollView = UIScrollView()
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // we're going to use auto-layout
        AllergyAssist.translatesAutoresizingMaskIntoConstraints = false
        PhotoIcon.translatesAutoresizingMaskIntoConstraints = false
        ScanAnItem.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
//        image_view.translatesAutoresizingMaskIntoConstraints = false
//        ChooseUser.translatesAutoresizingMaskIntoConstraints = false
//        Image_Selector.translatesAutoresizingMaskIntoConstraints = false
//        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // add Scrollview to view
        view.addSubview(AllergyAssist)
        view.addSubview(PhotoIcon)
        view.addSubview(ScanAnItem)
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(image_view)
        verticalStackView.setCustomSpacing(10, after: image_view)
        NSLayoutConstraint.activate([
            image_view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            image_view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image_view.heightAnchor.constraint(equalToConstant: 250.0),
        ])
        verticalStackView.addArrangedSubview(ChooseUser)
        verticalStackView.setCustomSpacing(10, after: ChooseUser)
        NSLayoutConstraint.activate([
            ChooseUser.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            ChooseUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ChooseUser.heightAnchor.constraint(equalToConstant: 30.0),
        ])
        verticalStackView.addArrangedSubview(Image_Selector)
        verticalStackView.setCustomSpacing(10, after: Image_Selector)
        NSLayoutConstraint.activate([
            Image_Selector.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            Image_Selector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Image_Selector.heightAnchor.constraint(equalToConstant: 30.0),
        ])
        verticalStackView.addArrangedSubview(IngredientList)
        NSLayoutConstraint.activate([
            IngredientList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            IngredientList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            IngredientList.heightAnchor.constraint(equalToConstant: 250.0),
        ])
        
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            AllergyAssist.topAnchor.constraint(equalTo: safeG.topAnchor,constant:5.0),
            AllergyAssist.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.75),
            AllergyAssist.heightAnchor.constraint(equalToConstant: 30.0),
            AllergyAssist.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            PhotoIcon.topAnchor.constraint(equalTo: AllergyAssist.bottomAnchor,constant:5.0),
            PhotoIcon.leftAnchor.constraint(equalTo: safeG.leftAnchor,constant: 50.0),
            PhotoIcon.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.075),
            PhotoIcon.heightAnchor.constraint(equalToConstant: 30.0),
            ScanAnItem.topAnchor.constraint(equalTo: AllergyAssist.bottomAnchor,constant:5.0),
            ScanAnItem.leftAnchor.constraint(equalTo: PhotoIcon.rightAnchor,constant: 50.0),
            ScanAnItem.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.5),
            ScanAnItem.heightAnchor.constraint(equalToConstant: 30.0),
            scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 80.0),
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 5.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -5.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -50.0),
            verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5.0),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5.0),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -5.0),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5.0),
        ])
        
        recognizeText(image: image_view.image)
//        start3()
        //navi()
    }
    
    let image_view : UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(systemName: "camera") //iv.image = UIImage(named : "sample.png")
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    let Image_Selector : UIButton = {
        let bt = UIButton()
        bt.setTitle("Upload Image", for: .normal)
        bt.titleLabel?.textColor = .white
        bt.backgroundColor = UIColor.systemBlue
        return bt
    }()
    
    @objc func pick_image(sender : UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selected_Image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        image_view.image = selected_Image
        recognizeText(image: image_view.image)
        self.dismiss(animated: true)
    }
    
    @objc func h1(sender : UIButton){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func start3(){
        image_view.frame = CGRect(x : 50, y: 180, width: 300, height: 250 )
        view.addSubview(image_view)
        AllergyAssist.frame = CGRect(x : 100, y: 50, width: 200, height: 36 )
        view.addSubview(AllergyAssist)
        ScanAnItem.frame = CGRect(x : 125, y: 120, width: 200, height: 50 )
        view.addSubview(ScanAnItem)
        ChooseUser.frame = CGRect(x : 150, y: 450, width: 100, height: 50 )
        view.addSubview(ChooseUser)
        IngredientList.frame = CGRect(x : 50, y: 525, width: 300, height: 225 )
        view.addSubview(IngredientList)
        Image_Selector.frame = CGRect(x:ChooseUser.center.x / 3.5 + 2, y: image_view.center.y + image_view.frame.height/1.3, width: image_view.frame.width - 20, height: 24)
        Image_Selector.addTarget(self, action: #selector(pick_image(sender: )), for: .touchUpInside)
        view.addSubview(Image_Selector)
    }
    
    private let AllergyAssist: UILabel = {
        let allergyAssist = UILabel()
        allergyAssist.numberOfLines = 0
        allergyAssist.textAlignment = .center
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 25)
        allergyAssist.text = "Allergy Assist"
        return allergyAssist
     }()
    
    private let ChooseUser: UILabel = {
        let chooseUser = UILabel()
        chooseUser.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        chooseUser.numberOfLines = 2
        chooseUser.textAlignment = .center
        chooseUser.font = UIFont.boldSystemFont(ofSize: 12)
        chooseUser.text = "Choose User To Scan"
        //chooseUser.cornerRadius = 10
        chooseUser.backgroundColor = UIColor.systemOrange
        return chooseUser
     }()
    
    private let IngredientList: UITextView = {
        let iList = UITextView()
        //iList.numberOfLines = 12
        //iList.textAlignment = .center
        iList.textColor = UIColor.black
        iList.font = UIFont.boldSystemFont(ofSize: 12)
        iList.text = ""
        iList.isEditable = false
        iList.isUserInteractionEnabled = true
        //chooseUser.cornerRadius = 10
        iList.backgroundColor = UIColor.white
        iList.layer.borderWidth = 1
        iList.layer.borderColor = UIColor.black.cgColor
         
         return iList
     }()
    
    private let ScanAnItem: UILabel = {
         let SAI = UILabel()
        SAI.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        SAI.numberOfLines = 2
        SAI.textAlignment = .center
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item label to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
    }
    
    //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
    }
    
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
           }).joined(separator: " ,")
    
            DispatchQueue.main.async {
        self?.IngredientList.text = text
            }
        }
    //Process the Request
           do {
               try handler.perform([request])
           }
           catch{
               IngredientList.text = ("\(error)")
           }
        
       }
    
   //Data Analysis
   public func DA(mes : String) -> Bool{
           //var text1 = mes
           print(mes)
       //passing the raw data in form of string
       // convert the string into array and split the substring by special symbols such as , ; space...
       // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
       let res : Bool = false;
       var cnt : Int = 0
       let arr = mes.split(separator: ", ")
       print(arr)
       var percentage_arr = [String]()
       for item in arr {
           if item.contains("%") {
               percentage_arr.append(String(item))
           }
       }
       print(percentage_arr)
       for i in 0..<arr.count {
           let lb = UILabel()
           lb.numberOfLines = -1
           let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
           let x : CGFloat = 10
           let y = CGFloat(i) * 20 + 300
           lb.frame = CGRect(x: x, y: y, width: size, height: 20)
           lb.backgroundColor = UIColor.black
           lb.clipsToBounds = true
           lb.layer.cornerRadius = 3
           lb.textColor = .white
           lb.font = UIFont.boldSystemFont(ofSize: 18)
           lb.text = String(arr[i])
           view.addSubview(lb)
       }
       return res;
   }
    
    /*let user_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        return bt
    }()
    let sb_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "barcode"), for: .normal)
        return bt
    }()
    let sl_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "camera"), for: .normal)
        return bt
    }()
    
    private func navi(){
        user_bt.frame = CGRect(x: 30, y: 770, width: 100, height: 30)
        user_bt.layer.cornerRadius = 10
        user_bt.addTarget(self, action: #selector(User_Account), for: .touchUpInside)
        view.addSubview(user_bt)
        sb_bt.frame = CGRect(x: 140, y: 770, width: 120, height: 30)
        sb_bt.layer.cornerRadius = 10
        sb_bt.addTarget(self, action: #selector(Scan_Barcode), for: .touchUpInside)
        view.addSubview(sb_bt)
        sl_bt.frame = CGRect(x: 270, y: 770, width: 100, height: 30)
        sl_bt.layer.cornerRadius = 10
        sl_bt.addTarget(self, action: #selector(Scan_Label), for: .touchUpInside)
        view.addSubview(sl_bt)
    }*/
    
    @objc func User_Account(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserAccountInfo()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
    @objc func Scan_Label(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanLabel()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
    @objc func Scan_Barcode(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = BarcodeScanner()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
}
