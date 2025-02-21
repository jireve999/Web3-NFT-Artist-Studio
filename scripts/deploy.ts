import { ethers } from "hardhat";

async function main() {
  // 1. 获取合约工厂
  const ArtistNFT = await ethers.getContractFactory("ArtistNFT");
  
  // 2. 部署合约（无构造函数参数）
  const nft = await ArtistNFT.deploy();
  
  // 3. 等待部署确认
  await nft.waitForDeployment();

  // 4. 获取合约地址
  const address = await nft.getAddress();
  console.log("ArtistNFT deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });