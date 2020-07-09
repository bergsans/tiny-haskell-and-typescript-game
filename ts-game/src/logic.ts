import { Level } from './game-data';
import { EventHandler, UserEvent } from './events';
import { State } from './ts-game';

type Diff = {
    0: number;
    1: number;
} & Array<number>;

export interface Directions<T> {
    up: T;
    down: T;
    right: T;
    left: T;
}

const moveDirs:Directions<Diff> = {
  up: [0, -1],
  right: [1, 0],
  down: [0, 1],
  left: [-1, 0],
};

export interface Position {
  x: number;
  y: number;
}

const isMovePossible = (
  creature: Position,
  level: Level,
  x: number,
  y: number,
) => level[creature.y + y][creature.x + x] === '.';

// const isMovingInDirection = (direction: boolean) => direction === true;
// 
// const isPlayerAttemptingToMove = (e: UserEvent): boolean => {
//   const tValues: boolean[] = Object.values(e);
//   return tValues.some((v: boolean) => isMovingInDirection(v));
// };

const attemptMove = (state: State, level: Level, [x, y]: Diff) => (
  isMovePossible(state.plr, level, x, y)
    ? ({
      ...state.plr,
      x: state.plr.x + x,
      y: state.plr.y + y,
    })
    : state.plr
);

export const nextState = (state: State, e: EventHandler) => {
  const isPlrMoving = e.getMoveDirection();
  if (isPlrMoving === false) {
    return state;
  }
  const plr: Position = attemptMove(state, state.level, moveDirs[(isPlrMoving as keyof Directions<Diff>)]);
  return {
    ...state,
    plr
  };
};
