
import Principal "mo:base/Principal";
import Icrc1Ledger "canister:mettal_token_ledger";
import Result "mo:base/Result";
import Env "env";
import Error "mo:base/Error";
import Debug "mo:base/Debug";

actor {


  type mintArgs = {
    amount : Nat;
    toAccount : Icrc1Ledger.Account;
  };

  type burnArgs = {
    amount : Nat;
    fromAccount : Icrc1Ledger.Account;
  };

  
  let owner : Principal = Principal.fromText(Env.owner);
  let minter : Principal = Principal.fromText(Env.minter);



  public shared(msg) func mintTokens(args:mintArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
    let caller = msg.caller;
    if (caller != owner) {
      return #err("Unauthorized: only the owner can mint tokens");
    };

      let transferArgs : Icrc1Ledger.TransferArg = {
      memo = null;
      amount = args.amount;
      from_subaccount = null;
      fee = null;
      to = args.toAccount;
      created_at_time = null;
    };
 

    try {
      let transferResult = await Icrc1Ledger.icrc1_transfer(transferArgs);
      switch (transferResult) {
        case (#Err(transferError)) {
          return #err("Couldn't mint tokens:\n" # debug_show (transferError));
        };
        case (#Ok(blockIndex)) { return #ok blockIndex };
      };
    } catch (error : Error) {
      return #err("Reject message: " # Error.message(error));
    };
  };

public shared(msg) func burnTokens(args:burnArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
    if (msg.caller != owner) {
      return #err("Unauthorized: only the owner can burn tokens");
    };

    let transferArgs : Icrc1Ledger.TransferFromArgs  = {
      memo = null;
      amount =  args.amount;
      from = args.fromAccount;
      to = {owner = minter; subaccount = null};
      fee = null;
      created_at_time = null;
      spender_subaccount = null;
    };

    Debug.print(debug_show (transferArgs));

    try {
      let transferResult = await Icrc1Ledger.icrc2_transfer_from(transferArgs);

      switch (transferResult) {
        case (#Err(transferError)) {
          return #err("Couldn't burn tokens:\n" # debug_show (transferError));
        };
        case (#Ok(blockIndex)) { return #ok blockIndex };
      };
    } catch (error : Error) {
      return #err("Reject message: " # Error.message(error));
    };
  };


    public func getBalance(account: Principal) : async Result.Result<Nat, Text> {
      
    let accountBalance = {
      owner = account;
      subaccount = null;
    };

    try {
      let balance = await Icrc1Ledger.icrc1_balance_of(accountBalance);
      #ok(balance)
    } catch (error : Error) {
      #err("Failed to get balance: " # Error.message(error))
    };
  };

  
}