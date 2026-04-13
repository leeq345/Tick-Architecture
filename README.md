# Tick Architecture

A KDB+/q implementation of a real-time market data tick plant, demonstrating the classic publish-subscribe architecture used in financial data systems.

## Overview

This project implements a full tick stack — from a synthetic data feed through to in-memory real-time storage, on-disk historical storage, and a real-time summary layer. It processes simulated trade and quote data for a set of equities across multiple exchanges.

## Architecture

```
                    ┌─────────────┐
                    │   feed.q    │  Synthetic market data generator
                    └──────┬──────┘
                           │ upd (trade/quote)
                    ┌──────▼──────┐
                    │   tick.q    │  Tick plant — pub/sub hub (port 5010)
                    └──┬──────┬───┘
           ┌───────────┘      └──────────────┐
    ┌──────▼──────┐                  ┌───────▼──────┐
    │    rdb.q    │  In-memory RDB   │    rts.q     │  Real-time summary
    │  (port 5011)│                  │  (port 5013) │
    └──────┬──────┘                  └──────────────┘
           │ end-of-day save
    ┌──────▼──────┐
    │    hdb.q    │  Historical DB (port 5012)
    │    sym/     │  Partitioned by date on disk
    └─────────────┘
```

## Components

| File | Port | Description |
|------|------|-------------|
| `tick.q` | 5010 | Tick plant — receives updates from feed, logs to disk, and publishes to subscribers |
| `tick/u.q` | — | Publish-subscribe utility functions |
| `tick/sym.q` | — | Table schema definitions |
| `tick/feed.q` | — | Synthetic data feed, publishes trade and quote updates every second |
| `tick/rdb.q` | 5011 | Real-time database, holds today's data in memory |
| `tick/hdb.q` | 5012 | Historical database, queries on-disk partitioned data |
| `tick/rts.q` | 5013 | Real-time summary, maintains latest trade/quote per symbol |

## Data Model

**Trade table**
| Column | Type | Description |
|--------|------|-------------|
| time | timespan | Timestamp of trade |
| sym | symbol | Instrument symbol |
| price | float | Trade price |
| size | long | Trade size |
| side | symbol | Buy (`B`) or Sell (`S`) |
| ex | symbol | Exchange |
| uniqueId | char | Unique trade identifier |

**Quote table**
| Column | Type | Description |
|--------|------|-------------|
| time | timespan | Timestamp of quote |
| sym | symbol | Instrument symbol |
| ask | float | Ask price |
| bid | float | Bid price |
| askSize | long | Ask quantity |
| bidSize | long | Bid quantity |
| mode | long | Quote mode |

**Symbols:** `APPL` `MSFT` `AMZN` `GOOGL` `TSLA` `META`

**Exchanges:** `NYSE` `NASDAQ` `BATS` `ARCA`

## Getting Started

### Prerequisites

- KDB+ / q (free 32-bit version available at [kx.com](https://kx.com))

### Running the Stack

Open a separate terminal for each process and start them in order:

```bash
# 1. Start the tick plant
q tick.q sym . -p 5010

# 2. Start the real-time database
q tick/rdb.q :5010 -p 5011

# 3. Start the historical database
q sym -p 5012

# 4. Start the data feed
q tick/feed.q :5010

# 5. (Optional) Start the real-time summary
q tick/rts.q -p 5013
```

### Example Queries

```q
/ On the RDB (port 5011) — query today's trades
select from trade where sym=`MSFT

/ Get last price per symbol
select last price by sym from trade

/ On the HDB (port 5012) — query historical data
select from trade where date=2025.09.10, sym=`AAPL

/ On the RTS (port 5013) — get latest prices
lastTrade
latestSymPrice
```

## Historical Data

The `sym/` directory contains pre-loaded sample data partitioned by date:

```
sym/
├── 2025.09.09/
├── 2025.09.10/
├── 2025.09.11/
├── 2025.09.12/
└── 2025.09.13/
    ├── trade/   (time, sym, price, size, side, ex, uniqueId)
    └── quote/   (time, sym, ask, bid, askSize, bidSize, mode)
```
