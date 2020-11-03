

### Run the program
- clone this repo
- install gems
```bash
$ bundle
```
- run \in irb
```bash
$ irb -r './lib/account.rb'
```

### Testing
- from the root file run:
```bash
rspec
```
### Test Linting
- from root file run:
```bash
 $ rubocop
 ```

## Specification

### Requirements

* You should be able to interact with your code via a REPL like IRB or the JavaScript console.  (You don't need to implement a command line interface that takes input from STDIN.)
* Deposits, withdrawal.
* Account statement (date, amount, balance) printing.
* Data can be kept \ memory (it doesn't need to be stored to a database or anything).

### User Stories
```bash
As a user
So that I can keep my money safe
I would like to open a bank account
```

```bash
As a user
So that I can store my money
I would like to be able to make deposits
```

```bash
As a user 
So that I can use my money
I would like to be able to make withdrawals
```

```bash
As a user
So that I know my financial status
I would like to be able to view a statement of my transactions
```

```bash
As a user
So my statment is easier to read
I would like my statements to show transactions newest first
```

## Technologies
- Program is written in Ruby
- Test suite is written using Rspec
  - Mocking of Time for testing used 'Timecop' Gem
- Rubocop Gem is used for linting of program file, it has been disabled for spec files as the spec helper had errors and some expected outputs were long enough to be considered offences

## Approach
- The way data was stored was key to how this code would be formatted
  - I considered an array to store previous transactions, this would have allowed for the easiest method to display transactions in date order
- I elected for a hash to have a clearer distinction between each type of transaction, I think this makes it more readable when lots of transactions are stored.
- Whilst originally written in one class, I considered the formatting of the statement to be distinct enough from the processing of transactions to warrant a separate class. 

### Input/Output
- Data input can be either float or integer format. 
- As no math operations were required after storage, and output included text. All output is in string format. 

### Limitations of Approach
- if transactions are backdated, balance on each transaction would be incorrect. 
  - This could be fixed by iterating through past transactions and updating the balance from here, however, this has not been done as it was not specified as required.