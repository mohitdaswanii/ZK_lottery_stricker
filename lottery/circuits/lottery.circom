pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";



template SingleGuessCheck () {
    signal input playerA[5];
    signal input guess;
    signal input salt;
    signal input commitment;
    signal output clue[5];
    
    component eq[5];
    for (var i=0; i<5; i++) {
      eq[i] = IsEqual();
      eq[i].in[0] <== guess;
      eq[i].in[1] <== playerA[i];
      clue[i] <== eq[i].out;
   }
   

   /*
   * Converting the ASCII playerA to a single number.
   */
   signal playerAAsNumber[5];
   playerAAsNumber[0] <== playerA[0];
   for (var i=1; i<5; i++){
      playerAAsNumber[i] <== playerAAsNumber[i-1] + playerA[i] * (100 ** i);
   }
   //Hashing the playerA
   component playerAHash = Poseidon(2);
   playerAHash.inputs[0] <== playerAAsNumber[4];
   playerAHash.inputs[1] <== salt;
   //Constrain the hash to a publicly committed one
   commitment === playerAHash.out;

    
}

template CheckGuess() {  
   signal input playerA[5];
   signal input salt;
   signal input guess;
   signal input commitment;
   signal output clue[5];
   component check = SingleGuessCheck();
   check.salt <== salt;
   check.commitment <== commitment;
   check.guess <== guess;
   for (var i = 0; i < 5; i++) {
      check.playerA[i] <== playerA[i];
   }
   //Constraining the output after all the inputs were assigned
   for (var i = 0; i < 5; i++) {
      clue[i] <== check.clue[i];
   }
}

component main = CheckGuess();

/* INPUT = {
    "playerA": [ 83, 84, 69, 69, 76 ],
    "guess": "84",
    "salt": 362986289847779600,
    "commitment": "15057754752634756475908235894514270422456734783907164695964318985994495471810"
} */