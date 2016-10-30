/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  ScrollView,
  View
} from 'react-native';

import { SwipeActionView } from 'react-native-action-view';

class example extends Component {
  render() {
    return (
      <View contentContainerStyle={styles.container}>
        <View style={{height: 20}} />
        <SwipeActionView rightExpansionSettings={{buttonIndex: 0}}
                         leftExpansionSettings={{buttonIndex: 0}} 
                         rightButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}
                         leftButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}>
          <Text style={styles.welcome}>
            Welcome to React Native!
          </Text>
          <Text style={styles.instructions}>
            To get started, swipe this view.
          </Text>
          <Text style={styles.instructions}>
            Tap on a button or swipe fully.
          </Text>
        </SwipeActionView>
        <SwipeActionView rightExpansionSettings={{buttonIndex: 0}}
                         leftExpansionSettings={{buttonIndex: 0}} 
                         rightButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}
                         leftButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}>
          <Text style={styles.welcome}>
            Welcome to React Native!
          </Text>
          <Text style={styles.instructions}>
            To get started, swipe this view.
          </Text>
          <Text style={styles.instructions}>
            Tap on a button or swipe fully.
          </Text>
        </SwipeActionView>
        <SwipeActionView rightExpansionSettings={{buttonIndex: 0}}
                         leftExpansionSettings={{buttonIndex: 0}} 
                         rightButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}
                         leftButtons={[{title: 'Red', color: 'rgb(255, 0, 0)', callback: () => {alert('Red button tapped.');}}, 
                                        {title: 'Green', color: 'rgb(0, 255, 0)', callback: () => {alert('Green button tapped.');}},
                                        {title: 'Blue', color: 'rgb(0, 0, 255)', callback: () => {alert('Blue button tapped.');}}]}>
          <Text style={styles.welcome}>
            Welcome to React Native!
          </Text>
          <Text style={styles.instructions}>
            To get started, swipe this view.
          </Text>
          <Text style={styles.instructions}>
            Tap on a button or swipe fully.
          </Text>
        </SwipeActionView>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('example', () => example);
