import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v0.31.0/index.ts";
import { assertEquals } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "Ensure that <...>",
  async fn(chain: Chain, accounts: Map<string, Account>) {},
});
