import "core-js/stable";
import "regenerator-runtime/runtime";
import { waitForAppScreen, zemu, genericTx, nano_models,SPECULOS_ADDRESS, txFromEtherscan} from './test.fixture';
import { ethers } from "ethers";
import { parseEther, parseUnits} from "ethers/lib/utils";

// EDIT THIS: Replace with your contract address
const contractAddr = "0x87650d7bbfc3a9f10587d7778206671719d9910d";
// EDIT THIS: Replace `boilerplate` with your plugin name
const pluginName = "origindefi";
const testNetwork = "ethereum";
const abi_path = `../networks/${testNetwork}/${pluginName}/abis/` + contractAddr + '.json';
const abi = require(abi_path);

// Test from replayed transaction: https://etherscan.io/tx/0xb01c59662cb3f94a7d7eecf64669360ac6b7878063d8a2d94ccb1f0f2bdff143
// EDIT THIS: build your own test
nano_models.forEach(function(model) {
  jest.setTimeout(100000)
  test('[Nano ' + model.letter + '] Exchange OUSD for DAI', zemu(model, async (sim, eth) => {

  // The rawTx of the tx up above is accessible through: https://etherscan.io/getRawTx?tx=0xb01c59662cb3f94a7d7eecf64669360ac6b7878063d8a2d94ccb1f0f2bdff143
  const serializedTx = txFromEtherscan("0x02f8f301820267843b9aca008519ec7019e48306b48d9487650d7bbfc3a9f10587d7778206671719d9910d80b884a6417ed60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000d9b17e813d9e085ffad600000000000000000000000000000000000000000000d90df249c515b3118395c080a0312c3e1c5f652a97adb857eece5ea1474661e4252fc23a13fbde177ffccfc0cfa026552c245fbfada31ebf86648ef4455b9f49041d0ec466146cf28f2eaca02d72");

  const tx = eth.signTransaction(
    "44'/60'/0'/0",
    serializedTx,
  );

  const right_clicks = model.letter === 'S' ? 9 : 5;

  // Wait for the application to actually load and parse the transaction
  await waitForAppScreen(sim);
  // Navigate the display by pressing the right button `right_clicks` times, then pressing both buttons to accept the transaction.
  await sim.navigateAndCompareSnapshots('.', model.name + '_curve_pool_exchange_ousd_for_dai', [right_clicks, 0]);

  await tx;
  }));
});

// Test from replayed transaction: https://etherscan.io/tx/0xee3caa668e5cc936aab2263ff88485864f7c589fa8cfa5839858858452b654f7
// EDIT THIS: build your own test
nano_models.forEach(function(model) {
  jest.setTimeout(100000)
  test('[Nano ' + model.letter + '] Exchange ETH for OETH', zemu(model, async (sim, eth) => {

  // The rawTx of the tx up above is accessible through: https://etherscan.io/getRawTx?tx=0xee3caa668e5cc936aab2263ff88485864f7c589fa8cfa5839858858452b654f7
  const serializedTx = txFromEtherscan("0x02f8f90105843b9aca00852152e8d9c88302d24a9494b17476a93b3262d87b9a326965d1e91f9c13e788429d069189e00000b8843df0212400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000429d069189e00000000000000000000000000000000000000000000000000000429059f4c8f1460bc001a0e8e0485b020454731eb65e905ecd318c82d9f44c0e3adc84a81e4662464c1f89a02d8bfb04fe59a1a43009603eb481351ce6f3549778afe36757142196ef36ffe3");

  const tx = eth.signTransaction(
    "44'/60'/0'/0",
    serializedTx,
  );

  const right_clicks = model.letter === 'S' ? 9 : 5;

  // Wait for the application to actually load and parse the transaction
  await waitForAppScreen(sim);
  // Navigate the display by pressing the right button `right_clicks` times, then pressing both buttons to accept the transaction.
  await sim.navigateAndCompareSnapshots('.', model.name + '_curve_exchange_eth_for_oeth', [right_clicks, 0]);

  await tx;
  }));
});

// Test from constructed transaction
// EDIT THIS: build your own test
/*nano_models.forEach(function(model) {
  jest.setTimeout(20000)
  test('[Nano ' + model.letter + '] Swap Exact Eth For Tokens', zemu(model, async (sim, eth) => {
  const contract = new ethers.Contract(contractAddr, abi);

  // Constants used to create the transaction
  // EDIT THIS: Remove what you don't need
  const amountOutMin = parseUnits("28471151959593036279", 'wei');
  const WETH = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
  const SUSHI = "0x6b3595068778dd592e39a122f4f5a5cf09c90fe2";
  const path = [WETH, SUSHI];
  const deadline = Number(1632843280);
  // We set beneficiary to the default address of the emulator, so it maches sender address
  const beneficiary = SPECULOS_ADDRESS;

  // EDIT THIS: adapt the signature to your method
  // signature: swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
  // EDIT THIS: don't call `swapExactETHForTokens` but your own method and adapt the arguments.
  const {data} = await contract.populateTransaction.swapExactETHForTokens(amountOutMin, path, beneficiary ,deadline);

  // Get the generic transaction template
  let unsignedTx = genericTx;
  // Modify `to` to make it interact with the contract
  unsignedTx.to = contractAddr;
  // Modify the attached data
  unsignedTx.data = data;
  // EDIT THIS: get rid of this if you don't wish to modify the `value` field.
  // Modify the number of ETH sent
  unsignedTx.value = parseEther("0.1");

  // Create serializedTx and remove the "0x" prefix
  const serializedTx = ethers.utils.serializeTransaction(unsignedTx).slice(2);

  const tx = eth.signTransaction(
    "44'/60'/0'/0",
    serializedTx
  );

  const right_clicks = model.letter === 'S' ? 7 : 5;

  // Wait for the application to actually load and parse the transaction
  await waitForAppScreen(sim);
  // Navigate the display by pressing the right button 10 times, then pressing both buttons to accept the transaction.
  // EDIT THIS: modify `10` to fix the number of screens you are expecting to navigate through.
  await sim.navigateAndCompareSnapshots('.', model.name + '_swap_exact_eth_for_tokens', [right_clicks, 0]);

  await tx;
  }));
});*/

