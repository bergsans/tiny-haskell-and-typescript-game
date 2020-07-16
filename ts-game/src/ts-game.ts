import { getLevel, Level } from './game-data';
import { drawState, drawIntroscreen } from './draw';
import { eventHandler } from './events';
import { Position, nextState } from './logic';

export interface Camera {
  pos: Position;
  diff: number;
}

export interface State {
  level: Level;
  plr: Position;
  score: number;
  cameras: Camera[];
  plrIsHit: boolean;
}

const isCam = (cell: string) => cell === 'c';

const findCams = (row: string[], y: number): Camera[] => row.reduce(
  (cams: Camera[], cell: string, x: number) => (isCam(cell)
    ? [...cams, {
      pos: { x, y },
      diff: 1,
    }]
    : cams),
  [],
);

const getCams = (level: Level) => level
  .reduce(
    (cams: Camera[], row: string[], y: number) => (row.some(isCam)
      ? [...cams, ...findCams(row, y)]
      : cams),
    [],
  );

const initialState:State = {
  level: getLevel(),
  plr: {
    x: 2,
    y: 2,
  },
  score: 0,
  cameras: getCams(getLevel()),
  plrIsHit: false,
};

const eH = eventHandler();

const gameLoop = (currentState: State) => {
  if (currentState.score === 13 || eH.exitEvent() || currentState.plrIsHit) {
    process.exit(0);
  }
  console.clear();
  drawState(currentState);
  const newState: State = nextState(currentState, eH);
  eH.reset();
  setTimeout(() => gameLoop(newState), 100);
};

drawIntroscreen();
setTimeout(() => gameLoop(initialState), 2000);
