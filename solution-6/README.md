## Solution for MoveCTF-6

#### [simple game](https://movectf.movebit.xyz/challenges#simple%20game-9)

##### Publish module
```
sui client publish --gas-budget 10000
```

##### Sui CLI client call
```
sui client call --package 0x267be0315740b697764186c0c27a70bb8bc1bda8 --module open_box --function get_treasury_box --args 0xf455500e2f33d69caca33b4182e8a8d54ba14913 --gas-budget 1000000
sui client call --package 0x267be0315740b697764186c0c27a70bb8bc1bda8 --module open_box --function catch_flag --args 0xd33b791a1fa290647e20075f7e55f04297d3ec5 --gas-budget 1000000
```