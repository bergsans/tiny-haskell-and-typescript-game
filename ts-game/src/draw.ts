import { State } from './ts-game.ts';

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
  'b': '  '
}

export function drawState(state:State) {
  console.log(
    state.level
      .map((row: string[], y: number) => row
          .map((tile: string, x: number) => {
            if(state.plr.x === x && state.plr.y === y) {
              return "👾";
            } else {
              return tileTypes[tile as keyof TileType];
            }
          })
          .join(''))
      .join('\n')
  );
}

