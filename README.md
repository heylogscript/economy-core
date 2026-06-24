# EconomyCore

A **server-authoritative economy and save module** for Roblox idle/tycoon games. Session-locking DataStore, passive income generators, offline earnings with hard cap, upgrades, and prestige with global multiplier.

## Systems

- **Session Locking** — Atomic `UpdateAsync` lock embedded in player data. Stale timeout with exponential backoff retries. Heartbeat every 15s.
- **Passive Income** — Per-second income tick from owned generators. Scales with upgrade multipliers, prestige level, and global prestige pool.
- **Offline Income Cap** — Hard 7200s (2h) cap on rejoining players. Excess time yields zero income. Denied amount logged per session.
- **Generators** — 8 tiers with exponential cost scaling (`baseCost * 1.15^owned`). Each unit adds its base rate to income.
- **Upgrades** — 9 permanent upgrades: 8 per-generator 2x-3x boosts + 1 global 1.5x multiplier. Server-validated one-time purchases.
- **Prestige** — Resets generators and upgrades. Adds +10% personal multiplier per level. Contributes +1% to global multiplier for all players.
- **Global Prestige Pool** — Shared DataStore counter. Every prestige from any server increments the pool. All players share the resulting multiplier.
- **Auto-Save** — Periodic save every 60s with last-known income rate for offline calculation.

## Architecture

| Module | Role |
|---|---|
| `Config` | Central constants: rates, costs, caps, intervals |
| `SaveManager` | DataStore load/save, atomic session lock, offline income, heartbeat |
| `Generators` | Generator definitions, cost formula, getter |
| `Upgrades` | Upgrade definitions, targets, multipliers |
| `PrestigeManager` | Prestige purchase, reset, global pool I/O |
| `EconomyService` | Main orchestrator: lifecycle, remotes, income loop, auto-save |
| `EconomyClient` | Client API: data poll, purchase fire, update listener |
| `EconomyGUI` | Client UI: currency display, generator/upgrade tabs, prestige button |

## Tech

- **Language:** Luau
- **Engine:** Roblox
- **Build:** Rojo (`default.project.json`)
- **Pattern:** Modular service architecture, server-authoritative
