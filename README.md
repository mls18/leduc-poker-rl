# Leduc Poker with Reinforcement Learning

A MATLAB implementation of Leduc Poker featuring a graphical user interface and reinforcement learning AI opponents. This project allows users to play against AI agents that learn through Q-learning, or train new AI models from scratch.


## Overview

Leduc Poker is a simplified poker variant designed for AI research and game theory studies. This implementation includes:
- A complete game engine following standard Leduc Poker rules
- An interactive GUI built with MATLAB App Designer
- Q-learning based AI agents that learn optimal strategies through self-play
- Training interface with real-time progress tracking
- Save/load functionality for trained models

## Features

### Gameplay
- **Play Against AI**: Challenge trained or untrained AI opponents
- **Interactive Interface**: User-friendly graphical interface with clear game state visualization
- **Real-time Feedback**: See AI decisions and game progression in real-time
- **Multiple Games**: Play consecutive games and track chip counts

### AI Training
- **Self-Play Training**: Train AI agents through thousands of games
- **Progress Tracking**: Real-time statistics including win rates and training progress
- **Adjustable Parameters**: Configure learning rate, exploration rate, and training duration
- **Model Persistence**: Save and load trained models for future games

### User Interface
- **Main Menu**: Easy navigation between play, training, and settings
- **Game Display**: Visual representation of cards, chips, and pot
- **Status Updates**: Clear feedback on game state and actions
- **Training Dashboard**: Comprehensive training metrics and controls

## Game Rules

Leduc Poker is played with a simplified 6-card deck:
- **Deck**: 2 Jacks, 2 Queens, 2 Kings
- **Players**: 2 players (Human vs AI)
- **Starting Chips**: 20 chips per player (configurable)

### Game Flow

1. **Ante**: Each player antes 1 chip (blind bet)
2. **Pre-Flop Round**:
   - Each player receives one private card
   - First betting round (bet size: 2 chips)
   - Maximum of 2 raises per round
3. **Flop Round**:
   - One community card is revealed
   - Second betting round (bet size: 4 chips)
   - Maximum of 2 raises per round
4. **Showdown**:
   - If both players remain, cards are revealed
   - Winner determined by best hand

### Hand Rankings
1. **Pair**: Private card matches community card (highest)
2. **High Card**: King > Queen > Jack (if no pairs)

### Actions
- **Check/Call**: Match current bet or check if no bet
- **Bet/Raise**: Increase the bet by the fixed amount
- **Fold**: Forfeit the hand and lose chips in pot

## Installation

### Prerequisites
- MATLAB R2020b or later
- MATLAB App Designer

### Setup

1. **Clone the repository**:
```bash
   git clone https://github.com/yourusername/leduc-poker-rl.git
   cd leduc-poker-rl
```
2. Open MATLAB and navigate to the project directory
3. Add project to path (if needed):
```matlab
addpath(genpath('path/to/leduc-poker-rl'))
```
4. Run the application

## Usage
### Playing Against AI

- Launch the application
- Click "Play Against AI" from the main menu
- Click "New Game" to start
- View your card and make decisions:

1. Check/Call: Match opponent's bet
2. Bet/Raise: Increase the bet
3. Fold: Give up the hand


Play continues through Pre-Flop and Flop rounds
Winner is determined and chips are distributed

### Training AI

- Click "Train AI" from the main menu
- Enter the number of training games (recommended: 1000-10000)
- (Optional) Adjust learning parameters
- Click "Start Training"
- Monitor progress with real-time statistics
- Training can be stopped at any time
- Once complete, the trained model is ready for gameplay

## AI Training
## Q-Learning Algorithm
The AI uses Q-learning with the following parameters:

- Learning Rate (α): 0.1 (default) - How quickly the AI learns from new experiences
- Discount Factor (γ): 0.9 (default) - How much future rewards are valued
- Exploration Rate (ε): 0.3 (training) / 0.05 (gameplay) - Probability of random actions

## State Representation
The game state is encoded as a vector containing:

- Number of chips in pot
- Player's chip count
- Opponent's chip count
- Current round (Pre-Flop/Flop)
- Community card value (if revealed)
- Current bet amounts
- Position information

## Training Process

Two AI agents play against each other
Each agent maintains a Q-table mapping states to action values
After each game, Q-values are updated based on outcomes
Exploration rate gradually decreases over training
Agents learn optimal betting strategies through trial and error

## Training Tips

-Short Training (100-1000 games): Quick baseline, basic strategies
- Medium Training (1000-5000 games): Improved play, reasonable decisions
-Long Training (5000-10000+ games): Advanced strategies, near-optimal play

### Technical Details
## Game State Management
The game uses a state-based system tracking:

- Current betting round (Pre-Flop/Flop)
- Number of raises in current round
- Bet amounts for each player
- Community card status
- Turn order

## Action Processing
Actions are processed through:

## Validation of legal actions
- Chip transfer from player to pot
- State update
- Opponent response
- Round progression or showdown

## Q-Table Structure
The Q-table uses:

- Keys: String representation of game states
- Values: Arrays of Q-values for each action [Check/Call, Bet/Raise, Fold]
- Storage: MATLAB containers.Map for efficient lookup

## Requirements
Software:

MATLAB R2020b or later
App Designer (included with MATLAB)

Toolboxes:

None required (base MATLAB only)

## License

This project is licensed under the MIT License - see the LICENSE
 file for details.

## Author

Maria Luisa Scarpa
PhD in Control Theory (Dynamical Systems, Optimal Control, Game Theory)
Background: Aeronautical Engineering
LinkedIn: [My profile](https://www.linkedin.com/in/maria-luisa-scarpa-2000/)
Email: [scarpa.mari@gmail.com/ mls18@ic.ac.uk]
  
