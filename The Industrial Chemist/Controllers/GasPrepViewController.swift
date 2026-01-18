import UIKit

class GasPrepViewController: UIViewController {

    @IBOutlet weak var prepView: UIView!

    @IBOutlet weak var ostwaldView: UIView!
    
    @IBOutlet weak var haberView: UIView!
    
    let ammoniaExperiment = Experiment(
        title: "Ammonia Process",
        testExperiment: "Ammonia",
        Setup: [
            // Label: Setup Your Workspace
            "Ensure the workspace is clean, well-ventilated, and safe before starting. Wear protective gear like gloves and safety goggles, and check all equipment, as ammonia preparation involves high pressure and temperature.",
            
            // Label: Real World Analogy
            "The process is similar to using a pressure cooker. Increased pressure and controlled heat allow nitrogen and hydrogen to react efficiently in the presence of a catalyst to form ammonia."
        ],
        
        Build: [
            // Components used in industrial preparation
            "The process uses components such as high-pressure reactors, compressors to raise gas pressure, heat exchangers for temperature control, and distillation columns to separate the formed ammonia."
        ],
        
        Theory:
            // Label: Haber Bosch Reaction
            "The Haber–Bosch process synthesizes ammonia by reacting nitrogen and hydrogen at high pressure and moderate temperature using an iron-based catalyst to speed up the reaction.",
        
        Test:
            // Haber Bosch equation
            "N₂ + 3H₂ ⇌ 2NH₃",
        
        Results:
            // Learning Summary → Key Takeaways
            "This experiment demonstrates how pressure, temperature, and catalysts are applied in industrial chemistry to produce ammonia, a key compound used in fertilizers and agriculture.",
        model: "ammonia"
    )

    let ostwaldExperiment = Experiment(
        title: "Ostwald Process",
        testExperiment: "Sulfuric Acid",
        Setup: [
            // Label: Setup Your Workspace
            "Ensure the industrial setup is clean, corrosion-resistant, and well-ventilated. Since the process involves toxic nitrogen oxides at high temperature, operators must wear protective gear and ensure proper gas handling systems are active.",
            
            // Label: Real World Analogy
            "The process is similar to controlled combustion in a car engine, where fuel reacts with oxygen at high temperature to produce useful energy. Here, ammonia is oxidized in a controlled manner to produce nitric acid."
        ],
        
        Build: [
            // Components used in industrial preparation
            "The setup includes an ammonia-air mixer, a platinum–rhodium gauze catalyst chamber, heat exchangers to recover heat, oxidation chambers, absorption towers, and cooling systems to convert nitrogen oxides into nitric acid."
        ],
        
        Theory:
            // Label: Ostwald Process Reactions
            "The Ostwald process produces nitric acid by catalytic oxidation of ammonia. Ammonia is first oxidized to nitric oxide, which is further oxidized to nitrogen dioxide and finally absorbed in water to form nitric acid.",
        
        Test:
            // Chemical equations
            """
4NH₃ + 5O₂ → 4NO + 6H₂O
2NO + O₂ → 2NO₂
3NO₂ + H₂O → 2HNO₃ + NO
""",
        
        Results:
            // Learning Summary → Key Takeaways
            "This experiment explains how ammonia is converted into nitric acid on an industrial scale, emphasizing the role of catalysts, temperature control, and gas absorption in producing an essential chemical used in fertilizers and explosives.",
        model: "ostwald"
    )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
    }

    private func setupTap() {
        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        let tapHaber = UITapGestureRecognizer(target: self, action: #selector(buttonPressedH))
        let tapOstwald = UITapGestureRecognizer(target: self, action: #selector(buttonPressedO))
        prepView.isUserInteractionEnabled = true
        prepView.addGestureRecognizer(tapContinue)
        ostwaldView.isUserInteractionEnabled = true
        ostwaldView.addGestureRecognizer(tapOstwald)
        haberView.isUserInteractionEnabled = true
        haberView.addGestureRecognizer(tapHaber)
    }

    @objc func buttonPressed() {
        let setUp = SetUpViewController(experiment: ammoniaExperiment, nib: "SetUp")
        self.navigationController?.pushViewController(setUp, animated: true)
        print("pressed")
    }
    @objc func buttonPressedH() {
        let setUp = SetUpViewController(experiment: ammoniaExperiment, nib: "SetUp" )
        self.navigationController?.pushViewController(setUp, animated: true)
        print("pressed")
    }
    @objc func buttonPressedO() {
        let setUp = SetUpViewController(experiment: ostwaldExperiment, nib: "SetUp" )
        self.navigationController?.pushViewController(setUp, animated: true)
        print("pressed")
    }
}
