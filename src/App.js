import React from 'react';
import './App.css';
import { ethers } from "ethers";
import Lock from "./artifacts/contracts/Lock.sol/Lock.json";

function App() {
  const connect = async () => {
    let signer = null;
    let provider;

    if (window.ethereum == null) {
      console.log("MetaMask not installed; using read-only defaults");
      provider = ethers.getDefaultProvider();
    } else {
      provider = new ethers.BrowserProvider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      signer = await provider.getSigner();
      const addr = await signer.getAddress();
      console.log("Connected to address:", addr);
    }
  }

  const readMessage = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const lockAddress = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"; // 确保地址正确
    const lock = new ethers.Contract(lockAddress, Lock.abi, provider);
    const message = await lock.message();
    alert(message);
  }

  const setMessage = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const signer = await provider.getSigner();
    const lockAddress = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"; // 确保地址正确
    const lock = new ethers.Contract(lockAddress, Lock.abi, signer);

    try {
      let transaction = await lock.setMessage("world hello!");
      let tx = await transaction.wait(1);

      // Check if an event was triggered
      if (tx.events && tx.events.length > 0) {
        let event = tx.events[0];
        let value = event.args[0];
        let message = value.toString();
        alert(`Event triggered with message: ${message}`);
      } else {
        alert("Transaction successful but no events were triggered.");
      }
    } catch (error) {
      console.error("Error setting message:", error);
      alert("Failed to set message. Check the console for more details.");
    }
  }

  return (
    <div className="App">
      <button onClick={connect}>Connect Wallet</button>
      <button onClick={readMessage}>Read Message</button>
      <button onClick={setMessage}>Set Message</button>
    </div>
  );
}

export default App;