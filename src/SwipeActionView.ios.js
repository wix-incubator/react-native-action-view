'use strict'

import React, { Component } from 'react';
import {
  requireNativeComponent,
  NativeModules,
  processColor
} from 'react-native';

const NativeSwipeActionView = requireNativeComponent('SwipeActionView');
export const SwipeTransitions = NativeModules.SwipeActionViewManager.SwipeTransitions;

export class SwipeActionView extends Component {
  constructor(props) {
    super(props)
    
    this._onButtonTapped = this._onButtonTapped.bind(this);
    this.state = this.stateFromProps(props);
  }

  componentWillReceiveProps(nextProps) {
    this.setState(this.stateFromProps(nextProps));
  }

  stateFromProps(props) {
    const state = {};

    const f = (button) => {
      if(!button["color"]) { return button; }

      button["color"] = processColor(button["color"]);

      return button;
    };

    if(props["rightButtons"]) {
      state.rightButtons = props["rightButtons"].map(f);
    }

    if(props["leftButtons"]) {
      state.leftButtons = props["leftButtons"].map(f);
    }

    return state;
  }

  _onButtonTapped(tappedButtonInfo) {
    const side = tappedButtonInfo.nativeEvent.side;
    const idx = tappedButtonInfo.nativeEvent.index;

    if (!this.state[side]) {
      return;
    }

    if(!this.state[side][idx].callback) {
      return;
    }

    this.state[side][idx].callback();
  }
  render() {
    return <NativeSwipeActionView {...this.props} {...this.state} onButtonTapped={this._onButtonTapped} />;
  }
}