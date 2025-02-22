import React from 'react';
import { StyleSheet, View, Text, ScrollView, TouchableOpacity } from 'react-native';
import { Stack, useRouter } from 'expo-router';

export default function HowToPlay() {
  const router = useRouter();

  return (
    <>
      <Stack.Screen 
        options={{ 
          headerShown: false,
        }} 
      />
      <View style={styles.container}>
        <Text style={styles.title}>How to Play</Text>
        
        <ScrollView style={styles.scrollView}>
          <View style={styles.content}>
            <Text style={styles.heading}>Objective</Text>
            <Text style={styles.text}>
              Your goal is to get to 100 points before the pig does.
            </Text>

            <Text style={styles.heading}>On your turn</Text>
            <Text style={styles.text}>
              Earn points by rolling the dice, but watch out!
            </Text>
            <Text style={styles.text}>
              • If you roll a 1, your turn ends and you lose the points from this turn.{'\n'}
              • Press "Hold" to end your turn and add the points to your score.
            </Text>

            <Text style={styles.heading}>Playing against Pig</Text>
            <Text style={styles.text}>
              When your turn ends, Pig will take a turn. Try not to let Pig win!
            </Text>

            <Text style={styles.heading}>Winning</Text>
            <Text style={styles.text}>
              If you hold to end your turn and your score is 100 points or more, you win!
            </Text>
          </View>
        </ScrollView>

        <TouchableOpacity 
          style={styles.button}
          onPress={() => router.back()}
        >
          <Text style={styles.buttonText}>Back to Menu</Text>
        </TouchableOpacity>
      </View>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    paddingTop: 60,
    paddingBottom: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 20,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    padding: 20,
  },
  heading: {
    fontSize: 20,
    fontWeight: 'bold',
    marginTop: 20,
    marginBottom: 10,
  },
  text: {
    fontSize: 16,
    lineHeight: 24,
    marginBottom: 15,
  },
  button: {
    backgroundColor: '#4CAF50',
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 8,
    marginHorizontal: 20,
    marginTop: 20,
  },
  buttonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
    textAlign: 'center',
  },
});
