## Specification

### Requirements

* You should be able to interact with your code via a REPL like IRB or the JavaScript console.  (You don't need to implement a command line interface that takes input from STDIN.)
* Deposits, withdrawal.
* Account statement (date, amount, balance) printing.
* Data can be kept in memory (it doesn't need to be stored to a database or anything).

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

## Approach
- I originally considered using an Array, with sub arrays, to store information of transactions, this was because I considered that it would be easier to display a statement in chronological order if all entries were added to the array in order of occurence
- I eventually elected for a hash, I considered this to be more scaleable if there was ever an intention to provide more reporting on withdrawals or deposits individually.
  - I was going to use the dates as keys in the key-value pairs for my hash, however, this would be confusing when handling multiple transactions on the same day. 
- I also used an integer instance variable for storing the current balance. 

I decided 