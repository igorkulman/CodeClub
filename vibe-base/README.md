# VibeBase

## Description

Welcome back to the Cookielab Code Club Puzzle System (CCCP(S))! This week, we have a special vibe-code-themed puzzle for you to tackle.
Introduction

You have been assigned a vibe-coded project from a client to help and make a sense of. The client has vibe-coded a block chained-based, cryptocurrency-promoting, matcha-themed Labubu reseller site. (If you have no idea what this word salad means, you are a very lucky person. Do not look any of it up.)

However, the project is so convoluted, they have no idea if they are making any money. On top of it all, the "database" used for the project is made up completely by a delirious Grok 3 model. Who would have guessed something like this might happen!

Your task then, should you choose to accept it, is quite straightforward:
- Parse the database
- Find the `sales` and `expenses` tables
- Subtract the sum of `expense_value` column from the sum of the `sale_value` column
- Your puzzle result will be the final result a. If you are curious, the currency is Doge Coin

## Database Specification

Fortunately, the delirious Grok 3 instance has left some notes on how the database file is structured.

## Headers

The first part is the table headers. Each line denotes a single table definition. However, there may be multiple tables with different definition in the same database. How this feature works is unclear, and even Grok does not know.

The header consists of table name, list of column names and position. These values are delimited by `|`. The column names are delimited by `,`. The position indicates on which position is the data rows stored.

An example header line would be:

```
labubu|title,status|25
```

## Data

The second part immediately follows the header parts. Each line represents a single row for the associated table.

An example data row line would be:

```
12345;90876
```

The data rows are divided into chunks. Each chunk is the same size as the table count. So, the first line of data belongs to the table with position `0`, the next to the table with position `1` and so on. Once the table count is reached, the next chunk again starts at position `0`.

Not every table has the same number of rows. This means that there may be empty data lines. These lines can be ignored.

Every piece of data is represented as an integer. Why the database only stores data this way is also unclear. When prompted, Grok looped itself trying to sell the client x.com Premium subscription over and over again.

### Task Specification

Your task is to parse two tables from the database with their financial columns:

- `sales` - `sale_value`
- `expenses` - `expense_value`

Fortunately, the sales integers can be used directly and do not have to be decoded in any way.

Once you have both databases parsed, sum up the values from the specified columns. Your result will be `result = SUM(sale_value) - SUM(expense_value)`.
