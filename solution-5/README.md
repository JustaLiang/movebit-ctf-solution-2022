## Solution for MoveCTF-5

#### [move lock](https://movectf.movebit.xyz/challenges#move%20lock-8)

##### Test if successfully unlock
```
sui move test
```

##### Publish module
```
sui client publish --gas-budget 10000
```

##### Sui CLI client call
```
sui client call --package 0x267be0315740b697764186c0c27a70bb8bc1bda8 --module move_unlock --function catch_flag --args 0xd33b791a1fa290647e20075f7e55f04297d3ec5 --gas-budget 1000
```