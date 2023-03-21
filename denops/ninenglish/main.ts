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
let dict = {}

const setupDict = async (dict_path: string) => {
  if (!loaded){
    let fnames = []
    for await(const fname of Deno.readDir(dict_path + '/src/'))
      fnames.push(`${dict_path}/src/${fname.name}`)
    let texts = fnames.map(f => Deno.readTextFile(f))
    for await(const text of texts){
      text.split('\n')
      .map(s=>s.split('\t'))
      .filter(s => s.length === 2)
      .forEach(s => dict[s[0].toLowerCase().trim()] = s[1])
    }
    loaded = true
  }
  return dict
}

type Params = {
};


const suffix = ['', 's', 'd', 'y', 'es', 'ed', 'is', 'ly', 'ing', 'able', 'lize', 'lized']
const prefix = ['', 'a', 'bi', 'pre', 'mul', 'non', 'hyper']
const after = ['', 'e', 'ing']

const setupWord = (token: string) => {
  let key = ''
  for (const p of prefix)
    for (const s of suffix)
      for (const a of after)
        if (token.slice(token.length-s.length) === s
            && token.slice(0, p.length) === p){
          key = token.slice(p.length, token.length-s.length).toLowerCase().trim() + a
          if (key in dict) return key + ';' + dict[key].replace(/\//g, ';').trim()
          }
  return 'Not found'
}

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async hover(path: string): Promise<unknown> {
      await setupDict(path)
      const token = await fn.expand(denops, '<cword>').then(setupWord)
      return await Promise.resolve(token);
    },
  };
};
