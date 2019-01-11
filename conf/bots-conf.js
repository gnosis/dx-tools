// Get the markets (configured used environment variables)
//  i.e. MARKETS=RDN-WETH,OMG-WETH
//  See the network-<networkName>.conf files
const MARKETS = _getMarkets()
const DEFAULT_GAS_PRICE_USED = 'fast' // safeLow, average, fast

const MAIN_BOT_ACCOUNT = 0

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
cons BUY_BOT_MAIN = {
  name: 'Main buyer bot',
  factory: 'src/bots/BuyLiquidityBot'
  markets: MARKETS,
  accountIndex: MAIN_BOT_ACCOUNT,
  rules: BUY_LIQUIDITY_RULES_DEFAULT,
  notifications: [{
    type: 'slack',
    channel: '' // If none provided uses SLACK_CHANNEL_BOT_TRANSACTIONS
  }],
  checkTimeInMilliseconds: 60 * 1000 // 60s
}

// Sell Bots
const SELL_BOT_MAIN = {
  name: 'Main seller bot',
  factory: 'src/bots/SellLiquidityBot',
  markets: MARKETS,
  accountIndex: MAIN_BOT_ACCOUNT,
  notifications: [{
    type: 'slack',
    channel: '' // If none provided uses SLACK_CHANNEL_BOT_TRANSACTIONS
  }],
  checkTimeInMilliseconds: 60 * 1000 // 60s
}

const BALANCE_CHECK_BOT = {
  name: 'Balance check bot',
  factory: 'src/bots/BalanceCheckBot',
  tokens: BOT_TOKENS,
  accountIndex: MAIN_BOT_ACCOUNT,
  notifications,
  minimumAmountForEther: 0.4,
  minimumAmountInUsdForToken: 5000
}

const HIGH_SELL_VOLUME_BOT = {
  name: 'High sell volume bot',
  factory: 'src/bots/HighSellVolumeBot',
  markets: BOT_MARKETS,
  accountIndex: MAIN_BOT_ACCOUNT,
  notifications
}

// Watch events and notify the event bus
//   - Other bots, like the sell bot depends on it
const WATCH_EVENTS_BOTS = {
  name: 'Watch events bot',
  markets: MARKETS,
  factory: 'src/bots/WatchEventsBot'
}

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
  DEFAULT_GAS_PRICE_USED,

  // Market and tokens
  MARKETS,
  // ...TOKEN_ADDRESSES,

  // Bots config
  BOTS: [
    BUY_BOT_MAIN,
    SELL_BOT_MAIN,
    BALANCE_CHECK_BOT,
    HIGH_SELL_VOLUME_BOT,
    WATCH_EVENTS_BOTS
  ],

  BUY_LIQUIDITY_RULES_DEFAULT,
  BOTS_API_PORT,

  // Price feed config
  EXCHANGE_PRICE_FEED_STRATEGIES_DEFAULT,
  EXCHANGE_PRICE_FEED_STRATEGIES,
}
