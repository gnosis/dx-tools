# Dutch X Rinkeby CLI (Command Line Interface) 
This project is just an example on how to use the CLI, and also is meant to be
used for interacting with the Dutch Exchange in Rinkeby for testing.

> The CLI was created for testing porpoused only, so some command might work 
> different than expected, anyways, comment any issues with the CLI so we can
> improve it over time.

For aditional information and for reference, check out the following 
repositories:

* [Gnosis Blog](https://blog.gnosis.pm/tagged/dutchx): Learn about Dutch X in 
Gnosis Blog, were you will find a series of posts about it.
* [Gitter Channel](https://gitter.im/gnosis/DutchX): Participate in the gitter channel.
* [Github: dx-contracts](https://github.com/gnosis/dx-contracts): Smart 
contracts of the Duch X
* [Github: dx-examples-api](https://github.com/gnosis/dx-examples-api): 
Example project and documentation on how to use the Dutch X API.
* [Github: dx-examples-api](https://github.com/gnosis/dx-examples-liquidity-bots): 
Check an example on how to run the liquidity bots and more details about the CLI.
* [Github: dx-services](https://github.com/gnosis/dx-services): Services, 
repositories and bots to interact with DX.
* [Github: dx-react](https://github.com/gnosis/dx-react): Front end web 
application for the Dutch X seller interface


## Get started with the CLI

First install docker:
* [https://docs.docker.com/install/]()


```bash
# Clone repo
git clone https://github.com/gnosis/dx-example-cli-rinkeby.git

# Allow the CLI script to be executed
chmod +x cli

# Run help to get all the commands avalible
#   NOTE: The 1st time you run the command, it will take a litle time because
#    it must download the Docker image.
./cli -h
```

## Get token list
Get all avaliable tokens in the DX
```bash
./cli tokens
```

## Get markets
Get all the token pairs in the DX
```bash
./cli markets
```

## State of the auction
Get information about the current auction of a given token pair.
```bash
./cli state WETH-RDN
```

## Get price
There are several prices, depending on what we need:

```bash
# Current price of an ongoing auction
#   This price is the price biders use (it's going down)
#   A N/A means there is no price (i.e. an auction that didn't run, so  you 
#   cannot bid).
./cli price WETH-RDN

# Price in USD for a number of tokens
#   It will use the closing price and the Ether oracle
./cli usd-price 1 RDN

# Closing prices
#   It'll show the last N closing prices
./cli closing-prices WETH-RDN


# Price of an external exchange (i.e. 'binance', 'huobi', 'kraken', 'bitfinex')
#   This is not part of the DX. It's just a reference.
./cli market-price WETH-RDN
```

## Get auctions
Show the information of the auctions that cleared in a given period of time.

Filter by dates:

```bash
# Get todays auctions
./cli auctions --period today

# Get last 7 days auctions
./cli auctions --period week

# Get this week's auctions
./cli auctions --period week

# Get last week's auctions
./cli auctions --period last-week

# Get auctions between two dates 
./cli auctions --from-date=25-05-2018 --to-date=26-05-2018
```

You can export the result into a CSV file (it'll include some extra info):
```bash
# Export the result to a file
./cli auctions --from-date=25-05-2018 --to-date=26-05-2018 --file=auctions.csv
```

## Get trades

Show the information of the trades that were executed in a given period of time.

```bash
# Get todays auctions
./cli trades --period today

# Get last 7 days auctions
./cli trades --period week

# Get this week's auctions
./cli trades --period week

# Get last week's auctions
./cli trades --period last-week

# Get auctions between two dates 
./cli trades --from-date=25-05-2018 --to-date=26-05-2018
```

Aditionally, you can applu any of this filters:
```bash
# Filter by token
#   It will filter by trades of auctions that contain the given token
./cli trades --period today --token RDN

# Filter by sell token
#   It will filter by trades of auctions that contain the given token as a sell
#   token
./cli trades --period today --token RDN

# Filter by buy token
#   It will filter by trades of auctions that contain the given token as a buy
#   token
./cli trades --period today --token RDN

# Filter by auction index
#   It will filter by trades of auctions that contain the given token as a buy
#   token
./cli trades --period today --auction-index 24

# Filter by account
#   It will filter by trades of the given account address
./cli trades --period today --auction-index 24
```

You can export the result into a CSV file (it'll include some extra info):
```bash
# Export the result to a file
./cli trades --from-date=25-05-2018 --to-date=26-05-2018 --file=auctions.csv
```

# Trade in the DX
To be able to trade, you have to edit the `cli` file and modify the `MNEMONIC`
variable and use your own mnemonic.

## Send tokens
This method is not part of the DX, but it cames handy for testing.

It will send tokens ERC20 from one account to another.

```bash
# Send 0.8 RDN to a given account
./cli send 0.8 RDN 0x627306090abab3a6e1400e9345bc60c78a8bef57
```

# Deposit and Withdraw
You can deposit tokens and withdraw them by using the following commands:

```bash
# Deposit WETH
#   It will wrap Ether automatically if you don't have enough WETH balance
./cli deposit 0.35 WETH

# Deposit any other token
#   Same way :)
./cli deposit 12 RDN


# Withdraw
./cli withdraw 0.35 WETH
./cli withdraw 12 RDN
```

# Trade in the DX
```bash
# Sell
#   Sell 0.1 WETH in the next WETH-RDN auction
./cli sell 0.1 WETH-RDN

# Buy
#   Buy 12 RDN in the current auction
./cli sell 12 WETH-RDN

# Claim the seller tokens
#   Once the auction clears
./cli claim-seller WETH-RDN

# Claim the buyer tokens
#   Once the auction clears
./cli claim-seller WETH-RDN
```
