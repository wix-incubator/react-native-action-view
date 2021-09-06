'use strict'

import React, { memo } from 'react';
import {
  View
} from 'react-native';

export const SwipeTransitions = {};

const SwipeActionView = memo((props) => <View {...props} />);

SwipeActionView.displayName = 'SwipeActionView';

export {
  SwipeActionView
};
