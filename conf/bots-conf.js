// Get the markets (configured used environment variables)
//  i.e. MARKETS=RDN-WETH,OMG-WETH
//  See the network-<networkName>.conf files
const MARKETS = _getMarkets()

// Buy bot rules
const BUY_LIQUIDITY_RULES_DEFAULT = [
  // Buy 1/2 if price falls below 99%
  {
    marketPriceRatio: {
      numerator: 99,
      denominator: 100
    },
    buyRatio: {
      numerator: 1,
      denominator: 2
    }
  },

  // Buy the 100% if price falls below 96%
  {
    marketPriceRatio: {
      numerator: 96,
      denominator: 100
    },
    buyRatio: {
      numerator: 1,
      denominator: 1
    }
  }
]

// Buy bots
const MAIN_BOT_ACCOUNT = 0
const BUY_LIQUIDITY_BOTS = [{
  name: 'Main buyer bot',
  markets: MARKETS,
  accountIndex: MAIN_BOT_ACCOUNT,
  rules: BUY_LIQUIDITY_RULES_DEFAULT,
  notifications: [{
    type: 'slack',
    channel: '' // If none provided uses SLACK_CHANNEL_BOT_TRANSACTIONS
  }],
  checkTimeInMilliseconds: 10 * 1000 // 60s
}]

// Sell Bots
const SELL_LIQUIDITY_BOTS = [{
  name: 'Main seller bot',
  markets: MARKETS,
  accountIndex: MAIN_BOT_ACCOUNT,
  notifications: [{
    type: 'slack',
    channel: '' // If none provided uses SLACK_CHANNEL_BOT_TRANSACTIONS
  }],
  checkTimeInMilliseconds: 60 * 1000 // 60s
}]

const EXCHANGE_PRICE_FEED_STRATEGIES_DEFAULT = {
  strategy: 'sequence', // TODO: More strategies can be implemented. i.e. averages, median, ponderated volumes, ...
  feeds: ['binance', 'huobi', 'kraken', 'bitfinex']
}

const EXCHANGE_PRICE_FEED_STRATEGIES = {
  'WETH-RDN': {
    strategy: 'sequence',
    feeds: ['huobi', 'binance', 'bitfinex']
  }
}

// Bots API Port
BOTS_API_PORT = 8081

function _getMarkets () {
  let markets
  const marketsEnv = process.env['MARKETS']
  if (marketsEnv) {
    const marketsArray = marketsEnv.split(',')
    markets = marketsArray.map(marketString => {
      const market = marketString.split('-')
      return {
        tokenA: market[0],
        tokenB: market[1]
      }
    })
  } else {
    throw new Error('The markets environment var is mandatory. i.e. MARKETS=RDN-WETH,OMG-WETH')
  }

  return markets
}


module.exports = {
  // Market and tokens
  MARKETS,
  // ...TOKEN_ADDRESSES,

  // Bot config
  MAIN_BOT_ACCOUNT,
  BUY_LIQUIDITY_RULES_DEFAULT,
  BUY_LIQUIDITY_BOTS,
  SELL_LIQUIDITY_BOTS,
  BOTS_API_PORT,

  // Price feed config
  EXCHANGE_PRICE_FEED_STRATEGIES_DEFAULT,
  EXCHANGE_PRICE_FEED_STRATEGIES,
}