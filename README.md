# Capture-the-Flag PDDL Domain

This project defines a **non-deterministic Capture the Flag domain in PDDL**, modeling agents, teams, flags, tagging mechanics, portals, and environmental effects such as fog. The domain is designed to explore planning under uncertainty, conditional effects, and action costs.

## Overview

**Goal:**  
Model a capture-the-flag style game where agents move across a field, steal enemy flags, avoid being tagged, and return flags to their base to win.

The domain supports:
- Non-deterministic outcomes (e.g., tagging success, portals)
- Conditional effects (e.g., dropping flags when tagged)
- Action costs for plan optimization
- Multi-agent interactions across opposing teams

## Domain Features

### Types
- `agent`
- `location`
- `flag`
- `team`

### Key Predicates
- `at(agent, location)` — agent location
- `connected(location, location)` — movement graph
- `flag-at(flag, location)` — flag position
- `holding(agent, flag)` — agent carrying a flag
- `tagged(agent)` / `maybe-tagged(agent)` — tagging state
- `member-of(agent, team)` — team membership
- `safe-zone(team, location)` — zones where flags cannot be stolen
- `portal(location)` — teleportation points
- `flag-captured(team)` — winning condition

### Cost Function
- `total-cost` — tracks cumulative action cost for planning optimization

## Actions

### Movement
- **`move`**  
  Agents move between connected locations if they are not tagged or maybe-tagged.

### Tagging Mechanics
- **`tag`**  
  Opposing agents can tag players with non-deterministic outcomes:
  - Player may become fully tagged
  - Tag attempt may fail  
  If a tagged player is holding a flag, it is returned to its base.

- **`untag`**  
  Teammates can untag each other when at the same location.

### Flag Interaction
- **`pickup-flag`**  
  Agents may steal enemy flags when not in a safe zone.

- **`capture-flag`**  
  Flags are captured by returning them to the agent’s own base, triggering a win condition.

### Environmental Effects
- **`fog-covers-field`**  
  Resets tagging uncertainty by applying `maybe-tagged` to all untagged agents.

- **`fall-into-portal`**  
  Agents entering a portal are teleported to a random location:
  - Safe portals preserve status
  - Unsafe portals reset `maybe-tagged`

## Planning Characteristics

- **Non-determinism:**  
  Implemented using `oneof` for tagging and portal outcomes.
- **Conditional effects:**  
  Used to return flags automatically when a player is tagged.
- **Optimization-ready:**  
  Action costs enable cost-aware planners.

## Requirements

The domain uses the following PDDL features:
- `:adl`
- `:conditional-effects`
- `:negative-preconditions`
- `:non-deterministic`
- `:action-costs`
- `:typing`
- `:equality`

## Usage

This domain can be used with planners that support **non-deterministic PDDL** and **action costs**, such as:
- ND planners
- Contingent planners
- Planning-as-model-checking frameworks

Pair this domain with a compatible problem file defining:
- Agents and teams
- Field layout and connectivity
- Initial flag and agent positions
- Goal conditions (e.g., `flag-captured`)
