#pragma once

#include "eth_internals.h"
#include "eth_plugin_interface.h"
#include <string.h>

// Number of selectors defined in this plugin. Should match the enum `selector_t`.
// EDIT THIS: Put in the number of selectors your plugin is going to support.
#define NUM_SELECTORS 6
#define PARAMETER_LENGTH 32

// Name of the plugin.
// EDIT THIS: Replace with your plugin name.
#define PLUGIN_NAME "Origin DeFi"

#define TOKEN_SENT_FOUND     1
#define TOKEN_RECEIVED_FOUND 1 << 1

// Number of decimals used when the token wasn't found in the CAL.
#define DEFAULT_DECIMAL WEI_TO_ETHER

// Ticker used when the token wasn't found in the CAL.
#define DEFAULT_TICKER ""

#define OETH_TICKER "OETH"
#define OETH_DECIMALS WEI_TO_ETHER

#define OUSD_TICKER "OUSD"

#define SFRXETH_TICKER "sfrxETH"
#define FRXETH_TICKER "frxETH"
#define ETH_UNITS_TICKER "UNITS"

// Enumeration of the different selectors possible.
// Should follow the exact same order as the array declared in main.c
// EDIT THIS: Change the naming (`selector_t`), and add your selector names.
typedef enum {
    ZAPPER_DEPOSIT_ETH,
    ZAPPER_DEPOSIT_SFRXETH,
    VAULT_MINT,
    VAULT_REDEEM,
    CURVE_EXCHANGE,
} selector_t;

typedef enum {
    SEND_SCREEN,
    RECEIVE_SCREEN,
    WARN_SCREEN,
    ERROR,
} screens_t;

extern const uint8_t NULL_ETH_ADDRESS[ADDRESS_LENGTH];
extern const uint8_t OETH_ADDRESS[ADDRESS_LENGTH];
extern const uint8_t OETH_VAULT_ADDRESS[ADDRESS_LENGTH];

#define ADDRESS_IS_NETWORK_TOKEN(_addr) (!memcmp(_addr, NULL_ETH_ADDRESS, ADDRESS_LENGTH))
#define ADDRESS_IS_OETH(_addr) (!memcmp(_addr, OETH_ADDRESS, ADDRESS_LENGTH))
//#define ADDRESS_IS_FRXETH(_addr) (!memcmp(_addr, FRXETH_ADDRESS, ADDRESS_LENGTH))

// Enumeration used to parse the smart contract data.
// EDIT THIS: Adapt the parameter names here.
typedef enum {
    TOKEN_SENT,
    TOKEN_RECEIVED,
    AMOUNT_SENT,
    MIN_AMOUNT_RECEIVED,
    //MIN_OETH_RECEIVED,
    //MIN_UNITS_RECEIVED,
    UNEXPECTED_PARAMETER,
    NONE,
} parameter;

// EDIT THIS: Rename `BOILERPLATE` to be the same as the one initialized in `main.c`.
extern const uint32_t ORIGIN_ETHER_SELECTORS[NUM_SELECTORS];

// Shared global memory with Ethereum app. Must be at most 5 * 32 bytes.
// EDIT THIS: This struct is used by your plugin to save the parameters you parse. You
// will need to adapt this struct to your plugin.
typedef struct origin_ether_parameters_t {
    // For display.

    uint8_t amount_sent[INT256_LENGTH];
    //uint8_t min_oeth_received[INT256_LENGTH];
    //uint8_t min_units_received[INT256_LENGTH];
    uint8_t min_amount_received[INT256_LENGTH];
    //uint8_t amount_approved[INT256_LENGTH];
    uint8_t contract_address_sent[ADDRESS_LENGTH];
    uint8_t contract_address_received[ADDRESS_LENGTH];
    char ticker_sent[MAX_TICKER_LEN];
    char ticker_received[MAX_TICKER_LEN];

    uint8_t tokens_found;
    uint8_t decimals_sent;
    uint8_t decimals_received;
    uint8_t skip;

    bool valid;
    uint8_t amount_length;

    // For parsing data.
    uint8_t next_param;  // Set to be the next param we expect to parse.
    //uint16_t checkpoint;
    //uint16_t offset;     // Offset at which the array or struct starts.
    //bool go_to_offset;   // If set, will force the parsing to iterate through parameters until
                         // `offset` is reached.

    // For both parsing and display.
    selector_t selectorIndex;
} origin_ether_parameters_t;

// Piece of code that will check that the above structure is not bigger than 5 * 32. Do not remove
// this check.
_Static_assert(sizeof(origin_ether_parameters_t) <= 5 * 32, "Structure of parameters too big.");

void handle_provide_parameter(void *parameters);
void handle_query_contract_ui(void *parameters);
void handle_init_contract(void *parameters);
void handle_finalize(void *parameters);
void handle_provide_token(void *parameters);
void handle_query_contract_id(void *parameters);

static inline void sent_network_token(origin_ether_parameters_t *context) {
    context->decimals_sent = WEI_TO_ETHER;
    context->tokens_found |= TOKEN_SENT_FOUND;
}

static inline void received_network_token(origin_ether_parameters_t *context) {
    context->decimals_received = WEI_TO_ETHER;
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
}

static inline void sent_oeth(origin_ether_parameters_t *context) {
    context->decimals_sent = OETH_DECIMALS;
    context->tokens_found |= TOKEN_SENT_FOUND;
}

static inline void received_oeth(origin_ether_parameters_t *context) {
    context->decimals_received = OETH_DECIMALS;
    context->tokens_found |= TOKEN_RECEIVED_FOUND;
}

static inline void printf_hex_array(const char *title __attribute__((unused)),
                                    size_t len __attribute__((unused)),
                                    const uint8_t *data __attribute__((unused))) {
    PRINTF(title);
    for (size_t i = 0; i < len; ++i) {
        PRINTF("%02x", data[i]);
    };
    PRINTF("\n");
}