import readline from 'readline';

import { Directions } from './logic';

export interface UserEvent extends Directions<boolean> {}

const defaultEventState = () => ({
  up: false,
  down: false,
  right: false,
  left: false
});

type Direction = keyof Directions<boolean>;
const commands: Direction[] = ['up', 'right', 'down', 'left'];

export interface EventHandler {
  getValues: () => UserEvent;
  reset: () => UserEvent;
  getMoveDirection: () => string | boolean;
}

export const eventHandler = () => {
  const events: UserEvent = { ...defaultEventState() };
  const handleKeyEvent = (_: string, key: any) => {
    if(key === 'q') {
      process.exit(0);
    } else if(commands.includes(key.name)) {
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
    getValues: () => ({ ...events }),
    reset: () => Object.assign(events, defaultEventState()),
    getMoveDirection: () => {
      const dirs: [string, boolean][] = Object.entries(events);
      const res: [string, boolean] | undefined = dirs.find((v: [string, boolean]) => v[1] === true);;
      return res !== undefined ? res[0] : false;
    }
  };
};

