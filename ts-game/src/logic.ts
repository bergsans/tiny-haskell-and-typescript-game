import { Level } from './game-data';
import { EventHandler, UserEvent } from './events';
import { Camera, State } from './ts-game';

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

const removeCookie = (level: Level, pos: Position) => {
  const newLevel = [...level].map((row) => [...row]);
  newLevel[pos.y][pos.x] = '.';
  return newLevel;
};

const isPlrAtCookie = (pos: Position, level: Level, score: number) => (level[pos.y][pos.x] === 'o'
  ? ({ level: removeCookie(level, pos), score: score + 1 })
  : ({ level, score }));

const isPlrHit = (pos: Position, cams: Camera[]) => cams.some(
  (cam) => cam.pos.x + cam.diff === pos.x && cam.pos.y === pos.y,
);

const moveCams = (level: Level, cams: Camera[]) => cams.map(
  (cam) => (level[cam.pos.y][cam.pos.x + cam.diff + 1] !== 'x'
    ? ({ pos: cam.pos, diff: cam.diff + 1 })
    : ({ pos: cam.pos, diff: 1 })),
);

export const nextState = (state: State, e: EventHandler) => {
  const isPlrMoving = e.getMoveDirection();
  const plr: Position = isPlrMoving
    ? attemptMove(
      state,
      state.level,
      moveDirs[(isPlrMoving as keyof Directions<Diff>)],
    )
    : state.plr;
  const { score, level } = isPlrAtCookie(state.plr, state.level, state.score);
  const cameras = moveCams(state.level, state.cameras);
  const plrIsHit = isPlrHit(state.plr, state.cameras);
  return {
    level,
    plr,
    score,
    cameras,
    plrIsHit,
  };
};
