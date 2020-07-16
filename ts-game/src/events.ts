import readline from 'readline';

import { Directions } from './logic';

export interface UserEvent extends Directions<boolean> {}

const defaultEventState = () => ({
  up: false,
  down: false,
  right: false,
  left: false,
});

type Direction = keyof Directions<boolean>;
const commands: Direction[] = ['up', 'right', 'down', 'left'];

export interface EventHandler {
  exitEvent: () => boolean;
  reset: () => UserEvent;
  getMoveDirection: () => string | boolean;
}

const DIRECTION_STRING: number = 0;

export const eventHandler = () => {
  let gameEventExit = false;
  const events: UserEvent = { ...defaultEventState() };
  const handleKeyEvent = (_: string, key: any) => {
    if (key.name === 'q') {
      gameEventExit = true;
    } else if (commands.includes(key.name)) {
      Object.assign(
        events,
        { ...defaultEventState() },
        { [key.name]: true },
      );
    }
  };
  process.stdin.setRawMode(true);
  readline.emitKeypressEvents(process.stdin);
  process.stdin.on('keypress', handleKeyEvent);
  return {
    exitEvent: () => gameEventExit,
    reset: () => Object.assign(events, defaultEventState()),
    getMoveDirection: () => {
      const directions: [string, boolean][] = Object.entries(events);
      const moveInDirection: [string, boolean] | undefined = directions.find(
        ([_, isDirection]: [string, boolean]) => isDirection === true,
      );
      return moveInDirection !== undefined 
      ? moveInDirection[DIRECTION_STRING]
      : false;
    },
  };
};
