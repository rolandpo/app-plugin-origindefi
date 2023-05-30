#include "origin_ether_plugin.h"

static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));

    printf_hex_array("Incoming parameter: ", PARAMETER_LENGTH, msg->parameter);
    if (context->selectorIndex == CURVE_EXCHANGE) {
        if (msg->parameter[PARAMETER_LENGTH-1] != 0) {
            printf_hex_array("OETH SELECTED: ",  ADDRESS_LENGTH, OETH_ADDRESS);
            memcpy(context->contract_address_sent,
                OETH_ADDRESS,
                ADDRESS_LENGTH);
        } else {
            printf_hex_array("ETH SELECTED: ",  ADDRESS_LENGTH, NULL_ETH_ADDRESS);
            memcpy(context->contract_address_sent,
                NULL_ETH_ADDRESS,
                ADDRESS_LENGTH);
        }
    } else {
        memcpy(context->contract_address_sent,
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
            ADDRESS_LENGTH);
    }
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
}

static void handle_token_received(ethPluginProvideParameter_t *msg,
                                  origin_ether_parameters_t *context) {
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
    if (context->selectorIndex == CURVE_EXCHANGE) {
        if (msg->parameter[PARAMETER_LENGTH-1] != 0) {
            memcpy(context->contract_address_received,
                OETH_ADDRESS,
                ADDRESS_LENGTH);
        } else {
            memcpy(context->contract_address_received,
                NULL_ETH_ADDRESS,
                ADDRESS_LENGTH);
        }
    } else {
        memcpy(context->contract_address_received,
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
           ADDRESS_LENGTH);
    }
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
}

static void handle_amount_sent(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
}

static void handle_min_amount_received(ethPluginProvideParameter_t *msg,
                                   origin_ether_parameters_t *context) {
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
}

/*static void handle_min_oeth_received(ethPluginProvideParameter_t *msg,
                                   origin_ether_parameters_t *context) {
    memcpy(context->min_oeth_received, msg->parameter, PARAMETER_LENGTH);
}*/

/*static void handle_min_units_received(ethPluginProvideParameter_t *msg,
                                   origin_ether_parameters_t *context) {
    memcpy(context->min_units_received, msg->parameter, PARAMETER_LENGTH);
}*/

/*static void handle_amount_approved(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    memcpy(context->amount_approved, msg->parameter, INT256_LENGTH);
}*/

// signature: deposit(), zapper: 0x9858e47bcbbe6fbac040519b02d7cd4b2c470c66
static void handle_zapper_deposit_eth(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    switch (context->next_param) {
        case NONE:
            break;
        default:
            PRINTF("Param not supported: %d\n", context->next_param);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

// signature: depositSFRXETH(uint256 amount,uint256 minOETH), zapper: 0x9858e47bcbbe6fbac040519b02d7cd4b2c470c66
static void handle_zapper_deposit_sfrxeth(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    switch (context->next_param) {
        case AMOUNT_SENT:
            handle_amount_sent(msg, context);
            context->next_param = MIN_AMOUNT_RECEIVED;
            break;
        case MIN_AMOUNT_RECEIVED:
            handle_min_amount_received(msg, context);
            context->next_param = NONE;
            break;
        case NONE:
            break;
        default:
            PRINTF("Param not supported\n");
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

// signature: mint(address _asset,uint256 _amount,uint256 _minimumOusdAmount), vault: 0x39254033945AA2E4809Cc2977E7087BEE48bd7Ab
static void handle_vault_mint(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    switch (context->next_param) {
        case TOKEN_SENT:
            handle_token_sent(msg, context);
            context->next_param = AMOUNT_SENT;
            break;
        case AMOUNT_SENT:
            handle_amount_sent(msg, context);
            context->next_param = MIN_AMOUNT_RECEIVED;
            break;
        case MIN_AMOUNT_RECEIVED:
            handle_min_amount_received(msg, context);
            context->next_param = NONE;
            break;
        case NONE:
            break;
        default:
            PRINTF("Param not supported\n");
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

// signature: redeem(uint256 _amount,uint256 _minimumUnitAmount), vault: 0x39254033945AA2E4809Cc2977E7087BEE48bd7Ab
static void handle_vault_redeem(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    switch (context->next_param) {
        case AMOUNT_SENT:
            handle_amount_sent(msg, context);
            context->next_param = MIN_AMOUNT_RECEIVED;
            break;
        case MIN_AMOUNT_RECEIVED:
            handle_min_amount_received(msg, context);
            context->next_param = NONE;
            break;
        case NONE:
            break;
        default:
            PRINTF("Param not supported\n");
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

// signature: exchange(int128 i,int128 j,uint256 _dx,uint256 _min_dy) curve pool: 0x94b17476a93b3262d87b9a326965d1e91f9c13e7
static void handle_curve_exchange(ethPluginProvideParameter_t *msg, origin_ether_parameters_t *context) {
    switch (context->next_param) {
        case TOKEN_SENT:
            handle_token_sent(msg, context);
            context->next_param = TOKEN_RECEIVED;
            break;
        case TOKEN_RECEIVED:
            handle_token_received(msg, context);
            context->next_param = AMOUNT_SENT;
            break;
        case AMOUNT_SENT:
            handle_amount_sent(msg, context);
            context->next_param = MIN_AMOUNT_RECEIVED;
            break;
        case MIN_AMOUNT_RECEIVED:
            handle_min_amount_received(msg, context);
            context->next_param = NONE;
            break;
        case NONE:
            break;
        default:
            PRINTF("Param not supported\n");
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}

void handle_provide_parameter(void *parameters) {
    ethPluginProvideParameter_t *msg = (ethPluginProvideParameter_t *) parameters;
    origin_ether_parameters_t *context = (origin_ether_parameters_t *) msg->pluginContext;
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);

    msg->result = ETH_PLUGIN_RESULT_OK;

    switch (context->selectorIndex) {
        case ZAPPER_DEPOSIT_ETH: {
            handle_zapper_deposit_eth(msg, context);
            break;
        }
        case ZAPPER_DEPOSIT_SFRXETH: {
            handle_zapper_deposit_sfrxeth(msg, context);
            break;
        }
        case VAULT_MINT: {
            handle_vault_mint(msg, context);
            break;
        }
        case VAULT_REDEEM: {
            handle_vault_redeem(msg, context);
            break;
        }
        case CURVE_EXCHANGE: {
            handle_curve_exchange(msg, context);
            break;
        }
        default:
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}