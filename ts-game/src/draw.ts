import { Level } from './game-data.ts';

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

export function drawLevel(level: Level) {
  console.log(
    level
      .map((row: string[]) => row
          .map((tile: string) => tileTypes[tile as keyof TileType])
          .join(''))
      .join('\n')
  );
}

