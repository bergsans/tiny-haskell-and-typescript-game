import { getLevel, Level } from './game-data';
import { drawState } from './draw';

export interface Position {
  x: number;
  y: number;
}

export interface State {
  level: Level;
  plr: Position; 
}

drawState({
  level: getLevel(),
  plr: {
    x: 2,
    y: 2
  }
});
