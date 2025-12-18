//
//  ModuleViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 19/11/25.
//

import UIKit

class ModuleViewController: UIViewController {
    
    @IBOutlet weak var gasPrepButtonPressed: UIButton!
    
    @IBOutlet weak var acidBasePrepButtonPressed: UIButton!
    
    @IBAction func gasPrepButtonPressed(_ sender: UIButton) {
        let vc = GasPreparationViewController(nibName: "GasPreparation", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func acidBaseButtonPressed(_ sender: UIButton) {
        let vc = AcidBasePreparationViewController(nibName: "AcidBasePreparation", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
