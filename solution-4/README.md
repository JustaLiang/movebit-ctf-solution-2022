## Solution for MoveCTF-4

#### [flash loan](https://movectf.movebit.xyz/challenges#flash%20loan-7)

##### Publish module
```
sui client publish --gas-budget 10000
```

##### Sui CLI client call
```
sui client call --package 0x6182b8e08ae7bcdc4c93efb20a9db5eef67fb297 --module flash_loan --function catch_flag --args 0x366a00bd94e304a51bdf5e225907854d242813f1 --gas-budget 1000
```