import "core-js/stable";
import "regenerator-runtime/runtime";
import { waitForAppScreen, zemu, genericTx, nano_models,SPECULOS_ADDRESS, txFromEtherscan} from './test.fixture';
import { ethers } from "ethers";
import { parseEther, parseUnits} from "ethers/lib/utils";

// EDIT THIS: Replace with your contract address
const contractAddr = "0x99a58482bd75cbab83b27ec03ca68ff489b5788f";
// EDIT THIS: Replace `boilerplate` with your plugin name
const pluginName = "origindefi";
const testNetwork = "ethereum";
const abi_path = `../networks/${testNetwork}/${pluginName}/abis/` + contractAddr + '.json';
const abi = require(abi_path);

// Test from replayed transaction: https://etherscan.io/tx/0xf04d78ea36435b5a235d3352567e27f405c1a888c663bda7bf4af0ae5a89f2e0
// EDIT THIS: build your own test
nano_models.forEach(function(model) {
  jest.setTimeout(100000)
  test('[Nano ' + model.letter + '] Exchange OUSD for USDC', zemu(model, async (sim, eth) => {

  // The rawTx of the tx up above is accessible through: https://etherscan.io/getRawTx?tx=0xf04d78ea36435b5a235d3352567e27f405c1a888c663bda7bf4af0ae5a89f2e0
  const serializedTx = txFromEtherscan("0x02f901930181df84ad4aa42d850702d9e3538304f4c69468b3465833fb72a70ecdf485e0e4c7bd8665fc4580b90124b858183f000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000800000000000000000000000002f5926896bc7f9432392099bbc66526cea300077000000000000000000000000000000000000000000000087cc853c18273c4cba00000000000000000000000000000000000000000000000000000000947466fe00000000000000000000000000000000000000000000000000000000000000422a8e1e676ec238d8a992307b495b45b3feaa5e860001f4dac17f958d2ee523a2206206994597c13d831ec7000064a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000000000000000000000000000000000000000c001a00ded803b26bfbe4c35d0108a2c5adaa7d35b38c4d8a063384f0b001e3b12bea9a07552d6dea3b1301a2b38cde96ae37ab9512940afbf847eaa6e5f1509a32b0d36");

  const tx = eth.signTransaction(
    "44'/60'/0'/0",
    serializedTx,
  );

  const right_clicks = model.letter === 'S' ? 9 : 5;

  // Wait for the application to actually load and parse the transaction
  await waitForAppScreen(sim);
  // Navigate the display by pressing the right button `right_clicks` times, then pressing both buttons to accept the transaction.
  await sim.navigateAndCompareSnapshots('.', model.name + '_uniswap_exchange_ousd_for_usdc', [right_clicks, 0]);

  await tx;
  }));
});
