
import Principal "mo:base/Principal";
import Icrc1Ledger "canister:mettal_token_ledger";
import Result "mo:base/Result";
import Error "mo:base/Error";
import Debug "mo:base/Debug";

actor {


  type TransferArgs = {
    amount : Nat;
    toAccount : Icrc1Ledger.Account;
  };
  
  let owner : Principal = Principal.fromText("brf6e-32b55-7oacp-ckgnb-w3p7a-6xmxh-c7rw6-dehei-qpby4-2ea5r-jqe");

  public shared(msg) func mintTokens(args:TransferArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
    
    let caller = msg.caller;

    if (caller != owner) {
      return #err("Unauthorized: only the owner can mint tokens");
    };

      let transferArgs : Icrc1Ledger.TransferArg = {
      // can be used to distinguish between transactions
      memo = null;
      // the amount we want to transfer
      amount = args.amount;
      // we want to transfer tokens from the default subaccount of the canister
      from_subaccount = null;
      // if not specified, the default fee for the canister is used
      fee = null;
      // the account we want to transfer tokens to
      to = args.toAccount;
      // a timestamp indicating when the transaction was created by the caller; if it is not specified by the caller then this is set to the current ICP time
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

public shared(msg) func burnTokens(amount: Nat) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
    if (msg.caller != owner) {
      return #err("Unauthorized: only the owner can burn tokens");
    };

    let transferArgs : Icrc1Ledger.TransferArg = {
      memo = null;
      amount = amount;
      from_subaccount = null;
      fee = null;
      to = {owner = owner; subaccount = null};
      created_at_time = null;
    };

    try {
      let transferResult = await Icrc1Ledger.icrc1_transfer(transferArgs);

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