# The Industrial Chemist

An iOS learning app that lets students explore industrial chemistry processes through interactive, step-by-step virtual experiments. The app pairs each experiment with a companion marketing website built in React.

---

## Overview

The Industrial Chemist turns complex industrial chemistry into an engaging, gamified experience. Users progress through real-world processes — from gas preparation to the Haber and Ostwald processes — by following a structured four-phase experiment flow: **Theory → Build → Test → Results**. Each completed experiment earns XP, which fuels a live leaderboard and a six-tier division system.

---

## Features

### Experiments
Each experiment is broken into structured phases:
- **Theory** — background reading and reaction equations
- **Build** — interactive apparatus assembly
- **Test** — virtual experiment execution
- **Results** — outcome analysis and scoring

Experiments available:
| Experiment | Tier |
|---|---|
| Gas Preparation | Free |
| Haber Process (Ammonia) | Premium |
| Ostwald Process (Nitric Acid) | Premium |
| Contact Process (Sulfuric Acid) | Premium |
| Methanol Production | Premium |

3D USDZ models are embedded for key molecules and apparatus (ammonia, methanol, sulfuric acid, Ostwald reactor).

### Gamification
- **XP System** — earn 100 XP per completed experiment (one-time, no duplicates)
- **Streaks** — daily activity streak tracked with a calendar view
- **Divisions** — six tiers based on total XP: Bronze → Silver → Gold → Platinum → Diamond → Master
- **Leaderboard** — weekly and all-time rankings pulled live from Firestore

### Authentication & Profiles
- Email/password sign-up and login via Firebase Auth
- Forgot password and change password flows
- Editable profile with avatar, display name, and stats

### Community
- Create and join communities
- Post and view community content

### Subscription
- Free tier with access to Gas Preparation
- Premium subscription (via StoreKit) unlocks all remaining experiments

### Onboarding
- Four-screen onboarding flow shown on first launch

---

## Tech Stack

| Layer | Technology |
|---|---|
| iOS App | Swift, UIKit (XIBs + Storyboards) |
| Backend | Firebase Auth, Cloud Firestore |
| In-App Purchase | StoreKit |
| 3D Models | USDZ (AR Quick Look) |
| Website | React, TypeScript, Vite |

---

## Project Structure

```
The-Industrial-Chemist/
├── The Industrial Chemist/          # iOS app
│   ├── Controllers/
│   │   ├── Auth/                    # Login, sign-up, password reset
│   │   ├── Community/               # Community feed and posts
│   │   ├── Core/                    # Tab bar, modules, subscription
│   │   ├── Experiments/             # Theory, Build, Test, Results screens
│   │   ├── Home/                    # Home screen and tab bar
│   │   ├── Leaderboard/             # Weekly and all-time rankings
│   │   ├── Onboarding/              # First-launch onboarding
│   │   ├── Profile/                 # User profile and settings
│   │   └── Settings/                # Notifications, privacy, data
│   ├── Models/                      # Data models and service managers
│   ├── Extensions/                  # Reusable cells and UI helpers
│   └── 3D Models/                   # USDZ assets
└── tnc/                             # Marketing website (React + Vite)
```

---

## Contributors

- **Ansh Mani Tripathi**
- **Anushka Agarwal**
- **Diya Sharma**
