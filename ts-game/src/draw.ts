import { State, Camera } from './ts-game';

interface TileTypes {
  c: string;
  x: string;
  o: string;
  '.': string;
  'b': string;
}
interface TileType extends Pick<TileTypes, 'c' | 'x' | 'o' | '.' | 'b'> {}

const tileTypes:TileTypes = {
  c: '📷',
  x: '▒▒',
  o: '🍪',
  '.': ' .',
  b: '  ',
};

export default function drawState(state: State) {
  console.log(
    state.level
      .map((row: string[], y: number) => row
        .map((tile: string, x: number) => {
          if (state.plr.x === x && state.plr.y === y) {
            return '👾';
          } if (state.cameras.some(
            (cam: Camera) => cam.pos.x + cam.diff === x && cam.pos.y === y,
          )) {
            return '💥';
          }
          return tileTypes[tile as keyof TileType];
        })
        .join(''))
      .join('\n'),
  );
  console.log(`

Cookies eaten: ${state.score}`);
}
