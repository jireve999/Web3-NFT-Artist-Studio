// require("@nomicfoundation/hardhat-toolbox");

// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.28",
//   paths:{
//     artifacts: "./src/artifacts"
//   }
// };

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import path from "path";

const config: HardhatUserConfig = {
  solidity: "0.8.21",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545", // 确保本地节点正在运行
      chainId: 31337
    }
  }
  // paths: {
  //   artifacts: path.resolve(__dirname, "./src/artifacts") // 使用绝对路径
  // },
  // typechain: {
  //   outDir: "src/types", // 生成类型定义文件
  //   target: "ethers-v6"
  // }
};

export default config;