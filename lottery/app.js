const snarkjs = require("snarkjs");
const fs = require("fs");
async function run() {
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    {
      playerA: [83, 84, 69, 69, 76],
      guess: 83,
      salt: 362986289847779600,
      commitment:
        "15057754752634756475908235894514270422456734783907164695964318985994495471810",
    },
    "lottery.wasm",
    "lottery1.zkey"
  );

  console.log("Proof: ",publicSignals);
  console.log(JSON.stringify(proof, null, 1));

  const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

  const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
console.log("res",res)
  if (res === true) {
    console.log("Verification OK");
  } else {
    console.log("Invalid proof");
  }
}

run().then(() => {
  process.exit(0);
});
