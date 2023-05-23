#include "origin_ether_plugin.h"

// Sets the first screen to display.
void handle_query_contract_id(void *parameters) {
  ethQueryContractID_t *msg = (ethQueryContractID_t *)parameters;
  const origin_ether_parameters_t *context =
      (const origin_ether_parameters_t *)msg->pluginContext;
  // msg->name will be the upper sentence displayed on the screen.
  // msg->version will be the lower sentence displayed on the screen.

  // For the first screen, display the plugin name.
  strlcpy(msg->name, PLUGIN_NAME, msg->nameLength);

  switch (context->selectorIndex) {
  case ZAPPER_DEPOSIT_ETH:
  case ZAPPER_DEPOSIT_SFRXETH:
  case VAULT_MINT:
    strlcpy(msg->version, "Mint", msg->versionLength);
    break;
  case VAULT_REDEEM:
    strlcpy(msg->version, "Redeem", msg->versionLength);
    break;
  case CURVE_EXCHANGE:
    strlcpy(msg->version, "Swap", msg->versionLength);
    break;
  default:
    PRINTF("Selector Index :%d not supported\n", context->selectorIndex);
    msg->result = ETH_PLUGIN_RESULT_ERROR;
    return;
  }

  msg->result = ETH_PLUGIN_RESULT_OK;
}