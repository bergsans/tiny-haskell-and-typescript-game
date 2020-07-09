import { getLevel, Level } from './game-data';
import { drawState } from './draw';
import { eventHandler } from './events';
import { Position, nextState } from './logic';

export interface State {
  level: Level;
  plr: Position; 
}

const initialState:State = {
    level: getLevel(),
    plr: {
      x: 2,
      y: 2
    }
  }

const eH = eventHandler();

const gameLoop = (currentState: State) => {
  console.clear();
  drawState(currentState);
  const newState: State = nextState(currentState, eH);
  eH.reset();
  setTimeout(() => gameLoop(newState), 100);
};
gameLoop(initialState);

