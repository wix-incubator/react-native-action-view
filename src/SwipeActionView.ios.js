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
  const {leftButtons, rightButtons} = props;
  formatButtonsMutating(leftButtons);
  formatButtonsMutating(rightButtons);

  const onButtonTapped = React.useCallback(
    tappedButtonInfo => {
      const {index, side} = tappedButtonInfo.nativeEvent;
      const buttons =
        side === 'leftButtons'
          ? leftButtons
          : side === 'rightButtons'
          ? rightButtons
          : undefined;
      const button = buttons != null ? buttons[index] : null;
      const callback = button != null ? button.callback : null;
      if (typeof callback === 'function') {
        callback();
      }
    },
    [leftButtons, rightButtons],
  );

  return <NativeSwipeActionView {...props} onButtonTapped={onButtonTapped} />;
};
