//
//  ModuleViewController.swift
//  The Industrial Chemist
//
//  Created by admin25 on 19/11/25.
//

import UIKit

class ModuleViewController: UIViewController {

    @IBOutlet weak var gasPrepView: UIView!
    @IBOutlet weak var acidBaseView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGestures()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyCornerRadius()
    }

    // MARK: - UI Setup

    private func applyCornerRadius() {
        gasPrepView.layer.cornerRadius = 20
        gasPrepView.layer.masksToBounds = true

        acidBaseView.layer.cornerRadius = 20
        acidBaseView.layer.masksToBounds = true
    }

    private func setupTapGestures() {
        gasPrepView.isUserInteractionEnabled = true

        let gasPrepTap = UITapGestureRecognizer(
            target: self,
            action: #selector(gasPrepViewTapped)
        )
        gasPrepView.addGestureRecognizer(gasPrepTap)
    }

    // MARK: - Navigation

    @objc private func gasPrepViewTapped() {
        let vc = GasPrepViewController(nibName: "GasPrep", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func acidBaseButtonPressed(_ sender: UIButton) {
        let vc = AcidBasePreparationViewController(
            nibName: "AcidBasePreparation",
            bundle: nil
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
