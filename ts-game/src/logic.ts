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
) => level[creature.y + y][creature.x + x] !== 'x';

const attemptMove = (state: State, level: Level, [x, y]: Diff) => (
  isMovePossible(state.plr, level, x, y)
    ? ({
      ...state.plr,
      x: state.plr.x + x,
      y: state.plr.y + y,
    })
    : state.plr
);

const removeCherry = (level: Level, pos: Position) => {
  const newLevel = [...level].map((row) => [...row]);
  newLevel[pos.y][pos.x] = '.';
  return newLevel;
};

const isPlrAtCherry = (pos: Position, level: Level, score: number) => (level[pos.y][pos.x] === 'o'
  ? ({ level: removeCherry(level, pos), score: score + 1 })
  : ({ level, score }));

export const nextState = (state: State, e: EventHandler) => {
  const isPlrMoving = e.getMoveDirection();
  const plr: Position = isPlrMoving
    ? attemptMove(
      state, state.level,
      moveDirs[(isPlrMoving as keyof Directions<Diff>)],
    )
    : state.plr;
  const { score, level } = isPlrAtCherry(state.plr, state.level, state.score);
  return {
    level,
    plr,
    score,
  };
};
