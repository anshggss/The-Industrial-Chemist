import { useNavigate } from 'react-router-dom'
import {
  FaApple,
  FaTrophy,
  FaUsers,
  FaCrown,
  FaFire,
  FaMicroscope,
  FaFlask,
  FaIndustry,
  FaAtom,

  FaVial,
  FaArrowRight,
  FaCheck,
  FaTimes,
  FaMedal,
} from 'react-icons/fa'
import {
  GiChemicalDrop,
  GiFactory,
  GiMolecule,
} from 'react-icons/gi'

import { MdLeaderboard, MdViewInAr } from 'react-icons/md'
import './App.css'

const experiments = [
  {
    Icon: FaVial,
    title: 'Gas Preparation',
    description: 'Learn the laboratory preparation of common gases. Understand apparatus setup, reactions, and collection methods.',
    phases: ['Theory', 'Build', 'Test'],
    free: true,
  },
  {
    Icon: GiChemicalDrop,
    title: 'Haber Process',
    description: "Synthesise ammonia industrially. Explore nitrogen fixation, catalyst chemistry, and Le Chatelier's principle.",
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    Icon: FaMicroscope,
    title: 'Ostwald Process',
    description: 'Produce nitric acid from ammonia. Understand catalytic oxidation and the industrial nitrogen cycle.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    Icon: FaFlask,
    title: 'Sulfuric Acid (Contact)',
    description: 'Follow the Contact Process step-by-step. Master sulfur oxidation, gas absorption, and acid formation.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    Icon: GiFactory,
    title: 'Methanol Production',
    description: 'Explore syngas chemistry and methanol synthesis. Understand the catalysts and conditions behind this key industrial feedstock.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    Icon: FaAtom,
    title: 'Acid-Base Reactions',
    description: 'Investigate neutralisation, titration, and buffer chemistry through guided interactive experiments.',
    phases: ['Theory', 'Build', 'Test'],
    free: false,
  },
]

const leaderboardData = [
  { rank: 1, initial: 'A', name: 'Ansh T.', xp: 4820, streak: 32, color: '#9D4EDD' },
  { rank: 2, initial: 'D', name: 'Diya S.', xp: 4110, streak: 27, color: '#7B2CBF' },
  { rank: 3, initial: 'P', name: 'Priya M.', xp: 3980, streak: 21, color: '#5A189A' },
  { rank: 4, initial: 'R', name: 'Rohit K.', xp: 3650, streak: 15, color: '#3C096C' },
  { rank: 5, initial: 'A', name: 'Anika P.', xp: 3420, streak: 12, color: '#240046' },
]

const communityPosts = [
  {
    initial: 'A',
    name: 'Anushka A.',
    time: '2 hrs ago',
    title: 'Tips for the Haber Process quiz?',
    body: 'Just finished the Theory section — the catalyst optimum temperature question tripped me up. Anyone have a good way to remember the conditions?',
    likes: 14,
    replies: 7,
    color: '#9D4EDD',
  },
  {
    initial: 'R',
    name: 'Ravi B.',
    time: '5 hrs ago',
    title: 'Finished the Ostwald Process!',
    body: 'Got 100% on the test after only 2 tries. The 3D model of the catalytic converter really helped me visualise the reaction chamber.',
    likes: 28,
    replies: 11,
    color: '#7B2CBF',
  },
  {
    initial: 'S',
    name: 'Sara L.',
    time: '1 day ago',
    title: 'Gas Preparation — what does the drying agent do?',
    body: 'Noticed the CaCl2 tube in the build phase. Is it just to absorb water vapour before collection? Why does that matter for the purity test?',
    likes: 9,
    replies: 4,
    color: '#5A189A',
  },
]

function rankMedal(r: number) {
  if (r === 1) return <FaMedal style={{ color: '#FFD700' }} />
  if (r === 2) return <FaMedal style={{ color: '#b0b0b0' }} />
  if (r === 3) return <FaMedal style={{ color: '#cd7f32' }} />
  return <span style={{ color: 'var(--text-dim)', fontWeight: 800, fontSize: 13 }}>{r}</span>
}

export default function App() {
  const navigate = useNavigate()

  return (
    <>
      {/* NAV */}
      <nav className="nav">
        <div className="nav-logo">
          <GiMolecule />
          The Industrial Chemist
        </div>
        <ul className="nav-links">
          <li><a href="#features">Features</a></li>
          <li><a href="#experiments">Experiments</a></li>
          <li><a href="#leaderboard">Leaderboard</a></li>
          <li><a href="#premium">Premium</a></li>
          <li><a href="#download" className="nav-cta">Download</a></li>
        </ul>
      </nav>

      {/* HERO */}
      <section className="hero">
        <div className="hero-glow" />
        <div className="hero-badge">
          <FaFlask /> Industrial Chemistry, Gamified
        </div>
        <h1>
          Learn Chemistry<br />
          <span>Through Doing</span>
        </h1>
        <p className="hero-sub">
          Master Haber, Ostwald, Contact, and more — through interactive experiments, 3D models, and daily streaks. Built for curious minds.
        </p>
        <div className="hero-buttons">
          <a href="#download" className="btn-primary">
            <FaApple />
            Download on App Store
          </a>
          <a href="#experiments" className="btn-secondary">
            View Experiments <FaArrowRight />
          </a>
        </div>

        {/* Phone mockups */}
        <div className="hero-mockup">
          {/* Leaderboard screen */}
          <div className="phone-frame">
            <div className="phone-screen">
              <div className="phone-status"><span>9:41</span><span>●●●</span></div>
              <div className="phone-greeting">Good morning</div>
              <div className="phone-heading">Leaderboard</div>
              {leaderboardData.slice(0, 3).map(u => (
                <div key={u.rank} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '9px 0', borderBottom: '1px solid rgba(58,5,88,0.4)' }}>
                  <div style={{ width: 20, display: 'flex', justifyContent: 'center', fontSize: 14 }}>{rankMedal(u.rank)}</div>
                  <div className="lb-avatar" style={{ background: u.color, width: 28, height: 28, fontSize: 12 }}>{u.initial}</div>
                  <div className="lb-name" style={{ fontSize: 12 }}>{u.name}</div>
                  <div className="lb-xp" style={{ fontSize: 11 }}>{u.xp} XP</div>
                </div>
              ))}
            </div>
          </div>

          {/* Home screen */}
          <div className="phone-frame main">
            <div className="phone-screen">
              <div className="phone-status"><span>9:41</span><span>●●●</span></div>
              <div className="phone-greeting">Good morning, Ansh</div>
              <div className="phone-heading">Continue Learning</div>
              <div className="streak-pill"><FaFire style={{ color: 'var(--gold)' }} /> 32 Day Streak</div>
              <div className="exp-card-mini">
                <div className="exp-card-mini-title">Haber Process</div>
                <div className="exp-card-mini-sub">Build Phase · Step 3 of 5</div>
                <div className="progress-bar-wrap">
                  <div className="progress-bar-fill" style={{ width: '60%' }} />
                </div>
                <div className="exp-card-mini-status">In Progress</div>
              </div>
              <div className="exp-card-mini">
                <div className="exp-card-mini-title">Ostwald Process</div>
                <div className="exp-card-mini-sub">Locked — Complete Haber first</div>
                <div className="progress-bar-wrap">
                  <div className="progress-bar-fill" style={{ width: '0%' }} />
                </div>
                <div className="exp-card-mini-status locked">Locked</div>
              </div>
            </div>
          </div>

          {/* Community screen */}
          <div className="phone-frame">
            <div className="phone-screen">
              <div className="phone-status"><span>9:41</span><span>●●●</span></div>
              <div className="phone-greeting">Community</div>
              <div className="phone-heading">Discussions</div>
              {communityPosts.slice(0, 2).map((p, i) => (
                <div key={i} style={{ marginBottom: 10, padding: '9px 0', borderBottom: '1px solid rgba(58,5,88,0.4)' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 5 }}>
                    <div className="lb-avatar" style={{ background: p.color, width: 24, height: 24, fontSize: 10 }}>{p.initial}</div>
                    <span style={{ fontSize: 11, fontWeight: 700, color: '#E6C9FF' }}>{p.name}</span>
                  </div>
                  <div style={{ fontSize: 11, fontWeight: 600, color: '#c9a8f0', marginBottom: 4, lineHeight: 1.3 }}>{p.title}</div>
                  <div style={{ fontSize: 10, color: '#7a5e96', display: 'flex', gap: 8 }}>
                    <span>{p.replies} replies</span><span>{p.likes} likes</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* STATS STRIP */}
      <div className="stats-strip">
        <div className="stats-grid">
          <div>
            <div className="stat-num">6<span>+</span></div>
            <div className="stat-label">Industrial Experiments</div>
          </div>
          <div>
            <div className="stat-num">3<span>D</span></div>
            <div className="stat-label">Interactive Models</div>
          </div>
          <div>
            <div className="stat-num">365</div>
            <div className="stat-label">Days of Content</div>
          </div>
          <div>
            <div className="stat-num">1<span>st</span></div>
            <div className="stat-label">Chemistry App of Its Kind</div>
          </div>
        </div>
      </div>

      {/* FEATURES */}
      <section className="features" id="features">
        <div className="container">
          <div className="section-label">Features</div>
          <h2 className="section-title">Everything you need to master<br />industrial chemistry</h2>
          <p className="section-sub">From guided theory to hands-on virtual builds and knowledge tests — all in one app.</p>
          <div className="features-grid">
            {[
              { Icon: GiChemicalDrop, title: 'Interactive Experiments', desc: 'Step through Theory, Build, Test, and Results for each industrial process. Learn by doing, not memorising.' },
              { Icon: MdViewInAr, title: '3D Molecular Models', desc: 'Rotate and explore USDZ 3D models of key molecules and industrial apparatus directly in AR on your iPhone.' },
              { Icon: FaFire, title: 'Daily Streak System', desc: 'Build consistency with daily learning streaks. Track your calendar, hit milestones, and earn streak badges.' },
              { Icon: MdLeaderboard, title: 'Global Leaderboard', desc: 'Compete with learners worldwide. Earn XP from experiments and tests. Weekly and all-time rankings.' },
              { Icon: FaUsers, title: 'Community Forums', desc: 'Ask questions, share insights, and help others. Topic-specific communities for every experiment.' },
              { Icon: FaCrown, title: 'Premium Content', desc: 'Unlock all experiments and advanced content with a Premium subscription. Cancel anytime.' },
            ].map(f => (
              <div className="feature-card" key={f.title}>
                <div className="feature-icon"><f.Icon /></div>
                <h3>{f.title}</h3>
                <p>{f.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* EXPERIMENTS */}
      <section className="experiments" id="experiments">
        <div className="container">
          <div className="section-label">Experiments</div>
          <h2 className="section-title">Six industrial processes,<br />fully interactive</h2>
          <p className="section-sub">Each experiment walks you through the real industrial chemistry — at your own pace.</p>
          <div className="experiments-grid">
            {experiments.map(e => (
              <div className="exp-card" key={e.title}>
                <div className="exp-card-top">
                  <div className="exp-icon-wrap"><e.Icon /></div>
                  <div className={`exp-badge ${e.free ? 'free' : 'premium'}`}>
                    {e.free ? <><FaCheck /> Free</> : <><FaCrown /> Premium</>}
                  </div>
                </div>
                <h3>{e.title}</h3>
                <p>{e.description}</p>
                <div className="exp-phases">
                  {e.phases.map(p => (
                    <div className="phase-chip" key={p}>{p}</div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* HOW IT WORKS */}
      <section className="how" id="how">
        <div className="container">
          <div className="section-label">How it works</div>
          <h2 className="section-title">Learn, build, test, repeat</h2>
          <p className="section-sub">Every experiment follows the same structured flow — so you always know where you are.</p>
          <div className="steps">
            {[
              { n: '1', title: 'Read the Theory', desc: 'Start with the science. Understand the reactions, conditions, and industrial significance before touching anything.' },
              { n: '2', title: 'Build the Setup', desc: 'Virtually assemble the apparatus step by step. The 3D models show you exactly how each component connects.' },
              { n: '3', title: 'Run the Experiment', desc: 'Walk through the process interactively. Observe what happens at each stage and why.' },
              { n: '4', title: 'Take the Test', desc: 'Answer questions on what you just learned. Earn XP, climb the leaderboard, and extend your streak.' },
            ].map(s => (
              <div className="step" key={s.n}>
                <div className="step-num">{s.n}</div>
                <h3>{s.title}</h3>
                <p>{s.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* LEADERBOARD */}
      <section className="leaderboard-section" id="leaderboard">
        <div className="container" style={{ textAlign: 'center' }}>
          <div className="section-label" style={{ justifyContent: 'center' }}>Leaderboard</div>
          <h2 className="section-title">Compete with the best</h2>
          <p className="section-sub" style={{ margin: '0 auto' }}>Earn XP from experiments and tests. Weekly resets keep it competitive for everyone.</p>
          <div className="lb-preview">
            <div className="lb-header">
              <FaTrophy style={{ color: 'var(--gold)', fontSize: 22 }} />
              <h3>Top Chemists</h3>
              <div className="lb-tab active">Weekly</div>
              <div className="lb-tab">All Time</div>
            </div>
            <div className="lb-rows">
              {leaderboardData.map(u => (
                <div className="lb-row" key={u.rank}>
                  <div className="lb-rank" style={{ display: 'flex', justifyContent: 'center', width: 28 }}>{rankMedal(u.rank)}</div>
                  <div className="lb-avatar" style={{ background: u.color }}>{u.initial}</div>
                  <div className="lb-name">{u.name}</div>
                  <div className="lb-streak"><FaFire style={{ display: 'inline', marginRight: 3 }} />{u.streak}d</div>
                  <div className="lb-xp">{u.xp.toLocaleString()} XP</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* PREMIUM */}
      <section className="premium" id="premium">
        <div className="container" style={{ textAlign: 'center' }}>
          <div className="section-label" style={{ justifyContent: 'center' }}>Premium</div>
          <h2 className="section-title">Unlock everything</h2>
          <p className="section-sub" style={{ margin: '0 auto' }}>Start free. Upgrade when you're ready to go deeper.</p>
          <div className="premium-cards">
            {/* Free */}
            <div className="plan-card">
              <div className="plan-badge free-badge"><FaCheck /> Free</div>
              <div className="plan-name">Starter</div>
              <div className="plan-price">$0<span> / month</span></div>
              <ul className="plan-features">
                {[
                  { text: 'Gas Preparation experiment', ok: true },
                  { text: 'Theory & Build phases', ok: true },
                  { text: 'Global Leaderboard access', ok: true },
                  { text: 'Community Forums', ok: true },
                  { text: 'Daily streak tracking', ok: true },
                  { text: 'All 6 experiments', ok: false },
                  { text: 'Premium experiments', ok: false },
                  { text: '3D AR models', ok: false },
                ].map(item => (
                  <li key={item.text} className={item.ok ? '' : 'dim'}>
                    {item.ok ? <FaCheck /> : <FaTimes />} {item.text}
                  </li>
                ))}
              </ul>
              <a href="#download" className="plan-btn free-btn">Download Free</a>
            </div>

            {/* Premium */}
            <div className="plan-card highlighted">
              <div className="plan-badge premium-badge"><FaCrown /> Premium</div>
              <div className="plan-name">Premium</div>
              <div className="plan-price">$4.99<span> / month</span></div>
              <ul className="plan-features">
                {[
                  'All 6 experiments',
                  'Theory, Build, Test & Results',
                  '3D AR molecular models',
                  'Global Leaderboard access',
                  'Community Forums',
                  'Daily streak tracking',
                  'Badge collection',
                  'Priority new content',
                ].map(text => (
                  <li key={text}><FaCheck /> {text}</li>
                ))}
              </ul>
              <a href="#download" className="plan-btn premium-btn">
                <FaCrown /> Unlock Premium
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* COMMUNITY */}
      <section className="community">
        <div className="container">
          <div className="section-label">Community</div>
          <h2 className="section-title">Learn together</h2>
          <p className="section-sub">Ask questions, share discoveries, and help fellow chemists understand the tricky bits.</p>
          <div className="community-preview">
            {communityPosts.map((p, i) => (
              <div className="post-card" key={i}>
                <div className="post-author">
                  <div className="post-avatar" style={{ background: p.color }}>{p.initial}</div>
                  <div className="post-author-info">
                    <div className="name">{p.name}</div>
                    <div className="time">{p.time}</div>
                  </div>
                </div>
                <div className="post-title">{p.title}</div>
                <div className="post-body">{p.body}</div>
                <div className="post-footer">
                  <span>{p.likes} likes</span>
                  <span>{p.replies} replies</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="cta" id="download">
        <div className="cta-glow" />
        <div className="container" style={{ position: 'relative' }}>
          <h2>Ready to become an<br />Industrial Chemist?</h2>
          <p>Download free today. No credit card required. Start with Gas Preparation and see how far you go.</p>
          <a href="#" className="appstore-btn">
            <FaApple />
            Download on the App Store
          </a>
        </div>
      </section>

      {/* FOOTER */}
      <footer>
        <div className="footer-inner">
          <div className="footer-logo"><FaIndustry /> The Industrial Chemist</div>
          <ul className="footer-links">
            <li><a href="#features">Features</a></li>
            <li><a href="#experiments">Experiments</a></li>
            <li><a href="#leaderboard">Leaderboard</a></li>
            <li><a href="#premium">Premium</a></li>
            <li><a href="#" onClick={e => { e.preventDefault(); navigate('/terms&conditions') }}>Terms &amp; Conditions</a></li>
            <li><a href="#">Privacy Policy</a></li>
          </ul>
          <p className="footer-copy">© 2026 The Industrial Chemist. All rights reserved.</p>
        </div>
      </footer>
    </>
  )
}
