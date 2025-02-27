import { create as ipfsHttpClient } from "ipfs-http-client";
import axios from 'axios'
import { IPFS } from "../config";
const ipfs =  ipfsHttpClient({
    host: IPFS.domain,
    port: 5001,
    protocol: 'http',

  })

export const storeMeta = async(data: any) => {
  const json = JSON.stringify(data);
  alert(json);
  try {
    const added = await ipfs.add(json);
    alert(added.path);
  } catch (err) {
    alert(err);
  }
}

export const addToIpfs = async(entity: any): Promise<string> => {
  debugger
  const added = await ipfs.add(entity);
  const cid = added.path;
  const rst = "http://127.0.0.1:8080/ipfs/" + cid;
  return rst;
}

export const readArticle = async (uri:string): Promise<string> => {
  const res = await axios.get(uri);
  return res.data
}

