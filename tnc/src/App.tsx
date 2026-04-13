import './App.css'

const experiments = [
  {
    emoji: '🧪',
    title: 'Gas Preparation',
    description: 'Learn the laboratory preparation of common gases. Understand apparatus setup, reactions, and collection methods.',
    phases: ['Theory', 'Build', 'Test'],
    free: true,
  },
  {
    emoji: '⚗️',
    title: 'Haber Process',
    description: 'Synthesise ammonia industrially. Explore nitrogen fixation, catalyst chemistry, and Le Chatelier\'s principle.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    emoji: '🔬',
    title: 'Ostwald Process',
    description: 'Produce nitric acid from ammonia. Understand catalytic oxidation and the industrial nitrogen cycle.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    emoji: '🧫',
    title: 'Sulfuric Acid (Contact)',
    description: 'Follow the Contact Process step-by-step. Master sulfur oxidation, gas absorption, and acid formation.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    emoji: '🏭',
    title: 'Methanol Production',
    description: 'Explore syngas chemistry and methanol synthesis. Understand the catalysts and conditions behind this key industrial feedstock.',
    phases: ['Theory', 'Build', 'Test', 'Results'],
    free: false,
  },
  {
    emoji: '🧬',
    title: 'Acid–Base Reactions',
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
    title: 'Finished the Ostwald Process! 🎉',
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
    body: 'Noticed the CaCl₂ tube in the build phase. Is it just to absorb water vapour before collection? Why does that matter for the purity test?',
    likes: 9,
    replies: 4,
    color: '#5A189A',
  },
]

function rankClass(r: number) {
  if (r === 1) return 'lb-rank gold'
  if (r === 2) return 'lb-rank silver'
  if (r === 3) return 'lb-rank bronze'
  return 'lb-rank'
}

function App() {
  return (
    <>
      {/* NAV */}
      <nav className="nav">
        <div className="nav-logo">
          <svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle cx="14" cy="14" r="14" fill="url(#ng)" />
            <path d="M9 20 L14 8 L19 20" stroke="#E6C9FF" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" />
            <path d="M10.5 16.5 H17.5" stroke="#E6C9FF" strokeWidth="1.8" strokeLinecap="round" />
            <defs>
              <linearGradient id="ng" x1="0" y1="0" x2="28" y2="28" gradientUnits="userSpaceOnUse">
                <stop stopColor="#9D4EDD" />
                <stop offset="1" stopColor="#7B2CBF" />
              </linearGradient>
            </defs>
          </svg>
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
          🧪 Industrial Chemistry, Gamified
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
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
            </svg>
            Download on App Store
          </a>
          <a href="#experiments" className="btn-secondary">
            View Experiments →
          </a>
        </div>

        {/* Mockup phones */}
        <div className="hero-mockup">
          <div className="phone-frame">
            <div className="phone-screen">
              <div className="phone-status">
                <span>9:41</span><span>●●●</span>
              </div>
              <div className="phone-greeting">Good morning 👋</div>
              <div className="phone-heading">Leaderboard</div>
              {leaderboardData.slice(0, 3).map(u => (
                <div key={u.rank} className="lb-row" style={{ padding: '10px 0', borderBottom: '1px solid rgba(58,5,88,0.4)' }}>
                  <div className={rankClass(u.rank)} style={{ fontSize: 13, width: 20 }}>
                    {u.rank === 1 ? '🥇' : u.rank === 2 ? '🥈' : '🥉'}
                  </div>
                  <div className="lb-avatar" style={{ background: u.color, width: 30, height: 30, fontSize: 13 }}>{u.initial}</div>
                  <div className="lb-name" style={{ fontSize: 12 }}>{u.name}</div>
                  <div className="lb-xp" style={{ fontSize: 11 }}>{u.xp} XP</div>
                </div>
              ))}
            </div>
          </div>

          <div className="phone-frame main">
            <div className="phone-screen">
              <div className="phone-status">
                <span>9:41</span><span>●●●</span>
              </div>
              <div className="phone-greeting">Good morning, Ansh 👋</div>
              <div className="phone-heading">Continue Learning</div>
              <div className="streak-pill">🔥 32 Day Streak</div>
              <div className="exp-card-mini">
                <div className="exp-card-mini-title">Haber Process</div>
                <div className="exp-card-mini-sub">Build Phase • Step 3 of 5</div>
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
                <div className="exp-card-mini-status locked">Locked 🔒</div>
              </div>
            </div>
          </div>

          <div className="phone-frame">
            <div className="phone-screen">
              <div className="phone-status">
                <span>9:41</span><span>●●●</span>
              </div>
              <div className="phone-greeting">Community</div>
              <div className="phone-heading">Discussions</div>
              {communityPosts.slice(0, 2).map((p, i) => (
                <div key={i} style={{ marginBottom: 10, padding: '10px 0', borderBottom: '1px solid rgba(58,5,88,0.4)' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
                    <div className="lb-avatar" style={{ background: p.color, width: 26, height: 26, fontSize: 11 }}>{p.initial}</div>
                    <span style={{ fontSize: 11, fontWeight: 700, color: '#E6C9FF' }}>{p.name}</span>
                  </div>
                  <div style={{ fontSize: 12, fontWeight: 600, color: '#c9a8f0', marginBottom: 4 }}>{p.title}</div>
                  <div style={{ fontSize: 10, color: '#7a5e96' }}>💬 {p.replies} replies · ❤️ {p.likes}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* STATS */}
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
            <div className="stat-num">∞</div>
            <div className="stat-label">Daily Streaks</div>
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
              { icon: '🧪', title: 'Interactive Experiments', desc: 'Step through Theory → Build → Test → Results for each industrial process. Learn by doing, not memorising.' },
              { icon: '📱', title: '3D Molecular Models', desc: 'Rotate and explore USDZ 3D models of key molecules and industrial apparatus directly in AR on your iPhone.' },
              { icon: '🔥', title: 'Daily Streak System', desc: 'Build consistency with daily learning streaks. Track your calendar, hit milestones, and earn streak badges.' },
              { icon: '🏆', title: 'Global Leaderboard', desc: 'Compete with learners worldwide. Earn XP from experiments and tests. Weekly and all-time rankings.' },
              { icon: '👥', title: 'Community Forums', desc: 'Ask questions, share insights, and help others. Topic-specific communities for every experiment.' },
              { icon: '👑', title: 'Premium Content', desc: 'Unlock all experiments and advanced content with a Premium subscription. Cancel anytime.' },
            ].map(f => (
              <div className="feature-card" key={f.title}>
                <div className="feature-icon">{f.icon}</div>
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
                  <div className="exp-emoji">{e.emoji}</div>
                  <div className={`exp-badge ${e.free ? 'free' : 'premium'}`}>
                    {e.free ? '✓ Free' : '★ Premium'}
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
          <p className="section-sub" style={{ margin: '0 auto 0' }}>Earn XP from experiments and tests. Weekly resets keep it competitive for everyone.</p>
          <div className="lb-preview">
            <div className="lb-header">
              <span style={{ fontSize: 20 }}>🏆</span>
              <h3>Top Chemists</h3>
              <div className="lb-tab active">Weekly</div>
              <div className="lb-tab">All Time</div>
            </div>
            <div className="lb-rows">
              {leaderboardData.map(u => (
                <div className="lb-row" key={u.rank}>
                  <div className={rankClass(u.rank)}>
                    {u.rank === 1 ? '🥇' : u.rank === 2 ? '🥈' : u.rank === 3 ? '🥉' : u.rank}
                  </div>
                  <div className="lb-avatar" style={{ background: u.color }}>{u.initial}</div>
                  <div className="lb-name">{u.name}</div>
                  <div className="lb-streak">🔥 {u.streak}d</div>
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
          <p className="section-sub" style={{ margin: '0 auto 0' }}>Start free. Upgrade when you're ready to go deeper.</p>
          <div className="premium-cards">
            <div className="plan-card">
              <div className="plan-badge free-badge">✓ Free</div>
              <div className="plan-name">Starter</div>
              <div className="plan-price">$0<span> / month</span></div>
              <ul className="plan-features">
                <li>Gas Preparation experiment</li>
                <li>Theory & Build phases</li>
                <li>Global Leaderboard access</li>
                <li>Community Forums</li>
                <li>Daily streak tracking</li>
                <li className="dim">All 6 experiments</li>
                <li className="dim">Premium experiments</li>
                <li className="dim">3D AR models</li>
              </ul>
              <a href="#download" className="plan-btn free-btn">Download Free</a>
            </div>
            <div className="plan-card highlighted">
              <div className="plan-badge premium-badge">★ Premium</div>
              <div className="plan-name">Premium</div>
              <div className="plan-price">$4.99<span> / month</span></div>
              <ul className="plan-features">
                <li>All 6 experiments</li>
                <li>Theory, Build, Test & Results</li>
                <li>3D AR molecular models</li>
                <li>Global Leaderboard access</li>
                <li>Community Forums</li>
                <li>Daily streak tracking</li>
                <li>Badge collection</li>
                <li>Priority new content</li>
              </ul>
              <a href="#download" className="plan-btn premium-btn">
                👑 Unlock Premium
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
                  <span>❤️ {p.likes}</span>
                  <span>💬 {p.replies} replies</span>
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
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
            </svg>
            Download on the App Store
          </a>
        </div>
      </section>

      {/* FOOTER */}
      <footer>
        <div className="footer-inner">
          <div className="footer-logo">⚗️ The Industrial Chemist</div>
          <ul className="footer-links">
            <li><a href="#features">Features</a></li>
            <li><a href="#experiments">Experiments</a></li>
            <li><a href="#leaderboard">Leaderboard</a></li>
            <li><a href="#premium">Premium</a></li>
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#">Terms of Service</a></li>
          </ul>
          <p className="footer-copy">© 2026 The Industrial Chemist. All rights reserved.</p>
        </div>
      </footer>
    </>
  )
}

export default App
