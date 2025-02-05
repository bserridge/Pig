import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, SafeAreaView } from 'react-native';
import { Stack } from 'expo-router';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const unstable_settings = {
  // Ensure that reloading on `/modal` keeps a back button present.
  initialRouteName: "index",
};

export default function Page() {
  // Player stats
  const [playerScore, setPlayerScore] = useState(0);
  const [playerCurrentTurn, setPlayerCurrentTurn] = useState(0);
  const [playerLastRoll, setPlayerLastRoll] = useState(null);

  // Pig stats
  const [pigScore, setPigScore] = useState(0);
  const [pigCurrentTurn, setPigCurrentTurn] = useState(0);
  const [pigLastRoll, setPigLastRoll] = useState(null);

  // Game state
  const [isPlayerTurn, setIsPlayerTurn] = useState(true);
  const [isRolling, setIsRolling] = useState(false);
  const [gameOver, setGameOver] = useState(false);
  const [winner, setWinner] = useState(null);
  const [statusMessage, setStatusMessage] = useState("It's your turn!");
  const [pigTurnState, setPigTurnState] = useState('start');

  // Add this effect to clear storage and reset game when the app starts
  useEffect(() => {
    const clearStorageAndReset = async () => {
      try {
        // Clear all storage
        await AsyncStorage.clear();
        // Reset game state
        newGame();
      } catch (error) {
        console.error('Error clearing storage:', error);
      }
    };

    clearStorageAndReset();
  }, []); // Empty dependency array means this runs once when component mounts

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

  const rollDice = () => {
    setIsRolling(true);
    const newDiceValue = Math.floor(Math.random() * 6) + 1;
    setPlayerLastRoll(newDiceValue);
    setIsRolling(false);

    if (newDiceValue === 1) {
      setStatusMessage("Oh, no! You rolled a one!");
      setPlayerCurrentTurn(0);
      setTimeout(() => {
        setIsPlayerTurn(false);
        playPigTurn();
      }, 1500);
    } else {
      setStatusMessage(`You rolled a ${newDiceValue}!`);
      const newCurrentTurn = playerCurrentTurn + newDiceValue;
      setPlayerCurrentTurn(newCurrentTurn);
    }
  };

  const hold = () => {
    const newPlayerScore = playerScore + playerCurrentTurn;
    setPlayerScore(newPlayerScore);
    setPlayerCurrentTurn(0);
    setPlayerLastRoll(null);
    
    if (newPlayerScore >= 100) {
      setGameOver(true);
      setWinner('player');
    } else {
      setIsPlayerTurn(false);
      setStatusMessage("It's Pig's turn");
      playPigTurn();
    }
  };

  const decidePigAction = (currentTurnScore) => {
    if (pigScore + currentTurnScore >= 100) {
      return false; // hold to win
    }
    if (currentTurnScore >= 20) {
      return false; // hold
    }
    return true; // roll again
  };

  const playPigTurn = async () => {
    setPigTurnState('start');
    setPigCurrentTurn(0);
    setPigLastRoll(null);
    
    await new Promise(resolve => setTimeout(resolve, 500));
    
    let keepRolling = true;
    let turnTotal = 0;
    
    while (keepRolling) {
      const newDiceValue = Math.floor(Math.random() * 6) + 1;
      
      if (newDiceValue === 1) {
        setPigLastRoll(1);
        setStatusMessage("The pig rolled a one!");
        setPigTurnState('rolledOne');
        
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        turnTotal = 0;
        setPigCurrentTurn(0);
        keepRolling = false;
        break;
      } else {
        turnTotal += newDiceValue;
        setPigCurrentTurn(turnTotal);
        setStatusMessage(`The pig rolled a ${newDiceValue}`);
        
        setPigTurnState('thinking');
        await new Promise(resolve => setTimeout(resolve, 1500));
        
        const shouldKeepRolling = decidePigAction(turnTotal);
        if (shouldKeepRolling) {
          setPigTurnState('willRoll');
          await new Promise(resolve => setTimeout(resolve, 500));
        } else {
          setPigTurnState('willHold');
          await new Promise(resolve => setTimeout(resolve, 1000));
          
          const newPigScore = pigScore + turnTotal;
          setPigScore(newPigScore);
          setPigCurrentTurn(0);
          keepRolling = false;
          
          if (newPigScore >= 100) {
            setGameOver(true);
            setWinner('pig');
          }
          
          await new Promise(resolve => setTimeout(resolve, 1000));
        }
      }
    }
    
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsPlayerTurn(true);
    setPigLastRoll(null);
    setStatusMessage("It's your turn!");
  };

  const newGame = () => {
    // Reset player stats
    setPlayerScore(0);
    setPlayerCurrentTurn(0);
    setPlayerLastRoll(null);

    // Reset pig stats
    setPigScore(0);
    setPigCurrentTurn(0);
    setPigLastRoll(null);

    // Reset game state
    setGameOver(false);
    setWinner(null);
    setIsPlayerTurn(true);
    setStatusMessage("It's your turn!");
    setPigTurnState('start');
    setIsRolling(false);
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
  const currentDiceValue = isPlayerTurn ? playerLastRoll : pigLastRoll;
  
  // Get the current turn score to display
  const currentTurnScore = isPlayerTurn ? playerCurrentTurn : pigCurrentTurn;
  
  // Get the total score including current turn
  const currentTotalScore = isPlayerTurn 
    ? playerScore + playerCurrentTurn 
    : pigScore + pigCurrentTurn;

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <SafeAreaView style={styles.container}>
        {/* Status Message Area */}
        <View style={styles.statusContainer}>
          <Text style={styles.statusText}>{statusMessage}</Text>
        </View>
        
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
          {currentDiceValue && !isRolling ? (
            <View style={styles.diceFace}>
              {/* TODO: Implement dot pattern based on currentDiceValue */}
            </View>
          ) : (
            <View style={styles.emptyDice} />
          )}
        </View>

        {/* Points Display */}
        <View style={styles.pointsContainer}>
          <Text style={styles.pointsText}>Points: {currentTurnScore}</Text>
          <Text style={styles.totalText}>
            (Total: {currentTotalScore})
          </Text>
        </View>

        {/* Control Area */}
        {!gameOver ? (
          isPlayerTurn ? (
            <View style={styles.buttonContainer}>
              <TouchableOpacity 
                style={styles.button} 
                onPress={rollDice}
                disabled={isRolling}>
                <Text style={styles.buttonText}>Roll</Text>
              </TouchableOpacity>
              <TouchableOpacity 
                style={styles.button} 
                onPress={hold}
                disabled={isRolling}>
                <Text style={styles.buttonText}>Hold</Text>
              </TouchableOpacity>
            </View>
          ) : (
            <View style={styles.pigMessageContainer}>
              <Text style={styles.pigMessage}>{getPigMessage()}</Text>
            </View>
          )
        ) : (
          <View style={styles.gameOverContainer}>
            <Text style={styles.gameOverText}>
              {winner === 'player' ? 'You Won! 🎉' : 'The Pig Won! 🐷'}
            </Text>
            <TouchableOpacity style={styles.button} onPress={newGame}>
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
    height: 60,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
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
    aspectRatio: 1,
    width: '33%',
    alignSelf: 'center',
    backgroundColor: 'white',
    borderWidth: 2,
    borderRadius: 10,
    marginBottom: 30,
  },
  diceFace: {
    flex: 1,
  },
  emptyDice: {
    flex: 1,
  },
  pointsContainer: {
    alignItems: 'center',
    marginBottom: 30,
  },
  pointsText: {
    fontSize: 20,
  },
  totalText: {
    fontSize: 18,
    color: '#666',
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
  pigMessageContainer: {
    height: 100,
    justifyContent: 'center',
    alignItems: 'center',
  },
  pigMessage: {
    fontSize: 18,
    textAlign: 'center',
  },
  gameOverContainer: {
    alignItems: 'center',
  },
  gameOverText: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 20,
    color: '#4CAF50',
  },
}); 