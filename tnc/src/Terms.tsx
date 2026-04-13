import {
  FaArrowLeft,
  FaShieldAlt,
  FaUserCheck,
  FaCreditCard,
  FaLock,
  FaUsers,
  FaBan,
  FaExclamationTriangle,
  FaGavel,
  FaEnvelope,
  FaEdit,
  FaTimesCircle,
  FaInfoCircle,
  FaStar,
  FaApple,
} from 'react-icons/fa'
import { useNavigate } from 'react-router-dom'
import './Terms.css'

interface TermsProps {
  onBack?: () => void
}

const sections = [
  {
    id: 'acceptance',
    icon: FaUserCheck,
    title: '1. Acceptance of Terms',
    content: [
      'By downloading, installing, or using The Industrial Chemist application ("App"), you agree to be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, do not use the App.',
      'These Terms constitute a legally binding agreement between you ("User") and The Industrial Chemist ("we", "us", or "our"). These Terms apply to all users of the App, including users who access the App via iOS devices.',
      'We reserve the right to update or modify these Terms at any time. Continued use of the App after any changes constitutes your acceptance of the revised Terms. We will notify users of material changes via in-app notification or email.',
    ],
  },
  {
    id: 'eligibility',
    icon: FaShieldAlt,
    title: '2. Eligibility',
    content: [
      'You must be at least 13 years of age to use this App. If you are under 18, you confirm that you have the consent of a parent or legal guardian to use the App and agree to these Terms.',
      'By using the App, you represent and warrant that: (a) you are at least 13 years old; (b) you have the legal capacity to enter into a binding agreement; (c) you are not prohibited from using the App under any applicable law.',
      'We reserve the right to refuse access to the App to any person or entity at our sole discretion.',
    ],
  },
  {
    id: 'accounts',
    icon: FaLock,
    title: '3. User Accounts',
    content: [
      'To access certain features of the App, you must create an account using a valid email address and password, or via supported third-party authentication (e.g., Sign in with Apple, Google Sign-In).',
      'You are responsible for maintaining the confidentiality of your account credentials and for all activity that occurs under your account. You agree to notify us immediately of any unauthorised use of your account.',
      'You may not share your account with others or create multiple accounts. Each account is for a single individual user only.',
      'We reserve the right to suspend or terminate accounts that violate these Terms, contain false information, or that have been inactive for an extended period, with or without notice.',
      'Upon account deletion, your data — including experiment progress, streak history, and community posts — may be permanently removed from our systems in accordance with our Privacy Policy.',
    ],
  },
  {
    id: 'subscriptions',
    icon: FaCreditCard,
    title: '4. Subscriptions & Payments',
    content: [
      'The App offers a free tier ("Starter") and a paid subscription tier ("Premium"). Premium subscriptions are offered on a monthly or annual basis at the prices displayed in the App at the time of purchase.',
      'All purchases are processed through Apple\'s App Store and are subject to Apple\'s payment terms and conditions. We do not store or process payment information directly.',
      'Premium subscriptions automatically renew at the end of each billing period unless cancelled at least 24 hours before the renewal date. You can manage or cancel your subscription at any time through your Apple ID account settings.',
      'No refunds are provided for partial subscription periods, except as required by applicable law. If you believe you were charged in error, contact us at the email address listed in Section 16.',
      'We reserve the right to change subscription pricing at any time. Price changes will be communicated to subscribers in advance and will take effect at the next renewal period.',
      'Free trial offers, if available, are limited to one per Apple ID. At the end of a free trial, you will be charged for the applicable subscription unless cancelled before the trial ends.',
    ],
  },
  {
    id: 'free-premium',
    icon: FaStar,
    title: '5. Free and Premium Features',
    content: [
      'The Starter (free) tier provides access to the Gas Preparation experiment, including the Theory and Build phases, global leaderboard access, community forums, and daily streak tracking.',
      'The Premium tier unlocks all available experiments (including Haber Process, Ostwald Process, Contact Process / Sulfuric Acid, Methanol Production, and Acid-Base Reactions), all experiment phases (Theory, Build, Test, Results), 3D AR molecular models, badge collection, and priority access to new content.',
      'We reserve the right to modify the content available in each tier at any time. We will make reasonable efforts to notify users of significant changes to what is included in their subscription tier.',
      'Premium features are tied to your account. If your subscription lapses, access to Premium content will be revoked until a valid subscription is reinstated.',
    ],
  },
  {
    id: 'ip',
    icon: FaShieldAlt,
    title: '6. Intellectual Property',
    content: [
      'All content within the App — including but not limited to experiment content, text, graphics, 3D models, animations, interface design, icons, logos, and software — is the exclusive property of The Industrial Chemist or its licensors and is protected by applicable copyright, trademark, and intellectual property laws.',
      'You are granted a limited, non-exclusive, non-transferable, revocable licence to use the App solely for your personal, non-commercial educational purposes. This licence does not include the right to: (a) copy, modify, or distribute App content; (b) reverse engineer, decompile, or disassemble the App; (c) use the App for commercial purposes without our express written consent.',
      'Any feedback, suggestions, or ideas you provide to us regarding the App may be used by us without restriction or compensation to you.',
      '"The Industrial Chemist" name, logo, and associated marks are trademarks of The Industrial Chemist. You may not use these marks without our prior written permission.',
    ],
  },
  {
    id: 'ugc',
    icon: FaUsers,
    title: '7. User-Generated Content',
    content: [
      'The App includes Community Forums where users may post questions, replies, and other content ("User Content"). By submitting User Content, you grant us a non-exclusive, worldwide, royalty-free licence to use, display, reproduce, and distribute that content within the App.',
      'You retain ownership of your User Content, but you represent and warrant that: (a) you own or have the right to post the content; (b) the content does not infringe any third-party rights; (c) the content complies with these Terms.',
      'We do not endorse, verify, or assume responsibility for User Content. We reserve the right, but not the obligation, to monitor, edit, or remove User Content at our sole discretion.',
      'You acknowledge that User Content may be visible to other users of the App. Do not post personal information, sensitive data, or anything you do not wish to be publicly visible.',
    ],
  },
  {
    id: 'prohibited',
    icon: FaBan,
    title: '8. Prohibited Conduct',
    content: [
      'You agree not to engage in any of the following prohibited activities:',
      '(a) Posting content that is unlawful, defamatory, abusive, threatening, harassing, discriminatory, obscene, or otherwise objectionable.',
      '(b) Impersonating another person or entity, or misrepresenting your affiliation with any person or entity.',
      '(c) Using the App to distribute spam, malware, or any form of unsolicited communication.',
      '(d) Attempting to gain unauthorised access to any part of the App, its servers, or any connected systems.',
      '(e) Using automated scripts, bots, or scrapers to access or collect data from the App.',
      '(f) Cheating, exploiting bugs, or manipulating the leaderboard, XP system, or streak tracking in any way.',
      '(g) Reproducing, duplicating, or reselling any part of the App or its content without our express written consent.',
      '(h) Violating any applicable local, national, or international law or regulation.',
      'Violation of these prohibitions may result in immediate suspension or termination of your account without refund.',
    ],
  },
  {
    id: 'privacy',
    icon: FaLock,
    title: '9. Privacy',
    content: [
      'Your privacy is important to us. Our Privacy Policy explains how we collect, use, store, and protect your personal information. By using the App, you agree to the collection and use of your data as described in the Privacy Policy.',
      'We collect data necessary to provide the App\'s features, including account information, experiment progress, streak data, leaderboard rankings, and community activity.',
      'We do not sell your personal data to third parties. We may share data with trusted service providers (e.g., Firebase by Google) necessary to operate the App, subject to data protection agreements.',
      'The App may collect usage analytics to improve the user experience. You may opt out of non-essential analytics through your device or account settings where applicable.',
    ],
  },
  {
    id: 'disclaimers',
    icon: FaExclamationTriangle,
    title: '10. Disclaimers',
    content: [
      'THE APP IS PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.',
      'We do not warrant that: (a) the App will be uninterrupted, error-free, or free of viruses; (b) the results obtained from using the App will be accurate or reliable; (c) any errors in the App will be corrected.',
      'The chemistry content in the App is provided for educational purposes only. It does not constitute professional scientific, laboratory, or safety advice. Always follow appropriate safety protocols when conducting real-world chemistry experiments.',
      'We are not responsible for any real-world actions taken based on content learned within the App. The App simulates industrial processes in a virtual environment and does not replace formal scientific training.',
    ],
  },
  {
    id: 'liability',
    icon: FaGavel,
    title: '11. Limitation of Liability',
    content: [
      'TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, THE INDUSTRIAL CHEMIST AND ITS TEAM MEMBERS SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING BUT NOT LIMITED TO LOSS OF DATA, LOSS OF PROFITS, OR LOSS OF GOODWILL, ARISING OUT OF OR RELATED TO YOUR USE OF OR INABILITY TO USE THE APP.',
      'IN NO EVENT SHALL OUR TOTAL LIABILITY TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATED TO THESE TERMS OR THE APP EXCEED THE AMOUNT YOU PAID US IN THE TWELVE (12) MONTHS PRECEDING THE CLAIM, OR $10.00, WHICHEVER IS GREATER.',
      'Some jurisdictions do not allow the exclusion of certain warranties or limitation of liability for incidental or consequential damages, so the above limitations may not apply to you.',
    ],
  },
  {
    id: 'indemnification',
    icon: FaShieldAlt,
    title: '12. Indemnification',
    content: [
      'You agree to indemnify, defend, and hold harmless The Industrial Chemist and its team members from and against any claims, liabilities, damages, losses, costs, or expenses (including reasonable legal fees) arising from: (a) your use or misuse of the App; (b) your User Content; (c) your violation of these Terms; (d) your violation of any third-party right.',
    ],
  },
  {
    id: 'termination',
    icon: FaTimesCircle,
    title: '13. Termination',
    content: [
      'We may suspend or terminate your access to the App at any time, with or without cause, and with or without notice. Grounds for termination include, but are not limited to, violation of these Terms, fraudulent activity, or conduct harmful to other users or to us.',
      'You may terminate your account at any time by deleting the App and contacting us to request account deletion. Upon termination, your licence to use the App ceases immediately.',
      'Provisions of these Terms that by their nature should survive termination shall survive, including intellectual property, disclaimers, indemnification, and limitation of liability sections.',
    ],
  },
  {
    id: 'changes',
    icon: FaEdit,
    title: '14. Changes to the App and Terms',
    content: [
      'We reserve the right to modify, suspend, or discontinue the App (or any part of it) at any time with or without notice. We will not be liable to you or any third party for any modification, suspension, or discontinuation of the App.',
      'We may revise these Terms from time to time. The most current version will always be available within the App and on our website. If a revision materially changes your rights, we will provide reasonable notice.',
      'Your continued use of the App after any changes to the Terms constitutes your acceptance of the updated Terms.',
    ],
  },
  {
    id: 'governing-law',
    icon: FaGavel,
    title: '15. Governing Law & Dispute Resolution',
    content: [
      'These Terms are governed by and construed in accordance with applicable laws, without regard to conflict of law principles. Any disputes arising under or in connection with these Terms shall first be subject to good-faith negotiation between the parties.',
      'If a dispute cannot be resolved informally, both parties agree to submit to binding arbitration or the jurisdiction of the courts applicable to the place of incorporation of The Industrial Chemist, as determined by us.',
      'Notwithstanding the above, we reserve the right to seek injunctive or other equitable relief in any court of competent jurisdiction to protect our intellectual property or confidential information.',
    ],
  },
  {
    id: 'contact',
    icon: FaEnvelope,
    title: '16. Contact Us',
    content: [
      'If you have questions, concerns, or feedback regarding these Terms or the App, please contact us.',
      'For account-related issues, subscription support, content concerns, or to request account deletion, reach out via the in-app Settings > Contact & Feedback option, or through the App Store support link.',
      'We aim to respond to all enquiries within 5 business days.',
    ],
  },
]

export default function Terms({ onBack }: TermsProps) {
  const navigate = useNavigate()
  const handleBack = onBack ?? (() => navigate('/'))
  return (
    <div className="terms-page">
      <div className="terms-nav">
        <button className="terms-back-btn" onClick={handleBack}>
          <FaArrowLeft />
          Back
        </button>
        <div className="terms-nav-title">The Industrial Chemist</div>
        <div style={{ width: 80 }} />
      </div>

      <div className="terms-hero">
        <div className="terms-hero-icon">
          <FaApple />
        </div>
        <div className="terms-badge">Legal</div>
        <h1>Terms &amp; Conditions</h1>
        <p>Please read these terms carefully before using The Industrial Chemist app.</p>
        <div className="terms-meta">
          <span>Effective: 13 April 2026</span>
          <span className="terms-meta-dot" />
          <span>Last updated: 13 April 2026</span>
        </div>
      </div>

      <div className="terms-body">
        <div className="terms-sidebar">
          <div className="terms-toc">
            <div className="toc-label">Contents</div>
            {sections.map(s => (
              <a key={s.id} href={`#${s.id}`} className="toc-link">
                {s.title.split('. ').slice(1).join('. ')}
              </a>
            ))}
          </div>
        </div>

        <div className="terms-content">
          <div className="terms-intro-box">
            <FaInfoCircle className="intro-icon" />
            <p>
              These Terms and Conditions ("Terms") govern your use of The Industrial Chemist iOS application. By using the App, you confirm that you have read, understood, and agree to be bound by these Terms. If you are using the App on behalf of an organisation, you agree to these Terms on behalf of that organisation.
            </p>
          </div>

          {sections.map(s => {
            const Icon = s.icon
            return (
              <div className="terms-section" id={s.id} key={s.id}>
                <div className="terms-section-header">
                  <div className="terms-section-icon">
                    <Icon />
                  </div>
                  <h2>{s.title}</h2>
                </div>
                <div className="terms-section-body">
                  {s.content.map((para, i) => (
                    <p key={i}>{para}</p>
                  ))}
                </div>
              </div>
            )
          })}

          <div className="terms-footer-note">
            <FaShieldAlt />
            <p>
              These Terms were last updated on 13 April 2026. If you have any questions about these Terms, please use the in-app feedback option in Settings.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
