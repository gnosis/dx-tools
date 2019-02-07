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

const PRICE_REPO = {
  factory: 'src/repositories/PriceRepo/PriceRepoImpl',
  priceFeedStrategiesDefault: {
    strategy: 'sequence',
    feeds: ['binance', 'huobi', 'kraken', 'bitfinex', 'idex', 'hitbtc', 'liquid']
  },
  priceFeedStrategies: {
    'WETH-OMG': {
      strategy: 'sequence',
      feeds: ['binance', 'huobi', 'bitfinex']
    },
    'WETH-RDN': {
      strategy: 'sequence',
      feeds: ['huobi', 'binance', 'bitfinex']
    },
    'DAI-MKR': {
      strategy: 'sequence',
      feeds: ['hitbtc', 'bitfinex']
    },
    'WETH-DAI': {
      strategy: 'sequence',
      feeds: ['hitbtc', 'bitfinex']
    },
    'WETH-MKR': {
      strategy: 'sequence',
      feeds: ['hitbtc', 'bitfinex']
    },
    'WETH-GEN': {
      strategy: 'sequence',
      feeds: ['idex', 'liquid']
    }
  },
  priceFeeds: {
    binance: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoBinance'
    },
    huobi: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoHuobi'
    },
    kraken: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoKraken',
      url: 'https://api.kraken.com',
      version: '0'
    },
    bitfinex: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoBitfinex'
    },
    idex: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoIdex'
    },
    hitbtc: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoHitbtc'
    },
    liquid: {
      factory: 'src/repositories/PriceRepo/feeds/PriceRepoLiquid'
    }
  },
  strategies: {
    sequence: {
      factory: 'src/repositories/PriceRepo/strategies/sequence'
    }
  }
}

// Buy bots
const BUY_BOT_MAIN = {
  name: 'Main buyer bot',
  factory: 'src/bots/BuyLiquidityBot',
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
const WATCH_EVENTS_BOT = {
  name: 'Watch events bot',
  markets: MARKETS,
  factory: 'src/bots/WatchEventsBot'
}

const DEPOSIT_BOT = {
  name: 'Deposit bot',
  factory: 'src/bots/DepositBot',
  tokens: BOT_TOKENS,
  accountIndex: MAIN_BOT_ACCOUNT,
  notifications,
  // You can use this to have some time to manually withdraw funds
  inactivityPeriods: [{
    from: '11:30',
    to: '12:00'
  }, {
    from: '15:30',
    to: '16:00'
  }],
  checkTimeInMilliseconds: 5 * 60 * 1000 // 5min
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
    WATCH_EVENTS_BOT,
    DEPOSIT_BOT
  ],

  BUY_LIQUIDITY_RULES_DEFAULT,
  BOTS_API_PORT,

  // Price feed config
  PRICE_REPO
}
