




<img width="1920" height="1080" alt="Screenshot(2)" src="https://github.com/user-attachments/assets/c407ccd3-e5bc-4a3c-ab9f-6c9817a51bfa" />

# 🎮 RockPaperScissors Smart Contract

## 🧩 Project Description

**RockPaperScissors** is a decentralized, trustless version of the classic Rock–Paper–Scissors game — built entirely on the Ethereum blockchain using Solidity.  
This contract ensures fairness by using a **commit–reveal mechanism**, preventing cheating or front-running during gameplay.

Players commit to a hashed move first (without revealing it), and later reveal the move with their secret to determine the winner on-chain.  

---

## ⚙️ What It Does

- Two players can start a new game securely.  
- Each player **commits** to a hashed move (Rock, Paper, or Scissors + secret).  
- Once both players commit, they **reveal** their moves with the secret.  
- The contract automatically determines the winner and stores the result on-chain.  

No central authority or game server is needed — everything runs transparently on Ethereum.  

---

## 🌟 Features

✅ **Fair Play** — Uses commit–reveal scheme to prevent cheating.  
✅ **On-Chain Resolution** — The result is verifiable and permanently recorded.  
✅ **Event-Based Architecture** — Every action (create, commit, reveal, resolve) emits blockchain events.  
✅ **Lightweight** — Optimized for low gas usage.  
✅ **Extensible** — Can be upgraded to include betting, NFTs, or tournaments.

---

## 🔗 Deployed Smart Contract

**Network:** Ethereum / Testnet (e.g., Sepolia)  
**Deployed Contract:** [https://celo-alfajores.blockscout.com/address/0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8](0x804a20f8351eefd2751c6487496b960b5654f94b) 


---

## 🧠 How It Works

1. **Create Game**
   ```solidity
   createGame(opponentAddress);
