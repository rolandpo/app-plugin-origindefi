"use strict";

require("core-js/stable");
require("regenerator-runtime/runtime");
var _test = require("./test.fixture");
var _ethers = require("ethers");
var _utils = require("ethers/lib/utils");
// EDIT THIS: Replace with your contract address
const contractAddr = "0x9858e47bcbbe6fbac040519b02d7cd4b2c470c66";
// EDIT THIS: Replace `boilerplate` with your plugin name
const pluginName = "originether";
const testNetwork = "ethereum";
const abi_path = `../networks/${testNetwork}/${pluginName}/abis/` + contractAddr + '.json';
const abi = require(abi_path);

// Test from replayed transaction: https://etherscan.io/tx/0x092c7c855688ba42ddc61c614ee07a1f1ae4775a556de35dbce2c56345349b53
// EDIT THIS: build your own test
_test.nano_models.forEach(function (model) {
  jest.setTimeout(50000);
  test('[Nano ' + model.letter + '] Mint OETH with sfrxETH', (0, _test.zemu)(model, async (sim, eth) => {
    // The rawTx of the tx up above is accessible through: https://etherscan.io/getRawTx?tx=0xb27a69cd3190ad0712da39f6b809ecc019ecbc319d3c17169853270226d18a8a
    const serializedTx = (0, _test.txFromEtherscan)("0x02f902f30181c48405f5e100850c50d9cc55830a362d9470fce97d671e81080ca3ab4cc7a59aac2e11713780b902846a7612020000000000000000000000009858e47bcbbe6fbac040519b02d7cd4b2c470c6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000947d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c00000000000000000000000000000000000000000000000000000000000000044d443e97d000000000000000000000000000000000000000000000007d029606bdba817d9000000000000000000000000000000000000000000000007d011186b654c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008200000000000000000000000015ff3859af506d6e4d7e5fdf335628fc1e3ef1ce00000000000000000000000000000000000000000000000000000000000000000112a6e8432d8d7499f2f2cf7e7993089b8dcde7db1eb4ae6ee8c7bf4fb71fd887611a0d6bcc36645e4b7c253eb26c892678bcee62737678b184878df7f0a02eaa20000000000000000000000000000000000000000000000000000000000000c080a0d22538784fc72479f3661a6eb3690de710a819e6cf2c266e2d3aa5e8a40c27a1a07d76aac049c877ab063e8d48f5423a86146a7f76f25fd3d6535f6c651d7a143e");
    const tx = eth.signTransaction("44'/60'/0'/0", serializedTx);
    const right_clicks = model.letter === 'S' ? 12 : 6;

    // Wait for the application to actually load and parse the transaction
    await (0, _test.waitForAppScreen)(sim);
    // Navigate the display by pressing the right button `right_clicks` times, then pressing both buttons to accept the transaction.
    await sim.navigateAndCompareSnapshots('.', model.name + '_zapper_deposit_sfrxeth', [right_clicks, 0]);
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