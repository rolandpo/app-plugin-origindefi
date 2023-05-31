#include "origin_defi_plugin.h"

static void handle_token_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
    memset(context->contract_address_sent, 0, sizeof(context->contract_address_sent));

    printf_hex_array("Incoming parameter: ", PARAMETER_LENGTH, msg->parameter);
    if (context->selectorIndex == CURVE_POOL_EXCHANGE) {
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
                case 0:
                    memcpy(context->contract_address_sent,
                        NULL_ETH_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 1:
                    memcpy(context->contract_address_sent,
                        OETH_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                default:
                    PRINTF("Param not supported\n");
                    break;
            }
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
                case 0:
                    memcpy(context->contract_address_sent,
                        OUSD_ADDRESS,
                        ADDRESS_LENGTH);
                case 1:
                    memcpy(context->contract_address_sent,
                        DAI_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 2:
                    memcpy(context->contract_address_sent,
                        USDC_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 3:
                    memcpy(context->contract_address_sent,
                        USDT_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                default:
                    PRINTF("Param not supported\n");
                    break;
            }
        }
    } else {
        memcpy(context->contract_address_sent,
            &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
            ADDRESS_LENGTH);
    }
    printf_hex_array("TOKEN SENT: ", ADDRESS_LENGTH, context->contract_address_sent);
}

static void handle_token_received(ethPluginProvideParameter_t *msg,
                                  origin_defi_parameters_t *context) {
    memset(context->contract_address_received, 0, sizeof(context->contract_address_received));
    if (context->selectorIndex == CURVE_POOL_EXCHANGE) {
        if (memcmp(CURVE_OETH_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
                case 0:
                    memcpy(context->contract_address_received,
                        NULL_ETH_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 1:
                    memcpy(context->contract_address_received,
                        OETH_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                default:
                    PRINTF("Param not supported\n");
                    break;
            }
        } else if (memcmp(CURVE_OUSD_POOL_ADDRESS, msg->pluginSharedRO->txContent->destination, ADDRESS_LENGTH) == 0) {
            switch (msg->parameter[PARAMETER_LENGTH-1]) {
                case 0:
                    memcpy(context->contract_address_received,
                        OUSD_ADDRESS,
                        ADDRESS_LENGTH);
                case 1:
                    memcpy(context->contract_address_received,
                        DAI_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 2:
                    memcpy(context->contract_address_received,
                        USDC_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                case 3:
                    memcpy(context->contract_address_received,
                        USDT_ADDRESS,
                        ADDRESS_LENGTH);
                    break;
                default:
                    PRINTF("Param not supported\n");
                    break;
            }
        }
    } else {
        memcpy(context->contract_address_received,
           &msg->parameter[PARAMETER_LENGTH - ADDRESS_LENGTH],
           ADDRESS_LENGTH);
    }
    printf_hex_array("TOKEN RECEIVED: ", ADDRESS_LENGTH, context->contract_address_received);
}

static void handle_amount_sent(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
    memcpy(context->amount_sent, msg->parameter, INT256_LENGTH);
}

static void handle_min_amount_received(ethPluginProvideParameter_t *msg,
                                   origin_defi_parameters_t *context) {
    memcpy(context->min_amount_received, msg->parameter, PARAMETER_LENGTH);
}

// signature: deposit(), zapper: 0x9858e47bcbbe6fbac040519b02d7cd4b2c470c66
static void handle_zapper_deposit_eth(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
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
static void handle_zapper_deposit_sfrxeth(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
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
static void handle_vault_mint(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
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
static void handle_vault_redeem(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
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
static void handle_curve_pool_exchange(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
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

// signature: exchange_multiple(address[9] _route,uint256[3][4] _swap_params,uint256 _amount,uint256 _expected), curve router: 0x99a58482bd75cbab83b27ec03ca68ff489b5788f
static void handle_curve_router_exchange(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
    /*switch (context->next_param) {
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
    }*/
}

static void handle_uniswap_exchange(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
    /*switch (context->next_param) {
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
    }*/
}

static void handle_flipper_exchange(ethPluginProvideParameter_t *msg, origin_defi_parameters_t *context) {
    switch (context->next_param) {
        case AMOUNT_SENT:
            handle_amount_sent(msg, context);
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
    origin_defi_parameters_t *context = (origin_defi_parameters_t *) msg->pluginContext;
    printf_hex_array("oeth plugin provide parameter: ", PARAMETER_LENGTH, msg->parameter);

    msg->result = ETH_PLUGIN_RESULT_OK;

    switch (context->selectorIndex) {
        case ZAPPER_DEPOSIT_ETH:
            handle_zapper_deposit_eth(msg, context);
            break;
        case ZAPPER_DEPOSIT_SFRXETH:
            handle_zapper_deposit_sfrxeth(msg, context);
            break;
        case VAULT_MINT:
            handle_vault_mint(msg, context);
            break;
        case VAULT_REDEEM:
            handle_vault_redeem(msg, context);
            break;
        case CURVE_POOL_EXCHANGE:
        case CURVE_POOL_EXCHANGE_UNDERLYING:
            handle_curve_pool_exchange(msg, context);
            break;
        case CURVE_ROUTER_EXCHANGE_MULTIPLE:
            handle_curve_router_exchange(msg, context);
            break;
        case UNISWAP_ROUTER_EXACT_INPUT:
        case UNISWAP_ROUTER_EXACT_INPUT_SINGLE:
            handle_uniswap_exchange(msg, context);
            break;
        case FLIPPER_BUY_OUSD_WITH_USDT:
        case FLIPPER_SELL_OUSD_FOR_USDT:
        case FLIPPER_BUY_OUSD_WITH_DAI:
        case FLIPPER_SELL_OUSD_FOR_DAI:
        case FLIPPER_BUY_OUSD_WITH_USDC:
        case FLIPPER_SELL_OUSD_FOR_USDC:
            handle_flipper_exchange(msg, context);
            break;
        default:
            PRINTF("Selector Index %d not supported\n", context->selectorIndex);
            msg->result = ETH_PLUGIN_RESULT_ERROR;
            break;
    }
}