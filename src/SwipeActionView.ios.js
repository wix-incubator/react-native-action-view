'use strict'

import React, { memo, useCallback, useEffect, useState } from 'react';
import {
  requireNativeComponent,
  NativeModules,
  processColor
} from 'react-native';

const NativeSwipeActionView = requireNativeComponent('SwipeActionView');
export const SwipeTransitions = NativeModules.SwipeActionViewManager.SwipeTransitions;

const transformColor = (button) => {
  if (!button.color) { return button; }

  return {
    ...button,
    color: processColor(button.color),
  };
};

const stateFromProps = (props) => {
  const state = {};

  if (props.rightButtons) {
    state.rightButtons = props.rightButtons.map(transformColor);
  }

  if (props.leftButtons) {
    state.leftButtons = props.leftButtons.map(transformColor);
  }

  return state;
}

const SwipeActionView = memo((props) => {
  const [state, setState] = useState(stateFromProps(props));

  const onButtonTapped = useCallback(({nativeEvent}) => {
    const { index, side } = nativeEvent;

    state[side]?.[index]?.callback?.();
  }, []);

  useEffect(() => {
    setState(stateFromProps(props));
  }, [props]);

  return (
    <NativeSwipeActionView {...props} {...state} onButtonTapped={onButtonTapped} />
  );
});

SwipeActionView.displayName = 'SwipeActionView';

export {
  SwipeActionView
};
