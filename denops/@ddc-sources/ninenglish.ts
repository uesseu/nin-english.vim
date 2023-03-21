import {
  BaseSource,
  DdcOptions,
  Item,
  SourceOptions,
} from "https://deno.land/x/ddc_vim@v3.2.0/types.ts";
import {
  assertEquals,
  Denops,
  vars,
  fn,
} from "https://deno.land/x/ddc_vim@v3.2.0/deps.ts";

let loaded = false
let dict: Object[] = []

const text2Dict = (text: string) => 
  text.split('\n')
    .map(s=>s.split('\t'))
    .filter(s => s.length === 2)
    .map(s=> <Item>{word: s[0], info: s[1].replace(/\//g, ';'), dup: true})

const setupDict = async (dict_path: string) => {
  if (!loaded){
    let fnames = []
    for await(const fname of Deno.readDir(dict_path + '/src/'))
      fnames.push(`${dict_path}/src/${fname.name}`)
    let texts = fnames.map(f => Deno.readTextFile(f))
    for (const text of texts)
      dict = dict.concat(text2Dict(await text))
    loaded = true
  }
  return dict
}

type Params = {
};

export class Source extends BaseSource<Params> {
  override async gather(args: {
    denops: Denops;
    options: DdcOptions;
    sourceOptions: SourceOptions;
    sourceParams: Params;
    completeStr: string;
  }): Promise<Item[]> {
    await setupDict(args.sourceParams['dict_dir'])
    return dict
  }
}
