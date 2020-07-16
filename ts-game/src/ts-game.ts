import { getLevel, Level } from './game-data';
import drawState from './draw';
import { eventHandler } from './events';
import { Position, nextState } from './logic';

export interface State {
  level: Level;
  plr: Position;
  score: number;
}

const initialState:State = {
  level: getLevel(),
  plr: {
    x: 2,
    y: 2,
  },
  score: 0,
};

const eH = eventHandler();

const gameLoop = (currentState: State) => {
  console.clear();
  drawState(currentState);
  if (currentState.score === 13 || eH.exitEvent()) {
    process.exit(0);
  }
  const newState: State = nextState(currentState, eH);
  eH.reset();
  setTimeout(() => gameLoop(newState), 100);
};
gameLoop(initialState);
