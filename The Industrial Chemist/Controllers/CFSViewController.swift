import UIKit
// Classroom for school
class CFSViewController: UIViewController {

    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 24/255, green: 4/255, blue: 46/255, alpha: 1)
        title = "Chemist for Schools"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    private func setupLayout() {
        stack.axis = .vertical
        stack.spacing = 20

        let image = UIImageView(image: UIImage(named: "schools_banner")) // optional
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let titleLabel = makeLabel("Join a Classroom", size: 22, bold: true)
        let descLabel = makeLabel(
            "Enter the code shared by your teacher! This lets your teacher see your progress, send assignments, and control your account.",
            size: 14,
            bold: false,
            alpha: 0.7
        )

        let codeStack = UIStackView()
        codeStack.axis = .horizontal
        codeStack.spacing = 10
        codeStack.distribution = .fillEqually

        for _ in 0..<6 {
            let tf = UITextField()
            tf.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            tf.layer.cornerRadius = 10
            tf.textAlignment = .center
            tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
            codeStack.addArrangedSubview(tf)
        }

        let submit = UIButton(type: .system)
        submit.setTitle("SUBMIT", for: .normal)
        submit.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        submit.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        submit.layer.cornerRadius = 12
        submit.heightAnchor.constraint(equalToConstant: 48).isActive = true

        [image, titleLabel, descLabel, codeStack, submit].forEach {
            stack.addArrangedSubview($0)
        }

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func makeLabel(_ text: String, size: CGFloat, bold: Bool, alpha: CGFloat = 1) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = UIColor.white.withAlphaComponent(alpha)
        l.font = bold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        l.numberOfLines = 0
        return l
    }
}
