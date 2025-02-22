import React, { useState, useEffect, useCallback, useRef, useImperativeHandle, forwardRef } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, SafeAreaView, Animated } from 'react-native';
import { Stack } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Audio } from 'expo-av';

export const unstable_settings = {
  // Ensure that reloading on `/modal` keeps a back button present.
  initialRouteName: "index",
};

// Add this component at the top level, before the Page component
const DiceDot = () => (
  <View style={styles.dot} />
);

// Add these dot layout components
const DiceOne = () => (
  <View style={styles.diceFace}>
    <DiceDot />
  </View>
);

const DiceTwo = () => (
  <View style={styles.diceFace}>
    <View style={[styles.diceColumn, styles.spaceBetween]}>
      <DiceDot />
      <DiceDot />
    </View>
  </View>
);

const DiceThree = () => (
  <View style={styles.diceFace}>
    <View style={[styles.diceColumn, styles.spaceEvenly]}>
      <DiceDot />
      <DiceDot />
      <DiceDot />
    </View>
  </View>
);

const DiceFour = () => (
  <View style={styles.diceFace}>
    <View style={[styles.diceRow, styles.spaceBetween]}>
      <View style={[styles.diceColumn, styles.spaceBetween]}>
        <DiceDot />
        <DiceDot />
      </View>
      <View style={[styles.diceColumn, styles.spaceBetween]}>
        <DiceDot />
        <DiceDot />
      </View>
    </View>
  </View>
);

const DiceFive = () => (
  <View style={styles.diceFace}>
    {/* Corner dots */}
    <View style={[styles.diceRow, styles.spaceBetween]}>
      <View style={[styles.diceColumn, styles.spaceBetween]}>
        <DiceDot />
        <DiceDot />
      </View>
      <View style={[styles.diceColumn, styles.spaceBetween]}>
        <DiceDot />
        <DiceDot />
      </View>
    </View>
    {/* Center dot */}
    <View style={[styles.centerDot, { 
      left: DICE_SIZE / 2,
      top: DICE_SIZE / 2,
    }]}>
      <DiceDot />
    </View>
  </View>
);

const DiceSix = () => (
  <View style={styles.diceFace}>
    <View style={[styles.diceRow, styles.spaceBetween]}>
      <View style={[styles.diceColumn, styles.spaceEvenly]}>
        <DiceDot />
        <DiceDot />
        <DiceDot />
      </View>
      <View style={[styles.diceColumn, styles.spaceEvenly]}>
        <DiceDot />
        <DiceDot />
        <DiceDot />
      </View>
    </View>
  </View>
);

const DICE_SIZE = 100;  // Size of the cube faces

// Add this near the top of the file, with other constants
const WINNING_SCORE = 100;

// Create a stable button component outside the main component
const RollButton = React.memo(forwardRef(({ onPress }, ref) => {
  const [opacity, setOpacity] = useState(1);

  useImperativeHandle(ref, () => ({
    setRolling: (rolling) => {
      setOpacity(rolling ? 0.5 : 1);
    }
  }));

  return (
    <TouchableOpacity 
      style={[styles.button, { opacity }]} 
      onPress={onPress}
    >
      <Text style={styles.buttonText}>Roll</Text>
    </TouchableOpacity>
  );
}));

export default function Page() {
  // Player stats
  const [playerScore, setPlayerScore] = useState(0);
  const [playerCurrentTurn, setPlayerCurrentTurn] = useState(0);

  // Pig stats
  const [pigScore, setPigScore] = useState(0);
  const [pigCurrentTurn, setPigCurrentTurn] = useState(0);

  // Game state
  const [isPlayerTurn, setIsPlayerTurn] = useState(true);
  const [isRolling, setIsRolling] = useState(false);
  const [gameOver, setGameOver] = useState(false);
  const [winner, setWinner] = useState(null);
  const [statusMessage, setStatusMessage] = useState("It's your turn!");
  const [pigTurnState, setPigTurnState] = useState('start');

  // Remove playerLastRoll and pigLastRoll states
  const [lastRoll, setLastRoll] = useState(null);

  // Add this state variable at the top with other states
  const [displayPoints, setDisplayPoints] = useState(0);

  // Add this near your other state declarations
  const [sound, setSound] = useState();

  // Add this state variable at the top with other states
  const rollButtonRef = useRef(null);

  // Replace the state with a ref
  const lastDisplayedValueRef = useRef(null);

  // Add this with your other refs
  const pigScoreRef = useRef(0);

  // Update the pig's score in both the state and ref when it changes
  const updatePigScore = (newScore) => {
    setPigScore(newScore);
    pigScoreRef.current = newScore;
  };

  // Add this effect to clear storage and reset game when the app starts
  useEffect(() => {
    const clearStorageAndReset = async () => {
      try {
        await AsyncStorage.clear();
        // Reset game state
        setPlayerScore(0);
        setPlayerCurrentTurn(0);
        setPigScore(0);
        setPigCurrentTurn(0);
        setIsPlayerTurn(true);
        setGameOver(false);
        setWinner(null);
        setStatusMessage("It's your turn!");
        setDisplayPoints(0);
        lastDisplayedValueRef.current = null;  // Only reset here, when app first loads
        pigScoreRef.current = 0;
      } catch (error) {
        console.error('Error clearing storage:', error);
      }
    };

    clearStorageAndReset();
  }, []);

  // Optional: Save game state when it changes
  useEffect(() => {
    const saveGameState = async () => {
      try {
        const gameState = {
          playerScore,
          playerCurrentTurn,
          pigScore,
          pigCurrentTurn,
          isPlayerTurn,
          gameOver,
          winner,
        };
        await AsyncStorage.setItem('gameState', JSON.stringify(gameState));
      } catch (error) {
        console.error('Error saving game state:', error);
      }
    };

    saveGameState();
  }, [playerScore, playerCurrentTurn, pigScore, pigCurrentTurn, isPlayerTurn, gameOver, winner]);

  // Update the playDiceSound function to ensure clean sound handling
  async function playDiceSound() {
    if (sound) {
      await sound.unloadAsync();
    }
    const { sound: newSound } = await Audio.Sound.createAsync(
      require('../assets/sounds/dice_roll_1s.mp3'),
      { volume: 1.0 }
    );
    setSound(newSound);
    await newSound.playAsync();
  }

  // Update the useEffect cleanup
  useEffect(() => {
    return () => {
      if (sound) {
        sound.unloadAsync();
      }
    };
  }, [sound]);

  // Add this shared function for consistent dice rolling behavior
  const animateDiceRoll = async () => {
    await playDiceSound();

    const intervalTime = 150;
    const numFrames = 6;
    
    const finalValue = Math.floor(Math.random() * 6) + 1;
    const sequence = [];
    
    const getNextValue = (prev, avoid) => {
      let newValue;
      do {
        newValue = Math.floor(Math.random() * 6) + 1;
      } while (newValue === prev || newValue === avoid);
      return newValue;
    };
    
    sequence.push(getNextValue(lastDisplayedValueRef.current, null));
    
    for (let i = 1; i < numFrames - 2; i++) {
      sequence.push(getNextValue(sequence[i - 1], null));
    }
    
    sequence.push(getNextValue(sequence[sequence.length - 1], finalValue));
    sequence.push(finalValue);
    
    // Play the animation sequence
    for (let i = 0; i < sequence.length - 1; i++) {
      setLastRoll(sequence[i]);
      lastDisplayedValueRef.current = sequence[i];
      await new Promise(resolve => setTimeout(resolve, intervalTime));
    }
    
    // Show the final value
    setLastRoll(finalValue);
    lastDisplayedValueRef.current = finalValue;
    return finalValue;
  };

  const rollDice = async () => {
    setIsRolling(true);
    const newDiceValue = await animateDiceRoll();
    
    if (newDiceValue === 1) {
      setIsPlayerTurn(false);
      setIsRolling(false);
      setStatusMessage("Oh, no! You rolled a one!");
      
      setDisplayPoints(0);
      setPlayerCurrentTurn(0);
      
      setTimeout(() => {
        setStatusMessage("No points for you this turn!");
        
        setTimeout(() => {
          playPigTurn();
        }, 1000);
      }, 1000);
    } else {
      setStatusMessage(`You rolled a ${newDiceValue}!`);
      
      setPlayerCurrentTurn(prevTurn => {
        const newCurrentTurn = prevTurn + newDiceValue;
        setDisplayPoints(newCurrentTurn);
        return newCurrentTurn;
      });
      
      setIsRolling(false);
    }
  };

  const playWinSound = async () => {
    if (sound) {
      await sound.unloadAsync();
    }
    const { sound: newSound } = await Audio.Sound.createAsync(
      require('../assets/sounds/victory-fanfare.mp3'),
      { volume: 1.0 }
    );
    setSound(newSound);
    await newSound.playAsync();
  };

  const playPigWinSound = async () => {
    if (sound) {
      await sound.unloadAsync();
    }
    const { sound: newSound } = await Audio.Sound.createAsync(
      require('../assets/sounds/pig-grunt.mp3'),
      { volume: 1.0 }
    );
    setSound(newSound);
    await newSound.playAsync();
  };

  const hold = () => {
    const newPlayerScore = playerScore + playerCurrentTurn;
    setStatusMessage(`You added ${playerCurrentTurn} points to your score!`);
    setPlayerScore(newPlayerScore);
    setPlayerCurrentTurn(0);
    setDisplayPoints(0);
    console.log('Hold - last displayed value is:', lastDisplayedValueRef.current);
    
    if (newPlayerScore >= WINNING_SCORE) {
      setGameOver(true);
      setWinner('player');
      playWinSound();
    } else {
      setTimeout(() => {
        setIsPlayerTurn(false);
        playPigTurn();
      }, 2000);
    }
  };

  // Modify the decidePigAction function to use the ref
  const decidePigAction = (currentTurnScore) => {
    const currentPigScore = pigScoreRef.current;
    const potentialTotal = currentPigScore + currentTurnScore;
    
    if (potentialTotal >= WINNING_SCORE) {
      return false; // hold immediately to win
    }
    return currentTurnScore < 20;
  };

  const playPigTurn = async () => {
    setPigTurnState('start');
    setPigCurrentTurn(0);
    setDisplayPoints(0);
    
    setStatusMessage("It's the pig's turn.");
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    let keepRolling = true;
    let turnTotal = 0;
    
    while (keepRolling) {
      if (turnTotal === 0) {
        setStatusMessage("The pig will roll...");
      } else {
        setStatusMessage("The pig will roll again...");
      }
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      const newDiceValue = await animateDiceRoll();
      
      if (newDiceValue === 1) {
        setStatusMessage("The pig rolled a one!");
        setPigTurnState('rolledOne');
        
        setDisplayPoints(turnTotal);
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        setStatusMessage("No points for the pig this turn!");
        setDisplayPoints(0);
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        turnTotal = 0;
        setPigCurrentTurn(0);
        keepRolling = false;
        break;
      } else {
        turnTotal += newDiceValue;
        setPigCurrentTurn(turnTotal);
        setDisplayPoints(turnTotal);
        setStatusMessage(`The pig rolled a ${newDiceValue}`);
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        const shouldKeepRolling = decidePigAction(turnTotal);
        if (shouldKeepRolling) {
          continue;
        } else {
          setStatusMessage("The pig is thinking...");
          setPigTurnState('thinking');
          await new Promise(resolve => setTimeout(resolve, 1000));
          
          setStatusMessage("The pig has decided to hold!");
          setPigTurnState('willHold');
          await new Promise(resolve => setTimeout(resolve, 1000));
          
          setStatusMessage(`Adding ${turnTotal} points to the pig's score.`);
          await new Promise(resolve => setTimeout(resolve, 2000));
          
          const newPigScore = pigScoreRef.current + turnTotal;
          updatePigScore(newPigScore);
          
          if (newPigScore >= WINNING_SCORE) {
            setGameOver(true);
            setWinner('pig');
            playPigWinSound();
          }
          setPigCurrentTurn(0);
          keepRolling = false;
        }
      }
    }
    
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsPlayerTurn(true);
    setPigCurrentTurn(0);
    setDisplayPoints(0);
    setStatusMessage("It's your turn!");
  };

  const newGame = () => {
    setPlayerScore(0);
    setPlayerCurrentTurn(0);
    setPigScore(0);
    setPigCurrentTurn(0);
    setIsPlayerTurn(true);
    setGameOver(false);
    setWinner(null);
    setStatusMessage("It's your turn!");
    setDisplayPoints(0);
    lastDisplayedValueRef.current = null;
    pigScoreRef.current = 0;
  };

  const getPigMessage = () => {
    switch (pigTurnState) {
      case 'start':
        return 'The pig will roll...';
      case 'thinking':
        return 'The pig is thinking...';
      case 'willRoll':
        return 'The pig will roll again!';
      case 'willHold':
        return 'The pig has decided to hold!';
      case 'rolledOne':
        return 'The pig rolled a one!';
      default:
        return '';
    }
  };

  // Get the current dice value to display
  const currentDiceValue = isPlayerTurn ? lastRoll : lastRoll;
  
  // Get the current turn score to display
  const currentTurnScore = isPlayerTurn ? playerCurrentTurn : pigCurrentTurn;
  
  // Get the total score including current turn
  const currentTotalScore = isPlayerTurn 
    ? playerScore + playerCurrentTurn 
    : pigScore + pigCurrentTurn;

  // Memoize the rollDice callback
  const handleRollDice = useCallback(async () => {
    rollButtonRef.current?.setRolling(true);
    try {
      await rollDice();
    } finally {
      rollButtonRef.current?.setRolling(false);
    }
  }, []);

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <SafeAreaView style={styles.container}>
        {/* Score Display */}
        <View style={styles.scoresContainer}>
          <View style={[styles.scoreBox, styles.playerScore]}>
            <Text style={styles.scoreLabel}>You</Text>
            <Text style={styles.scoreValue}>{playerScore}</Text>
          </View>
          <View style={[styles.scoreBox, styles.pigScore]}>
            <Text style={styles.scoreLabel}>Pig</Text>
            <Text style={styles.scoreValue}>{pigScore}</Text>
          </View>
        </View>

        {/* Dice Display */}
        <View style={styles.diceContainer}>
          {lastRoll ? (
            <>
              {lastRoll === 1 && <DiceOne />}
              {lastRoll === 2 && <DiceTwo />}
              {lastRoll === 3 && <DiceThree />}
              {lastRoll === 4 && <DiceFour />}
              {lastRoll === 5 && <DiceFive />}
              {lastRoll === 6 && <DiceSix />}
            </>
          ) : (
            <View style={styles.emptyDice} />
          )}
        </View>

        {/* Status Message Area - Only show if game is not over */}
        {!gameOver && (
          <View style={styles.statusContainer}>
            <Text style={styles.statusText}>{statusMessage}</Text>
          </View>
        )}

        {/* Points Display - Only show if game is not over */}
        {!gameOver && (
          <View style={styles.pointsContainer}>
            <View style={styles.pointsRow}>
              <View style={styles.pointsContent}>
                <Text style={styles.pointsText}>Points: </Text>
                <View style={styles.pointsValueContainer}>
                  <Text style={styles.pointsValue}>{displayPoints}</Text>
                </View>
              </View>
            </View>
          </View>
        )}

        {/* Control Area */}
        {!gameOver ? (
          isPlayerTurn && (
            <View style={styles.buttonContainer}>
              <RollButton 
                ref={rollButtonRef}
                onPress={handleRollDice}
              />
              <TouchableOpacity 
                style={styles.button} 
                onPress={hold}
              >
                <Text style={styles.buttonText}>Hold</Text>
              </TouchableOpacity>
            </View>
          )
        ) : (
          <View style={styles.gameOverContainer}>
            <Text style={styles.gameOverText}>
              {winner === 'player' ? 'You Won!' : 'The Pig Won!'}
            </Text>
            <Text style={styles.emojiText}>
              {winner === 'player' ? '🎉' : '🐷'}
            </Text>
            <TouchableOpacity 
              style={styles.button} 
              onPress={newGame}
            >
              <Text style={styles.buttonText}>Play Again</Text>
            </TouchableOpacity>
          </View>
        )}
      </SafeAreaView>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    padding: 20,
  },
  statusContainer: {
    marginBottom: 20,
    alignItems: 'center',
  },
  statusText: {
    fontSize: 20,
    textAlign: 'center',
  },
  scoresContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 30,
    paddingHorizontal: '15%',
  },
  scoreBox: {
    alignItems: 'center',
    width: '40%',
  },
  playerScore: {
    alignItems: 'center',
  },
  pigScore: {
    alignItems: 'center',
  },
  scoreLabel: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  scoreValue: {
    fontSize: 24,
  },
  diceContainer: {
    width: DICE_SIZE,
    height: DICE_SIZE,
    alignSelf: 'center',
    backgroundColor: 'white',
    borderWidth: 2,
    borderColor: 'black',
    borderRadius: 10,
    marginVertical: 20,
  },
  emptyDice: {
    flex: 1,
  },
  pointsContainer: {
    width: '100%',
    alignItems: 'center',
    marginBottom: 30,
  },
  pointsRow: {
    width: '33%',  // Match the dice container width
    alignItems: 'center',
  },
  pointsContent: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  pointsText: {
    fontSize: 20,
  },
  pointsValueContainer: {
    width: 30,
  },
  pointsValue: {
    fontSize: 20,
    textAlign: 'center',
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
  },
  button: {
    backgroundColor: '#4CAF50',
    padding: 15,
    borderRadius: 8,
    minWidth: 120,
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
  gameOverContainer: {
    alignItems: 'center',
  },
  gameOverText: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#4CAF50',
  },
  emojiText: {
    fontSize: 40,
    marginBottom: 20,
  },
  dot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: 'black',
    margin: 4,
  },
  diceFace: {
    flex: 1,
    padding: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  diceRow: {
    flex: 1,
    flexDirection: 'row',
    padding: 5,
  },
  diceColumn: {
    flexDirection: 'column',
    height: '100%',
    padding: 5,
  },
  spaceBetween: {
    justifyContent: 'space-between',
  },
  spaceEvenly: {
    justifyContent: 'space-evenly',
  },
  center: {
    justifyContent: 'center',
  },
  fiveLayout: {
    position: 'relative',
    width: '100%',
    height: '100%',
  },
  dotPosition: {
    position: 'absolute',
  },
  centerDot: {
    position: 'absolute',
    transform: [
      { translateX: -12 },  // Half the dot size + margin
      { translateY: -12 }   // Half the dot size + margin
    ],
  },
}); 