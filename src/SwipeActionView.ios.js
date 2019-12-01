'use strict'

import React from 'react';
import {
  requireNativeComponent,
  NativeModules,
  processColor
} from 'react-native';

const NativeSwipeActionView = requireNativeComponent('SwipeActionView');
export const SwipeTransitions = NativeModules.SwipeActionViewManager.SwipeTransitions;

const formatButtonMutating = button => {
  if (button.color) {
    button.color = processColor(button.color);
  }
};

const formatButtonsMutating = buttons => {
  if (buttons != null) {
    buttons.forEach(formatButtonMutating);
  }
};

export const SwipeActionView = props => {
  formatButtonsMutating(props.leftButtons);
  formatButtonsMutating(props.rightButtons);

  const onButtonTapped = React.useCallback(
    tappedButtonInfo => {
      const {index, side} = tappedButtonInfo.nativeEvent;
      const buttons = props[side];
      const button = buttons != null ? buttons[index] : null;
      const callback = button != null ? button.callback : null;
      if (typeof callback === 'function') {
        callback();
      }
    },
    [props],
  );

  return <NativeSwipeActionView {...props} onButtonTapped={onButtonTapped} />;
};
