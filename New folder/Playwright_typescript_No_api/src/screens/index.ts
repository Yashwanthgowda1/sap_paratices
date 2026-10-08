import { HotstarLoginScreen } from './hotstar/HotstarLoginScreen';
import { HotstarHomeScreen } from './hotstar/HotstarHomeScreen';
import { HotstarSearchScreen } from './hotstar/HotstarSearchScreen';
import { HotstarPlayerScreen } from './hotstar/HotstarPlayerScreen';

// Central screen registry — import this in any Android test
// No need to declare or instantiate screen objects per test file
export const screens = {
  login:  new HotstarLoginScreen(),
  home:   new HotstarHomeScreen(),
  search: new HotstarSearchScreen(),
  player: new HotstarPlayerScreen(),
};
